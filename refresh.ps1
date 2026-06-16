# Updater LOCAL confiavel: regenera o(s) dado(s) e da push.
# Chamado pelo Agendador de Tarefas do Windows (1 task por cadencia).
# Auth do push: token guardado em .git/config do repo (origin). NAO revogar esse token.
param([ValidateSet('traffic','objections','insights','all')][string]$Mode='traffic')
$ErrorActionPreference = 'Stop'
$env:GIT_EDITOR = 'true'
$root = 'C:\dev\cocktail-dash'
Set-Location $root
$files = switch($Mode){
  'traffic'    { @('data.js') }
  'objections' { @('data-obj.js') }
  'insights'   { @('data-insights.js') }
  default      { @('data.js','data-obj.js','data-insights.js') }
}
$log = Join-Path $root 'refresh.log'
function Log($m){ Add-Content $log ("{0}  [{1}]  {2}" -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'), $Mode, $m) }
try {
  if (Test-Path (Join-Path $root '.git/rebase-merge')) { git rebase --abort 2>$null }
  # sincroniza com o remoto ANTES de buildar; arquivos sao 100% regenerados, entao nunca ha conflito
  git fetch origin | Out-Null
  git reset --hard origin/main | Out-Null
  & powershell.exe -ExecutionPolicy Bypass -NoProfile -File (Join-Path $root 'build.ps1') -Mode $Mode | Out-Null
  git add $files
  if (git status --porcelain $files) {
    git commit -m ("auto-local: $Mode " + (Get-Date -Format 'yyyy-MM-dd HH:mm')) | Out-Null
    git push origin HEAD:main | Out-Null         # sem 2>&1 (PS5.1 transforma stderr nativo em erro fatal)
    if ($LASTEXITCODE -eq 0) { Log "push OK" } else { Log "push FALHOU (exit $LASTEXITCODE) - proximo ciclo corrige" }
  } else { Log "sem mudancas" }
} catch { Log ("ERRO: " + $_.Exception.Message) }

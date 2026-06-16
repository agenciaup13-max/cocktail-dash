# Local auto-refresh: rebuild data.js and push to GitHub.
# Use this if you prefer the update to run from THIS PC (Task Scheduler) instead of GitHub Actions.
$ErrorActionPreference = 'Stop'
Set-Location -Path 'C:\dev\cocktail-dash'
$log = 'C:\dev\cocktail-dash\refresh.log'
function Log($m){ Add-Content $log ("{0}  {1}" -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'), $m) }
try {
  & powershell -ExecutionPolicy Bypass -File '.\build.ps1' | Out-Null
  git add data.js data.json
  $changed = git status --porcelain
  if ($changed) {
    git commit -m ("auto: refresh dados " + (Get-Date -Format 'yyyy-MM-dd HH:mm')) | Out-Null
    git push | Out-Null
    Log "OK push"
  } else { Log "sem mudancas" }
} catch { Log ("ERRO: " + $_.Exception.Message) }

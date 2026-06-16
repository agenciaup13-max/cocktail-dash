# Dashboard — Cocktail Cardi Nigro (Funil Meta Ads)

Dash visual que cruza **3 fontes** (somente leitura, nada é alterado nas planilhas):

| Fonte | Aba / planilha | Papel |
|---|---|---|
| Queries (Meta) | `1RJC_…` | Gasto, impressões, cliques, LP views por dia × campanha × conjunto × anúncio |
| Leads | aba **leads para tráfego** (`1WuETd…`) | Leads, qualificação e atribuição (utm) |
| Compras | aba **clientes kiwify compra** (`1WuETd…`) | Vendas (status `paid`) |

## Regras de cálculo (validadas contra a print de 01–19/mai)

- **Imposto:** gasto × **1,1385**
- **Lead qualificado (QLF):** resposta de *faturamento mensal* **acima de R$ 100 mil**
  (`Entre R$ 100 mil e R$ 200 mil` + `Acima de 200 mil`)
- **CPL QLF** = gasto c/ imposto ÷ leads qualificados · **CAC** = gasto c/ imposto ÷ vendas
- **Atribuição lead → anúncio:** `utm_campaign`=Campanha · `utm_medium`=Conjunto · `utm_content`=Anúncio (código ADxx)
- **Atribuição da venda:** e-mail do comprador (Kiwify) → lead → utm da campanha
  (Kiwify não tem utm próprio; ~87/126 compradores casam por e-mail)

A janela 01–19/mai reproduz a print exatamente: Invest. R$ 17.350,24 · 749 leads · 192 QLF · CPL QLF R$ 90,37 · 22 vendas · CAC R$ 788,65.

## Como funciona

- `build.ps1` baixa as 3 planilhas (export CSV `gviz`), cruza tudo e gera `data.js` (+ `data.json`).
- `index.html` + `app.js` + `styles.css` é uma página estática que lê `data.js` — sem servidor, sem dependências externas.
- **Atualização a cada 3h:** GitHub Actions (`.github/workflows/refresh.yml`) roda o `build.ps1` e dá commit do dado novo; o GitHub Pages publica.
  - Alternativa local: `refresh.ps1` via Agendador de Tarefas do Windows.

## Recursos da dash

- Seletor de período (presets + datas customizadas) com comparação período-a-período.
- Funil completo: Impressões/CPM, Cliques/CPC/CTR, Page Views/CPV, Leads/CPL, **Lead QLF/CPL QLF**, Vendas/CAC + ROAS.
- Gráficos por dia: Leads × Qualificados e Investimento × CPL QLF.
- Tabelas de **otimização micro** ordenáveis (Campanha / Conjunto / Anúncio) com CPL QLF colorido (meta R$ 150).
- **Vendas por campanha** (cruzamento comprador × lead) com ticket médio e CAC.

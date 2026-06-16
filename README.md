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

- `build.ps1 -Mode <traffic|objections|insights|all>` baixa as 3 planilhas (export CSV `gviz`), cruza tudo e escreve o(s) arquivo(s) de dados.
- `index.html` + `app.js` + `styles.css` é uma página estática (3 abas) que lê `data.js`, `data-obj.js` e `data-insights.js` — sem servidor, sem dependências externas.
- A prosa dos insights (PT-BR) fica no `app.js`; o `build.ps1` só emite os DADOS estruturados (roda igual em qualquer locale).

### Cadências (3 workflows GitHub Actions, cada um commita só o seu arquivo)

| Aba | Arquivo | Workflow | Frequência |
|---|---|---|---|
| Tráfego (funil) | `data.js` | `refresh.yml` | a cada **3h** |
| Objeções | `data-obj.js` | `refresh-obj.yml` | **diário** |
| Insights | `data-insights.js` | `refresh-insights.yml` | **semanal** (segunda) |

> Cada workflow faz `git pull --rebase` antes do push; como tocam arquivos diferentes, não há conflito.

## Recursos da dash

- Seletor de período (presets + datas customizadas) com comparação período-a-período.
- Funil completo: Impressões/CPM, Cliques/CPC/CTR, Page Views/CPV, Leads/CPL, **Lead QLF/CPL QLF**, Vendas/CAC + ROAS.
- Gráficos por dia: Leads × Qualificados e Investimento × CPL QLF.
- Tabelas de **otimização micro** ordenáveis (Campanha / Conjunto / Anúncio) com CPL QLF colorido (meta R$ 150).
- **Vendas por campanha** (cruzamento comprador × lead) com ticket médio e CAC.
- **Aba Objeções:** principal desafio dos qualificados × compradores, índice de compra e depoimentos reais ("na voz delas").
- **Aba Insights:** análises automáticas (regras) cruzando macro + micro + objeções, com ação recomendada por card. Ancorado no produto (evento presencial p/ mulheres +100k que querem escalar).

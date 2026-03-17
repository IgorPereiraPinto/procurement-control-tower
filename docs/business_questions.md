# ❓ Business Questions — Perguntas de Negócio

## Contexto

A Procurement Control Tower foi desenhada para apoiar decisões de Procurement em um ambiente de indústria de alimentos, no qual a área precisa migrar de um modelo centrado em consolidação manual para um modelo orientado por dados, riscos, oportunidades e impacto financeiro.

Para isso, a solução deve responder a perguntas de negócio claras, conectadas aos módulos analíticos do projeto.

---

## Objetivo

Organizar as principais perguntas que a solução precisa responder para gerar valor real à área de Procurement, orientar o desenho dos KPIs e apoiar o storytelling executivo.

---

## Perguntas por Módulo

### 📦 Módulo 1 — Spend Overview

| Pergunta | Decisão que apoia |
|---|---|
| Quanto a empresa está gastando por período? | Monitoramento de orçamento e tendência |
| Quais categorias concentram maior volume de spend? | Priorização de esforço analítico |
| Quais fornecedores concentram maior participação no gasto total? | Identificação de dependência e risco |
| Como o spend está evoluindo ao longo do tempo? | Leitura de tendência e sazonalidade |
| Onde há maior concentração de gasto por fornecedor ou categoria? | Diversificação e redução de exposição |

---

### 💰 Módulo 2 — Savings & Budget

| Pergunta | Decisão que apoia |
|---|---|
| Quanto de savings foi realizado no período? | Avaliação de performance financeira |
| Qual o savings potencial estimado por categoria? | Priorização de renegociação |
| Quais categorias estão acima do orçamento? | Controle de desvio e realinhamento |
| Onde o custo atual está acima do benchmark esperado? | Identificação de gaps e oportunidades |
| Quais frentes devem ser priorizadas para renegociação? | Direcionamento do esforço de sourcing |

---

### ⚠️ Módulo 3 — Supplier Risk

| Pergunta | Decisão que apoia |
|---|---|
| Quais fornecedores apresentam maior risco operacional? | Priorização de ação preventiva |
| Onde há atraso recorrente de entrega? | Gestão de SLA e continuidade |
| Quais fornecedores concentram volume excessivo em uma categoria? | Redução de dependência crítica |
| Quais categorias estão mais expostas a poucos fornecedores? | Diversificação estratégica |
| Onde não conformidade e atraso podem afetar custo ou continuidade? | Mitigação de risco operacional e financeiro |

---

### 📐 Módulo 4 — Cost Model

| Pergunta | Decisão que apoia |
|---|---|
| Quais categorias estão sofrendo maior pressão de custo? | Priorização de negociação e revisão de contrato |
| Qual o impacto de logística, benchmark ou sinais de mercado sobre o custo? | Contextualização de decisões de sourcing |
| Quais categorias devem ser priorizadas em discussões de sourcing? | Alocação de esforço estratégico |
| Onde a variação de mercado pode comprometer savings ou orçamento? | Antecipação de riscos financeiros |
| Como priorizar categorias por risco e oportunidade financeira? | Construção do pipeline de iniciativas |

---

### ✅ Módulo 5 — Data Quality

| Pergunta | Decisão que apoia |
|---|---|
| Quais fontes apresentam maior incidência de erro? | Priorização de correção e governança |
| Onde há problemas de completude, duplicidade ou consistência? | Garantia de confiabilidade analítica |
| Quais divergências podem comprometer a leitura de spend e savings? | Validação antes do consumo executivo |
| Quais dados exigem reconciliação antes de relatórios executivos? | Proteção da credibilidade dos reports |
| Onde o processo precisa de maior disciplina de governança? | Melhoria contínua da camada de dados |

---

### ⚙️ Módulo 6 — Automation Monitor

| Pergunta | Decisão que apoia |
|---|---|
| Quais etapas do processo ainda dependem de esforço manual? | Identificação de alvos de automação |
| Onde há maior incidência de falha operacional? | Priorização de correção de processo |
| Quais fluxos devem ser automatizados primeiro? | Sequenciamento do roadmap de automação |
| Como alertar desvios críticos de forma padronizada? | Redução de tempo de resposta a problemas |
| Onde a automação pode reduzir retrabalho e aumentar rastreabilidade? | Ganho de eficiência e confiabilidade |

---

## Relação com a Tomada de Decisão

Cada pergunta foi estruturada para contribuir com pelo menos um dos objetivos abaixo:

| Objetivo | Módulos relacionados |
|---|---|
| Aumentar visibilidade | Spend Overview, Cost Model |
| Reduzir esforço manual | Automation Monitor |
| Melhorar priorização de categorias | Savings & Budget, Cost Model |
| Identificar risco | Supplier Risk, Data Quality |
| Destacar oportunidade | Savings & Budget, Cost Model |
| Apoiar negociação | Spend Overview, Cost Model, Supplier Risk |
| Melhorar a confiança nos dados | Data Quality |

---

## Aplicação Prática

Estas perguntas servem como referência para:

- definição e priorização dos KPIs
- desenho das páginas e fluxo do dashboard
- estruturação das recomendações executivas
- organização das regras de negócio na camada SQL
- priorização dos fluxos de automação

---

## Posicionamento Final

> Uma solução de Procurement madura não começa pelo gráfico — começa pelas **perguntas certas**. Este documento organiza as perguntas que dão direção ao projeto e garantem que os outputs gerados tenham valor real para o negócio.

---

*[← Voltar para docs/README.md](./README.md)*

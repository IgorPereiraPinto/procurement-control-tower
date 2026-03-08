# Procurement Control Tower

## Overview
Procurement Control Tower is an end-to-end analytics and process automation case developed for a fictional food industry company, **PrimeHarvest Foods Brasil**.

The project simulates a senior-level Procurement BI and Automation initiative designed to improve visibility over spend, supplier performance, cost drivers, data quality, and operational workflows. It combines analytical thinking, process design, governance, and executive storytelling to support sourcing and renegotiation decisions.

Although the scenario uses fictional data and a fictional company name, the business logic, architecture, and deliverables were designed to closely reflect real corporate challenges in the food manufacturing industry.

---

## Business Context
PrimeHarvest Foods Brasil is a fictional food company operating in categories such as sauces, condiments, processed vegetables, packaging, and logistics. The Procurement team manages direct and indirect categories and needs more reliable, scalable, and automated analytical support to reduce manual effort and improve decision-making.

The business scenario behind this project assumes common Procurement pain points:

- fragmented spreadsheets and manual consolidations
- limited traceability across files and updates
- difficulty identifying savings opportunities
- lack of standardized supplier risk monitoring
- absence of automated business alerts
- inconsistent data quality checks
- low visibility into the impact of market signals on purchasing categories

---

## Project Objective
The objective of this repository is to demonstrate how a senior BI / Data / Automation professional could structure a complete Procurement analytics solution with:

- SQL-based dataset consolidation
- data quality and reconciliation logic
- business-oriented KPI design
- workflow automation concepts using Power Automate
- operational standardization using VBA
- an executive dashboard experience inspired by Power BI
- recommendations focused on risk, opportunity, and financial impact

---

## Core Modules
The solution is structured into six business modules:

### 1. Spend Overview
Provides visibility into total spend, spend by category, spend by supplier, and monthly variation.

### 2. Savings & Budget
Monitors savings delivered, savings potential, and deviations versus budget or benchmark references.

### 3. Supplier Risk
Tracks supplier concentration, delivery delays, quality events, and an overall supplier risk score.

### 4. Cost Model
Connects market signals such as commodity pressure, logistics cost, and currency variation to category-level cost impact.

### 5. Data Quality
Applies validation, reconciliation, and traceability rules to improve confidence in Procurement reporting.

### 6. Automation Monitor
Documents workflow automation concepts for file intake, validation, refresh orchestration, alerting, and exception handling.

---

## Repository Structure

```text
docs/        -> business documentation, KPI catalog, operating model, glossary and executive summary
sql/         -> SQL logic for staging, cleaning, business rules, quality checks and marts
automate/    -> Power Automate flow documentation and process design
vba/         -> VBA use case for spreadsheet standardization and intake preparation
dashboard/   -> HTML dashboard prototype inspired by a Power BI executive experience
outputs/     -> illustrative screenshots and visual artifacts used in the portfolio narrative


Stack Tecnológica Simulada

Este projeto foi concebido como um case de portfólio e utiliza uma stack corporativa simulada, baseada em ferramentas normalmente encontradas em ambientes de analytics para Procurement:

SQL Server para extração de dados, joins, consolidação e criação de marts analíticos

Excel para templates de entrada de dados e controles operacionais

Power Automate para automação de workflows, validação e alertas

VBA para padronização de planilhas e pré-processamento operacional

Power BI como referência conceitual para desenho de dashboard e modelagem analítica

HTML / CSS / JavaScript para um protótipo didático de dashboard que se aproxima visualmente de uma experiência em Power BI

Valor de Negócio Esperado

A solução foi pensada para gerar valor para o negócio das seguintes formas:

reduzir esforço manual nas rotinas de reporting de Procurement

melhorar a confiabilidade e a rastreabilidade dos dados

aumentar a velocidade de resposta para compradores e gestores de categoria

apoiar a estratégia das categorias com insights de custo baseados em mercado

identificar riscos de fornecedores e oportunidades de negociação

fornecer storytelling executivo para tomada de decisão

O Que Este Projeto Demonstra

Este repositório foi construído para demonstrar experiência em:

pensamento orientado a Power BI: desenho de modelo, definição de KPIs e visualização executiva

lógica SQL para criação de datasets, consistência e transformação analítica

desenho de automações de processo com monitoramento e tratamento de exceções

governança de qualidade de dados e checkpoints de reconciliação

storytelling de negócio com enquadramento de risco, oportunidade e recomendação

estruturação de projeto em nível sênior para um caso corporativo realista

Nota Importante

Este é um case fictício de portfólio, criado para fins didáticos e de demonstração.

Nenhum dado privado de empresa, processo interno ou informação proprietária é utilizado neste repositório.

O nome da empresa, os exemplos de dados e os materiais de apoio são fictícios. O propósito é simular uma solução robusta de analytics para Procurement, alinhada a um ambiente de negócio real.

Próximos Passos

Evoluções futuras para este case podem incluir:

cenários preditivos de custo por categoria

modelos de segmentação de fornecedores

lógica de forecast para categorias sensíveis a commodities

maior interatividade do dashboard

ingestão de sinais de mercado via APIs

expansão do operating model e das rotinas de sustentação

Perspectiva do Autor

Este projeto foi estruturado como se fizesse parte de uma iniciativa real de transformação em Procurement, com forte ênfase em clareza de negócio, manutenibilidade, prontidão para automação e suporte à decisão.

Ele foi pensado para ser apresentado como um case sênior de analytics e automação em contextos de portfólio profissional e entrevistas.

EU CONTINUO NÃO ENTENDO PORQUE OS TEXTOS ABAIXO FAZEM PARTE DO READ.ME MAS NÃO ESTÃO EM FORMATO MARKDOWN

COMO POSSO INSERIR-LOS NO READ.ME


Pensou por alguns segundos

Esses textos já estão em Markdown.

O ponto que está te confundindo é este:

Markdown não é só bloco de código

Em Markdown, texto normal também é Markdown

Você só usa cercas com ``` quando quer mostrar:

código

estrutura de pastas

comando

exemplo literal

Resumo

No README.md, a maior parte do conteúdo será mesmo assim:

títulos com #, ##, ###

texto normal em parágrafos

listas com -

negrito com **texto**

Isso já é Markdown.

Como identificar o que é Markdown e o que é texto comum

Veja este exemplo:

# Título

## Subtítulo
Este é um parágrafo normal em Markdown.

- item 1
- item 2

**texto em negrito**

Tudo isso acima é Markdown.

Ou seja, esta parte:

## Visão Geral
Procurement Control Tower é um case ponta a ponta...

já está correta.

Você não precisa colocar esse parágrafo dentro de bloco com ```.

Quando usar bloco com ```

Você usa bloco de código apenas em casos como estes:

1. Estrutura de pastas
docs/
sql/
automate/
vba/
dashboard/
outputs/
2. Código SQL
SELECT *
FROM f_purchase_orders;
3. HTML
<div class="card">KPI</div>
O que entra no README sem bloco de código

Estas seções ficam como texto Markdown normal:

Visão Geral

Contexto de Negócio

Objetivo do Projeto

Módulos Principais

Stack Tecnológica Simulada

Valor de Negócio Esperado

O Que Este Projeto Demonstra

Nota Importante

Próximos Passos

Perspectiva do Autor

O que entra no README com bloco de código

Normalmente só isso:

estrutura do repositório

algum comando

algum exemplo técnico

Exemplo prático: como colar no README

No arquivo README.md, você cola assim mesmo:

# Procurement Control Tower

## Visão Geral
Procurement Control Tower é um case ponta a ponta de analytics e automação de processos desenvolvido para uma empresa fictícia do setor alimentício, a **PrimeHarvest Foods Brasil**.

## Contexto de Negócio
A PrimeHarvest Foods Brasil é uma empresa fictícia do setor de alimentos que atua em categorias como molhos, condimentos, vegetais processados, embalagens e logística.

## Estrutura do Repositório

```text
docs/
sql/
automate/
vba/
dashboard/
outputs/

Perceba:
- os parágrafos ficam normais
- só a estrutura entra em bloco

---

# Regra simples para você usar daqui para frente
## Use texto normal Markdown quando for:
- explicar
- descrever
- contextualizar
- listar benefícios
- apresentar objetivo

## Use bloco com ``` quando for:
- mostrar código
- mostrar árvore de pastas
- mostrar comando
- mostrar exemplo técnico literal

---

# Resposta direta à sua dúvida
Você pode inserir esses textos no `README.md` **diretamente**, sem fazer nada especial.

Exemplo:
- abra o `README.md`
- cole o conteúdo
- salve

Os trechos como:

```markdown
## Valor de Negócio Esperado
A solução foi pensada para gerar valor...

estão corretos assim.

Onde estava a confusão

Você provavelmente associou “formato Markdown” com “bloco cercado por ```”.

Mas isso é só um tipo de elemento Markdown.

Na prática:

# Título = Markdown

## Subtítulo = Markdown

- item = Markdown

**negrito** = Markdown

parágrafo normal = Markdown

bloco com ``` = Markdown também

Tudo faz parte da mesma linguagem.

Exemplo final pronto

Abaixo está um mini exemplo real de README corretamente formatado:

# Procurement Control Tower

## Visão Geral
Este projeto simula uma solução de analytics para Procurement em uma empresa fictícia do setor alimentício.

## Objetivo do Projeto
Demonstrar uma abordagem sênior de BI, automação e qualidade de dados.

## Estrutura do Repositório

```text
docs/
sql/
automate/
vba/
dashboard/
outputs/
Próximos Passos

expandir o dashboard

incluir novos fluxos

evoluir a camada analítica


Se você colar isso no GitHub, ele vai renderizar corretamente.

Na próxima resposta, eu posso te entregar o `README.md` **com comentários linha a linha explicando o que é título, o que é parágrafo e o que é bloco técnico**, para você nunca mais ter essa dúvida.

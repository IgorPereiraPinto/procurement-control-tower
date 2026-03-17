# 🧩 Solution Scope — Escopo da Solução

## Contexto

A Procurement Control Tower foi definida como uma solução ponta a ponta de business intelligence e suporte operacional para uma empresa fictícia do setor alimentício. Seu desenho reflete as necessidades de uma área de Procurement que exige maior visibilidade, dados mais confiáveis, disciplina de processo e melhor suporte analítico para sourcing e negociação.

A proposta não busca simular todo o landscape de uma empresa. Em vez disso, concentra-se em um conjunto selecionado de casos de uso de maior valor para Procurement — suficientes para demonstrar uma iniciativa robusta e realista em nível sênior.

---

## Módulos Funcionais

O projeto cobre seis módulos que representam as principais necessidades analíticas e operacionais do contexto de Procurement.

---

### 📦 Módulo 1 — Spend Overview

Visibilidade sobre os gastos de Procurement ao longo do tempo, por categoria e por fornecedor.

| Incluído no escopo | Relevância de negócio |
|---|---|
| Gasto total e evolução mensal | Entender para onde os recursos estão sendo alocados |
| Gasto por categoria e por fornecedor | Identificar concentração e prioridades de análise |
| Análise de concentração de spend | Subsidiar revisões de categoria e decisões de sourcing |

---

### 💰 Módulo 2 — Savings & Budget

Controle de custo e identificação de oportunidades de renegociação.

| Incluído no escopo | Relevância de negócio |
|---|---|
| Savings realizados e potenciais | Migrar de leitura descritiva para orientada à ação |
| Desvio versus orçamento e benchmark | Apoiar disciplina financeira e identificar gaps |
| Priorização de oportunidades | Direcionar esforço de negociação com foco em impacto |

---

### ⚠️ Módulo 3 — Supplier Risk

Visão estruturada da exposição e vulnerabilidade da base de fornecedores.

| Incluído no escopo | Relevância de negócio |
|---|---|
| Concentração e dependência de fornecedores | Identificar riscos de continuidade por categoria |
| Indicadores de atraso e não conformidade | Monitorar sinais de deterioração operacional |
| Score de risco por fornecedor | Priorizar ações preventivas antes de impactos reais |

---

### 📐 Módulo 4 — Cost Model

Conexão entre dados de Procurement e direcionadores de custo que afetam a performance das categorias.

| Incluído no escopo | Relevância de negócio |
|---|---|
| Pressão de custo por categoria | Entender quais forças externas afetam cada categoria |
| Impacto de logística, benchmarks e sinais de mercado | Contextualizar decisões de renegociação |
| Raciocínio por cenário para sourcing | Suportar discussões estratégicas com inteligência de custo |

---

### ✅ Módulo 5 — Data Quality

Controles para aumentar a confiabilidade e a rastreabilidade da informação de Procurement.

| Incluído no escopo | Relevância de negócio |
|---|---|
| Regras de validação e checks de reconciliação | Garantir consistência antes do consumo analítico |
| Controles de completude e consistência estrutural | Reduzir erros que comprometem a credibilidade dos reports |
| Lógica de rastreabilidade nos outputs | Sustentar a confiança da liderança nos números reportados |

---

### ⚙️ Módulo 6 — Automation Monitor

Documentação de conceitos de automação de workflow para reduzir esforço manual e aumentar consistência de processo.

| Incluído no escopo | Relevância de negócio |
|---|---|
| Workflow de recebimento e validação de arquivos | Padronizar a entrada de dados e eliminar retrabalho |
| Orquestração de atualização e alertas de negócio | Manter o ciclo analítico funcional com menor dependência humana |
| Lógica de exceção e monitoramento | Garantir rastreabilidade e resposta rápida a falhas de processo |

---

## Escopo Técnico

Do ponto de vista técnico, o projeto inclui:

- documentação de negócio e contexto analítico
- desenho conceitual do modelo de dados
- camada SQL estruturada em staging, cleaning, business rules, quality checks e marts
- documentação dos fluxos de Power Automate
- documentação do caso de uso em VBA
- protótipo de dashboard em HTML com experiência visual próxima ao Power BI
- outputs visuais e prints para narrativa de portfólio

---

## Fora do Escopo

Os itens abaixo foram intencionalmente excluídos deste case:

| Item | Motivo da exclusão |
|---|---|
| Dados reais de empresa | Case fictício para fins de portfólio |
| Integração com APIs ou sistemas corporativos reais | Fora do objetivo do projeto |
| Implantação em produção | Escopo de demonstração, não de entrega produtiva |
| Modelo de segurança e controle de acesso | Não aplicável a ambiente fictício |
| Infraestrutura em nuvem configurada | Fora do escopo técnico deste case |
| Arquitetura em tempo real | Complexidade além do objetivo de portfólio |

---

## Por que este escopo faz sentido

O escopo selecionado é amplo o suficiente para demonstrar senioridade em business intelligence, automação, governança e storytelling, mas permanece focado nos casos de uso mais relevantes para Procurement em uma indústria de alimentos.

Além disso, cria uma base clara para evoluções futuras, como modelos preditivos, simulações de custo mais sofisticadas e inteligência de sourcing mais avançada.

---

## Posicionamento Final

> A Procurement Control Tower não foi pensada como apenas um dashboard. Ela foi escopada como uma **solução analítica estruturada**, que combina suporte à decisão, pensamento de processo e disciplina operacional para demonstrar como analytics em Procurement pode ser construído com profundidade de negócio e maturidade técnica.

---

*[← Voltar para docs/README.md](./README.md)*

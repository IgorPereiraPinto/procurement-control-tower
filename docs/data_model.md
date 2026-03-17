# 🗃️ Data Model — Modelo de Dados

## Contexto

A Procurement Control Tower exige uma base analítica organizada, capaz de suportar leitura executiva, rastreabilidade e flexibilidade para análise por período, categoria, fornecedor e processo.

---

## Abordagem de Modelagem

O projeto adota uma lógica inspirada em **modelo estrela**, favorecendo clareza analítica, facilidade de manutenção, reutilização de dimensões, consistência nas métricas e aderência a dashboards executivos.
```text
                    d_calendar
                        │
          d_supplier ───┤
                        │
d_category ─────── [FATO] ─────── d_material
                        │
          d_contract ───┤
                        │
                    d_region
```

---

## Tabelas Fato

| Tabela | Descrição | Uso principal |
|---|---|---|
| `f_purchase_orders` | Pedidos de compra com valores, datas, fornecedor, material e categoria | Spend, lead time, desvio de preço, análise transacional |
| `f_spend_monthly` | Consolidação mensal de spend por categoria e fornecedor | Visão executiva, tendência e concentração |
| `f_supplier_delivery` | Eventos de entrega dos fornecedores | Atraso, SLA, lead time e supplier risk |
| `f_budget` | Orçamento de Procurement por categoria e período | Desvio vs orçamento e acompanhamento financeiro |
| `f_market_reference` | Referências de mercado e benchmarks de custo | Savings potencial, cost model e negociação |
| `f_quality_events` | Não conformidades e eventos de qualidade por fornecedor | Risco, criticidade e confiabilidade de fornecimento |
| `f_automation_logs` | Eventos de execução dos fluxos automatizados | Monitoramento operacional e automation dashboard |

---

## Tabelas Dimensão

| Tabela | Descrição |
|---|---|
| `d_supplier` | Informações cadastrais e classificatórias do fornecedor |
| `d_category` | Classificação das categorias de Procurement |
| `d_material` | Informações sobre materiais, itens ou SKUs |
| `d_calendar` | Dimensão calendário para análise temporal |
| `d_region` | Informações regionais ou geográficas relevantes |
| `d_contract` | Dados de contrato e condições comerciais |
| `d_currency` | Padronização de moeda e conversão, quando aplicável |

---

## Relacionamentos Esperados

| Tabela fato | Dimensões relacionadas | Chave de relacionamento |
|---|---|---|
| `f_purchase_orders` | `d_supplier`, `d_category`, `d_material`, `d_calendar`, `d_contract` | supplier_id, category_id, material_id, date_id |
| `f_spend_monthly` | `d_supplier`, `d_category`, `d_calendar` | supplier_id, category_id, month_id |
| `f_supplier_delivery` | `d_supplier`, `d_calendar`, `d_region` | supplier_id, delivery_date_id |
| `f_budget` | `d_category`, `d_calendar` | category_id, period_id |
| `f_market_reference` | `d_category`, `d_calendar` | category_id, reference_date_id |
| `f_quality_events` | `d_supplier`, `d_calendar` | supplier_id, event_date_id |
| `f_automation_logs` | `d_calendar` | log_date_id |

---

## Benefícios do Modelo

| Benefício | Como se manifesta |
|---|---|
| Visão executiva consolidada | Fatos conectados a dimensões permitem agregações consistentes em qualquer nível |
| Drill por fornecedor, categoria e tempo | Dimensões reutilizáveis habilitam slicing sem redundância |
| Separação entre transacional e gerencial | Fatos distintos para operação e referência evitam mistura de granularidade |
| Governança simplificada das métricas | Definições centralizadas nas tabelas fato reduzem divergências |
| Aderência ao Power BI | Modelo estrela é o padrão recomendado para performance e manutenção em DAX |

---

## Aplicação no Projeto

Este modelo serve de base para todas as camadas da solução:

| Camada | Como o modelo é usado |
|---|---|
| SQL | Estrutura das queries de staging, marts e quality checks |
| KPIs | Métricas derivadas das tabelas fato com filtros dimensionais |
| Dashboard | Páginas construídas sobre as agregações do modelo |
| Storytelling executivo | Narrativas ancoradas em métricas consistentes e rastreáveis |

---

## Posicionamento Final

> Um modelo analítico bem estruturado é o que permite transformar múltiplas fontes desconectadas em uma **visão consistente de negócio**. Este documento define a espinha dorsal da Procurement Control Tower — a base sobre a qual toda a camada analítica, os KPIs e o storytelling executivo são construídos.

---

*[← Voltar para docs/README.md](./README.md)*

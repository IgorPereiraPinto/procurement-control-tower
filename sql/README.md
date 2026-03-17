# 🗄️ sql — Camada de Dados

## Contexto

Esta pasta reúne os scripts SQL que representam a estrutura de dados da **Procurement Control Tower**. Mesmo sendo um case fictício, os arquivos foram organizados como se fizessem parte de uma solução corporativa de analytics para Procurement.

A proposta é demonstrar como uma camada SQL poderia ser desenhada para transformar dados dispersos e operacionais em uma base analítica confiável, rastreável e pronta para consumo em dashboards e análises executivas.

---

## Arquitetura em Camadas

A lógica de transformação foi separada em cinco etapas sequenciais, seguindo boas práticas de engenharia analítica:
```text
[Fontes Brutas]
      │
      ▼
01_staging.sql       → Ingestão e padronização inicial
      │
      ▼
02_cleaning.sql      → Tratamento de nulos, tipos e inconsistências
      │
      ▼
03_business_rules.sql → Regras analíticas e derivação de KPIs
      │
      ▼
04_quality_checks.sql → Validação, reconciliação e integridade
      │
      ▼
05_marts.sql         → Visões e tabelas para consumo executivo
      │
      ▼
[Dashboard / Analytics]
```

---

## Estrutura dos Arquivos

| Arquivo | Camada | O que faz |
|---|---|---|
| `01_staging.sql` | Staging | Simula a ingestão e organização das tabelas de origem em camada inicial |
| `02_cleaning.sql` | Cleaning | Aplica tratamentos estruturais, padronização de campos e remoção de inconsistências |
| `03_business_rules.sql` | Business Rules | Implementa regras analíticas, classifica categorias e deriva indicadores de Procurement |
| `04_quality_checks.sql` | Quality Checks | Executa validações de integridade, completude e reconciliação entre fontes |
| `05_marts.sql` | Marts | Constrói as visões e tabelas finais para análise executiva e dashboard |

---

## Por que separar em camadas

| Benefício | Como se manifesta neste projeto |
|---|---|
| **Manutenibilidade** | Cada camada pode ser alterada sem impactar as demais |
| **Rastreabilidade** | O caminho do dado é identificável etapa a etapa |
| **Validação intermediária** | Quality checks ocorrem antes do dado chegar ao consumo executivo |
| **Governança** | Regras de negócio ficam separadas da lógica de ingestão e limpeza |
| **Aderência a boas práticas** | Estrutura compatível com pipelines analíticos corporativos reais |

---

## Ambiente Simulado

Os scripts foram escritos para **SQL Server**, simulando um ambiente corporativo com as seguintes características:

- tabelas de staging separadas das tabelas analíticas
- nomenclatura padronizada com prefixos `stg_`, `f_` e `d_`
- comentários explicativos nas seções principais
- lógica compatível com o modelo de dados descrito em [`docs/data_model.md`](../docs/data_model.md)

---

## Observação Importante

> Os scripts desta pasta foram criados com finalidade **didática e demonstrativa**. Eles não representam uma implantação produtiva real, mas simulam uma estrutura plausível para um ambiente corporativo com SQL Server.

---

## Posicionamento Final

Esta camada SQL foi estruturada para demonstrar raciocínio técnico, organização analítica e maturidade de projeto — conectando dados operacionais de Procurement a uma visão executiva orientada por KPIs, risco e oportunidade.

---

*[← Voltar para o README principal](../README.md)*

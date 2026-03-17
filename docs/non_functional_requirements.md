# 🔧 Non-Functional Requirements — Requisitos Não Funcionais

## Contexto

Além dos requisitos de negócio e dos KPIs, uma solução analítica precisa atender critérios de qualidade operacional, manutenção e confiabilidade. Esses aspectos definem se a solução pode ser sustentada com eficiência ao longo do tempo.

> A qualidade de uma solução analítica não depende apenas do que ela mede, mas de como ela é estruturada, mantida e utilizada.

---

## Requisitos Principais

| # | Requisito | Descrição | Aplicação no projeto |
|---|---|---|---|
| 1 | **Manutenibilidade** | Organização modular com documentação clara, separação lógica entre camadas e facilidade de evolução | Estrutura de pastas separada por domínio, KPIs e regras documentados, README por módulo |
| 2 | **Clareza e Interpretabilidade** | Dashboard e documentação compreensíveis tanto para perfis analíticos quanto executivos | Narrativa orientada a decisão, explicações funcionais, glossário padronizado |
| 3 | **Confiabilidade** | Informações exibidas dependem de validação, qualidade e reconciliação antes do consumo | Quality checks em SQL, reconciliações entre fontes, indicadores de saúde de dados |
| 4 | **Rastreabilidade** | Origem e fluxo da informação identificáveis ao longo de todo o processo | Documentação de fontes, lógica de intake, logs de automação, checkpoints de validação |
| 5 | **Escalabilidade Conceitual** | Arquitetura que permite crescimento sem perda de coerência ou retrabalho estrutural | Módulos separados, modelo de dados reutilizável, roadmap de evolução documentado |
| 6 | **Performance Esperada** | Solução concebida para responder de forma adequada em ambiente corporativo com atualizações programadas | Modelo estrela, marts analíticos, separação entre evento bruto e camada de consumo executivo |
| 7 | **Governança** | Mudanças em KPIs, regras e fontes passíveis de controle, revisão e auditoria | Documentação centralizada, ownership definido no operating model, roadmap de evolução |
| 8 | **Usabilidade** | Navegação e outputs intuitivos, orientados ao uso por stakeholders de negócio | Dashboard inspirado em Power BI, modularização visual, foco em leitura executiva |

---

## Relação com os Módulos

| Requisito | Módulos mais impactados |
|---|---|
| Manutenibilidade | Todos os módulos — estrutura transversal do projeto |
| Clareza e Interpretabilidade | Spend Overview, Savings & Budget, Executive Summary |
| Confiabilidade | Data Quality, Automation Monitor |
| Rastreabilidade | Data Quality, Automation Monitor, Operating Model |
| Escalabilidade Conceitual | Data Model, Roadmap |
| Performance Esperada | Data Model, SQL Layer |
| Governança | Operating Model, Data Quality Rules |
| Usabilidade | Dashboard, Executive Summary |

---

## Critérios de Sucesso

Uma solução aderente a estes requisitos deve:

| Critério | Indicador de aderência |
|---|---|
| **Fácil de explicar** | Qualquer módulo pode ser apresentado em menos de 5 minutos para um stakeholder de negócio |
| **Fácil de manter** | Mudanças em fontes ou KPIs não exigem reescrita completa da solução |
| **Confiável no dado** | Outputs executivos passam por validação antes de consumo |
| **Evolutiva sem retrabalho** | Novas frentes podem ser adicionadas sem quebrar o que já existe |
| **Clara para decisão** | Cada página do dashboard termina com uma recomendação ou sinal acionável |

---

## Posicionamento Final

> Os requisitos não funcionais da Procurement Control Tower reforçam que senioridade em analytics não se mede apenas pela profundidade técnica — mas pela **capacidade de construir soluções que outras pessoas conseguem usar, manter e confiar ao longo do tempo**.

---

*[← Voltar para docs/README.md](./README.md)*

# 📊 dashboard — Camada Visual

## Contexto

Esta pasta reúne os arquivos da camada visual da **Procurement Control Tower**, desenvolvida para a empresa fictícia **PrimeHarvest Foods Brasil**.

O dashboard representa a interface executiva da solução e tem como objetivo transformar a lógica analítica do projeto em uma experiência visual clara, corporativa e orientada à decisão. Embora implementado em **HTML, CSS e JavaScript**, o protótipo foi concebido para se aproximar visual e conceitualmente de uma experiência em **Power BI**.

---

## Papel do Dashboard no Projeto

O dashboard funciona como a **camada final de consumo** da Procurement Control Tower, conectando todas as camadas anteriores em uma interface executiva única:
```text
[docs/]          → Lógica de negócio, KPIs e contexto analítico
[sql/]           → Estrutura de dados e marts analíticos
[automate/]      → Automação e monitoramento operacional
[vba/]           → Padronização da entrada de dados
         │
         ▼
[dashboard/]     → Interface executiva para decisão
```

Mais do que mostrar números, o dashboard apoia a priorização de ações e simula como compradores, gestores e liderança consumiriam a solução em um ambiente corporativo real.

---

## Estrutura do Dashboard

O dashboard é organizado em seis seções executivas, inspiradas nas páginas de uma solução de BI corporativa:

| # | Seção | O que apresenta |
|---|---|---|
| 1 | **Executive Overview** | KPIs executivos principais, highlights do período e resumo de leitura rápida |
| 2 | **Spend & Savings** | Gasto total, análise por categoria e fornecedor, desvio vs orçamento, savings realizados e potenciais |
| 3 | **Supplier Risk** | Score de risco, fornecedores críticos, atraso, não conformidade e concentração |
| 4 | **Cost Model** | Drivers de custo, impacto por categoria, pressão de benchmark, logística e mercado |
| 5 | **Data Quality** | Indicadores de qualidade, divergências críticas, reconciliação e confiabilidade da base |
| 6 | **Recommendations** | Recomendações executivas com contexto, impacto estimado, ação sugerida e narrativa final |

---

## Identidade Visual

### Paleta de Cores

| Cor | Hex | Uso recomendado |
|---|---|---|
| Azul primário | `#173A70` | Estrutura, títulos, navegação e destaques institucionais |
| Azul escuro | `#102C5C` | Header, sidebar e elementos de ancoragem visual |
| Vermelho primário | `#D62828` | Alertas, riscos, desvios críticos e KPIs de atenção |
| Vermelho escuro | `#C81D25` | Estados hover em elementos de risco |
| Fundo claro | `#F2F2F2` | Legibilidade geral do layout |
| Cinza de apoio | `#D9D9D9` | Bordas, divisões e elementos secundários |
| Texto escuro | `#1F2937` | Tipografia principal |
| Branco | `#FFFFFF` | Cards e áreas principais de conteúdo |

### Princípios Visuais

- aparência premium, profissional e corporativa
- hierarquia visual clara com leitura rápida para público executivo
- layout inspirado em Power BI, não em site institucional
- destaque visual explícito para risco e oportunidade
- navegação simples e objetiva entre seções

---

## Elementos Visuais

O protótipo inclui os seguintes componentes de interface:

- sidebar com navegação entre seções
- header superior com identificação da solução
- filtros visuais simulados
- KPI cards com variação de período
- tabelas estilizadas com hierarquia visual
- badges de risco por fornecedor e categoria
- blocos de insight e recomendação executiva
- gráficos simulados em HTML
- blocos de destaque para desvios e alertas

---

## Estrutura Técnica

| Arquivo | Função |
|---|---|
| `index.html` | Estrutura principal do dashboard |
| `styles.css` | Estilos visuais, layout, cards, grids e identidade visual |
| `script.js` | Comportamentos e interações simples da interface |
| `assets/` | Recursos auxiliares: mockups, ícones e referências visuais |

---

## Integração com o Restante do Projeto

O dashboard mantém aderência aos seguintes documentos do repositório:

| Documento | O que conecta |
|---|---|
| `docs/business_questions.md` | Perguntas de negócio respondidas por cada seção |
| `docs/kpi_catalog.md` | Definição e lógica dos indicadores exibidos |
| `docs/data_model.md` | Estrutura das tabelas que alimentam as visões |
| `docs/data_quality_rules.md` | Regras refletidas na seção Data Quality |
| `docs/executive_summary.md` | Narrativa e recomendações da seção final |

---

## Restrições Obrigatórias

Para manter aderência ao contexto do projeto:

- utilizar exclusivamente o nome **PrimeHarvest Foods Brasil**
- não citar, referenciar ou sugerir qualquer empresa real
- manter coerência com o contexto fictício do repositório
- utilizar indicadores e textos plausíveis, porém fictícios
- preservar consistência com a narrativa de Procurement descrita em `docs/`

---

## Observação Importante

> O dashboard desta pasta é um **protótipo didático e de portfólio**. Seu objetivo não é substituir uma implantação real em Power BI, mas demonstrar capacidade de estruturar uma camada visual executiva alinhada a uma solução completa de analytics e automação.

---

## Posicionamento Final

> A pasta `dashboard/` representa a **materialização visual da Procurement Control Tower** — conectando modelagem analítica, narrativa executiva e design de interface em uma camada única de consumo, criada para demonstrar maturidade técnica, clareza de negócio e capacidade de apresentação em nível sênior.

---

*[← Voltar para o README principal](../README.md)*

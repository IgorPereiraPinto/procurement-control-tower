# ✅ Data Quality Rules — Regras de Qualidade de Dados

## Contexto

A confiabilidade de uma solução analítica depende da qualidade da informação que a sustenta. Em Procurement, erros de completude, classificação, valor ou cadastro podem comprometer diretamente a leitura de spend, savings, risco e orçamento.

> Qualidade de dados não é um detalhe técnico. Em Procurement, ela é pré-requisito para decisões de custo, risco e negociação.

---

## Regras de Validação

| # | Regra | Descrição | Risco | Ação esperada | Severidade |
|---|---|---|---|---|---|
| 1 | **Pedido sem fornecedor** | Nenhum pedido deve existir sem fornecedor válido associado | Inviabiliza análise de spend e supplier risk | Bloquear ou sinalizar para correção | 🔴 Crítica |
| 2 | **Valor total divergente** | O valor total informado deve ser compatível com quantidade × preço unitário | Compromete spend, savings e orçamento | Registrar divergência para reconciliação | 🔴 Crítica |
| 3 | **Preço unitário zero ou negativo** | Preço unitário inválido deve ser sinalizado | Quebra de consistência financeira | Impedir consumo analítico até revisão | 🔴 Crítica |
| 4 | **Material sem categoria** | Todo material deve estar classificado em uma categoria válida | Distorce leitura de spend por categoria | Direcionar para revisão cadastral | 🟠 Alta |
| 5 | **Contrato vencido** | Pedidos vinculados a contratos vencidos devem ser sinalizados | Risco de governança e descasamento comercial | Alertar Procurement para revisão contratual | 🟠 Alta |
| 6 | **Moeda inválida ou ausente** | Registros com moeda ausente ou fora do padrão esperado devem ser tratados | Inconsistência em comparações de custo | Corrigir ou excluir do cálculo até regularização | 🟠 Alta |
| 7 | **Benchmark ausente** | Categorias elegíveis a benchmark devem possuir referência válida | Limita leitura de savings potencial | Sinalizar ausência para complementação | 🟠 Alta |
| 8 | **Fornecedor duplicado** | O cadastro não deve manter duplicidades ativas para o mesmo fornecedor lógico | Fragmentação de spend e leitura incorreta de concentração | Consolidar cadastro | 🟠 Alta |
| 9 | **SKU sem descrição** | Itens sem descrição devem ser tratados como incompletos | Dificulta análise, classificação e comunicação com a área | Revisão do cadastro mestre | 🟡 Média |
| 10 | **Data fora do período válido** | Registros com data inválida ou fora do recorte temporal esperado devem ser sinalizados | Distorção de séries temporais e KPIs mensais | Ajuste de data ou exclusão do período | 🟡 Média |

---

## Níveis de Severidade

| Severidade | Critério | Impacto no consumo |
|---|---|---|
| 🔴 Crítica | Impede uso confiável do dado | Bloqueio total até correção |
| 🟠 Alta | Permite consumo parcial, mas exige correção prioritária | Consumo com ressalva e flag visível |
| 🟡 Média | Não inviabiliza o uso, mas reduz qualidade e rastreabilidade | Consumo permitido, correção no próximo ciclo |

---

## Regras de Reconciliação

Além das validações pontuais, o projeto aplica reconciliações entre fontes:

| Comparação | Objetivo |
|---|---|
| Valor calculado vs valor informado | Detectar inconsistências de cálculo antes do consumo analítico |
| Spend consolidado vs origem transacional | Garantir que a agregação preserva a integridade do transacional |
| Preço contratado vs preço efetivamente pago | Identificar desvios comerciais e oportunidades de auditoria |
| Budget previsto vs budget carregado no dashboard | Assegurar aderência entre planejamento e leitura executiva |

---

## Aplicação na Solução

| Camada | Como as regras são aplicadas |
|---|---|
| SQL (`04_quality_checks.sql`) | Queries de validação e detecção de violações por regra |
| Power Automate | Alertas automáticos para regras críticas e altas |
| Dashboard — Data Quality | Painel com status de validação, contagem de erros e severidade |
| Camada executiva | Liberação de consumo condicionada ao status de reconciliação |

---

## Posicionamento Final

> Estas regras definem o **padrão mínimo de confiança** esperado para que a Procurement Control Tower entregue leitura executiva consistente, rastreável e segura para tomada de decisão.

---

*[← Voltar para docs/README.md](./README.md)*

# 🗄️ Data Sources — Fontes de Dados

## Contexto

Mesmo sendo um case fictício, a Procurement Control Tower foi estruturada como se estivesse conectada a um ambiente corporativo real, com múltiplas origens de informação e diferentes níveis de maturidade de processo.

O desafio não é apenas acessar os dados — é estruturar um fluxo confiável, rastreável e útil para decisão.

---

## Fontes Simuladas

| # | Fonte | Tipo | Conteúdo esperado | Uso no projeto |
|---|---|---|---|---|
| 1 | **ERP de Compras** | Transacional | Pedidos de compra, valores, datas, fornecedores, materiais e centros de custo | Base principal para spend, lead time e análise operacional |
| 2 | **Cadastro Mestre de Fornecedores** | Cadastral | Fornecedor, categoria atendida, região, status, criticidade e atributos de cadastro | Enriquecimento da análise de spend e risco |
| 3 | **Contratos e Condições Comerciais** | Referência | Preços negociados, prazos acordados, vigência e cláusulas principais | Benchmark interno e reconciliação de custo |
| 4 | **Orçamento de Procurement** | Gerencial | Orçamento por categoria, período e unidade de negócio | Cálculo de desvio vs orçamento |
| 5 | **Benchmark / Referência de Mercado** | Externa / Analítica | Referências de preço, faixas esperadas e parâmetros comparativos | Análise de savings potencial e desvio vs benchmark |
| 6 | **Performance Logística** | Operacional | Prazo de entrega, atraso, transportador, lead time e ocorrências | Supplier risk e leitura de continuidade |
| 7 | **Eventos de Qualidade** | Controle | Não conformidades, desvios, reincidência e impacto | Composição do supplier risk score |
| 8 | **Planilhas Operacionais (Excel)** | Entrada manual | Controles locais, complementos operacionais e informações recebidas da área | Simulação de processo manual tratado por VBA e automação |
| 9 | **SharePoint / Pasta Compartilhada** | Repositório documental | Arquivos recebidos, versões de controles e insumos auxiliares | Fluxo de intake e rastreabilidade documental |
| 10 | **Logs de Automação** | Processo | Hora de execução, status, erro, usuário e etapa do fluxo | Monitoramento operacional e automation dashboard |

---

## Arquitetura por Grupo

As fontes são organizadas em três camadas dentro da solução:

### 🔄 Fontes Transacionais
Alimentam a camada analítica com dados de execução e operação.

- ERP de Compras
- Performance Logística
- Eventos de Qualidade

### 📋 Fontes de Referência
Fornecem os parâmetros necessários para comparação, validação e enriquecimento.

- Cadastro Mestre de Fornecedores
- Contratos e Condições Comerciais
- Orçamento de Procurement
- Benchmark / Referência de Mercado

### ⚙️ Fontes Operacionais
Representam o processo em si — entradas, armazenamento e rastreabilidade de execução.

- Planilhas Operacionais (Excel)
- SharePoint / Pasta Compartilhada
- Logs de Automação

---

## Cuidados Esperados no Tratamento

Ao longo da solução, essas fontes exigiriam os seguintes tratamentos:

| Cuidado | Fontes mais críticas |
|---|---|
| Padronização de chaves | ERP, Cadastro de Fornecedores, Contratos |
| Tratamento de datas e moedas | ERP, Orçamento, Performance Logística |
| Deduplicação | Planilhas Excel, ERP |
| Classificação de categorias | ERP, Cadastro de Fornecedores |
| Reconciliação de valores | ERP vs Contratos, ERP vs Orçamento |
| Validação de campos obrigatórios | Todas as fontes |

---

## Posicionamento Final

> As fontes de dados deste case foram definidas para simular um ambiente real de Procurement, em que o desafio não é apenas acessar os dados — mas **estruturar um fluxo confiável, rastreável e útil para decisão**.

---

*[← Voltar para docs/README.md](./README.md)*

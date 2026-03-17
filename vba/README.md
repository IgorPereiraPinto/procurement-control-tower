# 📋 vba — Padronização Operacional

## Contexto

Esta pasta reúne o caso de uso em **VBA** concebido para a **Procurement Control Tower**. O objetivo é representar um cenário comum em ambientes corporativos, em que parte dos dados ainda circula em planilhas Excel preenchidas ou ajustadas manualmente antes de seguir para uma camada mais estruturada de analytics.

Em operações de Procurement, é frequente que arquivos de fornecedores, controles locais e templates internos precisem passar por padronização antes de serem consolidados, validados ou carregados em um processo automatizado. Nesses casos, o VBA cumpre um papel importante como mecanismo de apoio operacional.

---

## Papel do VBA no Pipeline

O VBA foi posicionado como uma **camada de apoio entre a entrada operacional em Excel e o intake automatizado**, atuando antes que os arquivos entrem no fluxo do Power Automate e na camada SQL.
```text
[Planilha Excel operacional]
         │
         ▼
[VBA — procurement_standardization.bas]
   → validar colunas obrigatórias
   → padronizar cabeçalhos
   → limpar espaços indevidos
   → registrar inconsistências
         │
         ▼
[Arquivo pronto para intake]
         │
         ▼
[Flow 01 — File Intake → SQL Pipeline]
```

---

## Quando o VBA se justifica

| Cenário | Relevância |
|---|---|
| Origem ainda depende de planilhas Excel | Camada de padronização antes da automação |
| Time de negócio trabalha diretamente no Excel | Reduz erros sem alterar o fluxo do usuário |
| Necessidade de padronização antes do intake | Aumenta aderência ao template esperado |
| Rotinas legadas integradas ao pacote Office | Compatibilidade sem necessidade de reengenharia |

---

## Caso de Uso Principal

O arquivo `procurement_standardization.bas` representa uma macro voltada para:

- validar a existência das colunas obrigatórias
- padronizar cabeçalhos para o formato esperado pelo pipeline
- limpar espaços indevidos em campos de texto
- criar uma aba de inconsistências com registro dos problemas encontrados
- preparar a planilha para processamento posterior

---

## Benefícios Esperados

| Benefício | Impacto |
|---|---|
| Redução de retrabalho manual | Padronização executada pela macro, não pelo analista |
| Aumento de consistência estrutural | Arquivos chegam ao intake com layout previsível |
| Melhoria na qualidade da entrada | Menos erros propagando para as camadas SQL |
| Menor risco no intake | Flow 01 recebe arquivos já aderentes ao template |
| Apoio à transição operacional | Ponte entre processo manual e processo automatizado |

---

## Arquivo desta Pasta

| Arquivo | Descrição |
|---|---|
| `procurement_standardization.bas` | Macro demonstrativa para padronização de planilhas operacionais de Procurement |

---

## Observação Importante

> O código desta pasta foi criado para fins **didáticos e de portfólio**. Ele não representa uma implantação produtiva real, mas um exemplo plausível e coerente de como o VBA poderia ser utilizado em apoio à operação de Procurement.

---

## Posicionamento Final

> A camada VBA complementa o projeto ao demonstrar preocupação com a **realidade operacional da área** — em que nem todo processo começa em sistemas estruturados. Ela mostra capacidade de apoiar a base da rotina com pragmatismo, clareza e foco em qualidade de entrada.

---

*[← Voltar para o README principal](../README.md)*

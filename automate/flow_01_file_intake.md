# 📥 Flow 01 — File Intake

## Contexto

Em um ambiente de Procurement, boa parte da informação pode chegar por múltiplos canais e formatos: planilhas compartilhadas, anexos de e-mail, extrações de sistemas e arquivos depositados em pastas corporativas. Sem um fluxo padronizado de entrada, o processo se torna vulnerável a erros, atrasos e baixa rastreabilidade.

---

## Objetivo

Estruturar um fluxo automatizado de recebimento e intake de arquivos, garantindo validação inicial, organização padronizada e registro básico das entradas recebidas — antes que qualquer dado entre na camada analítica.

---

## Visão Geral do Fluxo
```text
[Novo arquivo recebido]
         │
         ▼
[Validar nome e extensão] ──── inválido ──→ [Quarentena + Notificar]
         │
       válido
         │
         ▼
[Validar estrutura mínima] ─── inválido ──→ [Quarentena + Notificar]
         │
       válido
         │
         ▼
[Mover para processamento]
         │
         ▼
[Registrar log de intake]
         │
         ▼
[Processo analítico continua]
```

---

## Gatilho

**Quando um novo arquivo for criado** em uma pasta monitorada no SharePoint ou OneDrive corporativo.

---

## Entradas Esperadas

| Entrada | Descrição |
|---|---|
| Arquivo Excel | Enviado pelo time de Procurement ou área de origem |
| Template padronizado | Estrutura de colunas e abas definida pelo processo |
| Convenção de nome | Padrão de nomenclatura acordado para identificação automática |
| Colunas obrigatórias | Campos mínimos exigidos para ingestão na camada SQL |

---

## Etapas do Fluxo

### Etapa 1 — Identificação do novo arquivo
O fluxo detecta automaticamente que um novo arquivo foi inserido na pasta de intake monitorada.

### Etapa 2 — Validação de nome e extensão
O sistema verifica se a extensão é permitida (`.xlsx`, `.csv`), se o nome segue o padrão esperado e se o arquivo não está vazio.

### Etapa 3 — Validação estrutural mínima
O fluxo verifica se o arquivo contém as colunas obrigatórias, a aba esperada e uma estrutura compatível com o template definido.

### Etapa 4 — Movimentação controlada
Arquivos válidos são movidos para a pasta de processamento. Arquivos inválidos são direcionados para a pasta de quarentena com registro do motivo.

### Etapa 5 — Registro do intake
O fluxo registra os metadados da entrada para rastreabilidade completa do input.

### Etapa 6 — Notificação
Em caso de falha estrutural, o fluxo dispara alerta via e-mail ou Teams para o responsável pelo arquivo, com descrição do problema detectado.

---

## Log de Intake

Campos registrados a cada execução do fluxo:

| Campo | Descrição |
|---|---|
| `file_name` | Nome do arquivo recebido |
| `upload_datetime` | Data e hora do recebimento |
| `uploaded_by` | Usuário ou origem do arquivo |
| `validation_status` | `VALID` / `INVALID` |
| `rejection_reason` | Motivo de rejeição, quando aplicável |
| `processing_folder` | Pasta de destino após validação |
| `flow_execution_id` | Identificador da execução do fluxo |

---

## Saídas Esperadas

| Saída | Condição |
|---|---|
| Arquivo movido para processamento | Validação bem-sucedida |
| Arquivo movido para quarentena | Falha em qualquer etapa de validação |
| Log de intake registrado | Sempre — independente do resultado |
| Notificação enviada ao responsável | Somente em caso de falha |

---

## Benefícios de Negócio

| Benefício | Impacto |
|---|---|
| Reduz arquivos fora do padrão na rotina | Menos erros chegando à camada SQL |
| Melhora rastreabilidade da entrada | Histórico auditável de cada input recebido |
| Reduz esforço manual de triagem | Time foca em análise, não em verificação de arquivos |
| Padroniza a etapa inicial do processo | Comportamento previsível independente do remetente |

---

## Pontos de Atenção

- padronizar a convenção de nomes antes de ativar o fluxo
- definir explicitamente quais colunas são obrigatórias por template
- evitar múltiplas versões do mesmo arquivo sem controle de versão
- revisar a lógica de quarentena periodicamente para capturar novos padrões de erro

---

## Posicionamento Final

> O fluxo de File Intake é a **porta de entrada da camada operacional** da Procurement Control Tower. Ele garante disciplina, controle e rastreabilidade desde o primeiro ponto do processo — antes que qualquer dado comprometa a camada analítica.

---

*[← Voltar para automate/README.md](./README.md)*

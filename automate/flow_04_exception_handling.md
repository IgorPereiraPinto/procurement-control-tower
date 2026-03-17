# 🛡️ Flow 04 — Exception Handling

## Contexto

Mesmo com intake validado, atualização monitorada e alertas de negócio, processos automatizados continuam sujeitos a falhas. Em ambientes corporativos, o diferencial não está em evitar toda exceção — está em tratá-la de forma controlada, rastreável e padronizada.

---

## Objetivo

Documentar a lógica de tratamento de exceções da Procurement Control Tower, garantindo resposta estruturada para erros operacionais, inconsistências e falhas de fluxo em qualquer etapa do pipeline.

---

## Visão Geral do Fluxo
```text
[Exceção detectada em qualquer etapa]
         │
         ▼
[Classificar tipo e severidade]
         │
         ▼
[Registrar log de exceção]
         │
    ┌────┴──────────────────────────────┐
 CRÍTICA / ALTA                       MÉDIA
    │                                   │
    ▼                                   ▼
[Interromper processo]         [Continuar com flag]
[Mover para quarentena]        [Registrar para correção]
    │                                   │
    ▼                                   │
[Notificar responsável]                 │
    │                                   │
    └──────────────┬────────────────────┘
                   ▼
     [Encerrar com rastreabilidade]
```

---

## Situações de Exceção Cobertas

| # | Exceção | Descrição | Severidade |
|---|---|---|---|
| 1 | **Arquivo corrompido** | Arquivo recebido não pode ser lido ou aberto | 🔴 Crítica |
| 2 | **Falha total de refresh** | Processo de atualização não concluído com sucesso | 🔴 Crítica |
| 3 | **Erro de integração** | Fluxo não conseguiu acessar pasta, base ou conector necessário | 🔴 Crítica |
| 4 | **Layout inválido** | Arquivo sem estrutura esperada, colunas obrigatórias ou aba padrão | 🟠 Alta |
| 5 | **Campo crítico ausente** | Ausência de fornecedor, categoria ou valor essencial | 🟠 Alta |
| 6 | **Timeout de execução** | Execução excedeu o tempo limite definido | 🟠 Alta |
| 7 | **Inconsistência de nomenclatura** | Desvio em campo não crítico que exige correção posterior | 🟡 Média |
| 8 | **Erro em campo não crítico** | Problema que não impede processamento mas reduz qualidade | 🟡 Média |

---

## Etapas do Fluxo

### Etapa 1 — Captura da falha
O fluxo detecta uma exceção em qualquer etapa do pipeline — intake, refresh, validação ou alerta.

### Etapa 2 — Classificação
A exceção é classificada por tipo, severidade, impacto potencial e etapa de origem.

### Etapa 3 — Registro detalhado
O log de exceção é gerado imediatamente, independente da severidade.

### Etapa 4 — Tratamento automático inicial
O fluxo executa a resposta adequada ao tipo de exceção: interrupção, quarentena, continuação com flag ou reencaminhamento.

### Etapa 5 — Notificação
A exceção é enviada ao responsável adequado com contexto suficiente para diagnóstico e ação.

### Etapa 6 — Encerramento com rastreabilidade
A exceção permanece registrada para análise de reincidência, melhoria contínua e auditoria.

---

## Resposta por Severidade

| Severidade | Resposta automática | Notificação | Continuidade |
|---|---|---|---|
| 🔴 **Crítica** | Interromper processo, mover para quarentena | Imediata — responsável técnico e funcional | Bloqueada até correção |
| 🟠 **Alta** | Interromper etapa afetada, registrar exceção | Imediata — responsável funcional | Parcial, com risco explícito |
| 🟡 **Média** | Continuar com flag de atenção | Consolidada — próxima janela de revisão | Permitida, correção no próximo ciclo |

---

## Log de Exceção

Campos registrados a cada exceção detectada:

| Campo | Descrição |
|---|---|
| `exception_id` | Identificador único da exceção |
| `flow_name` | Nome do fluxo onde ocorreu a falha |
| `pipeline_step` | Etapa do pipeline onde a exceção foi detectada |
| `exception_type` | Código do tipo de exceção |
| `severity_level` | `CRITICAL` / `HIGH` / `MEDIUM` |
| `exception_datetime` | Data e hora de detecção |
| `affected_file` | Arquivo ou processo relacionado |
| `technical_message` | Mensagem técnica do erro |
| `responsible_party` | Área ou perfil responsável pela correção |
| `resolution_status` | `OPEN` / `IN PROGRESS` / `RESOLVED` |

---

## Saídas Esperadas

| Saída | Condição |
|---|---|
| Log de exceção registrado | Sempre — independente da severidade |
| Processo interrompido ou bloqueado | Severidade crítica ou alta |
| Notificação enviada ao responsável | Severidade crítica ou alta |
| Continuidade com flag de atenção | Severidade média |
| Histórico disponível para monitoramento | Acumulado em todas as execuções |

---

## Benefícios de Negócio

| Benefício | Impacto |
|---|---|
| Reduz dependência de investigação manual | Erros são capturados, classificados e registrados automaticamente |
| Melhora tempo de resposta | Responsável notificado no momento da falha, não na revisão seguinte |
| Aumenta previsibilidade operacional | Comportamento da solução é controlado mesmo em cenários de erro |
| Evita falhas silenciosas | Nenhuma exceção passa despercebida sem registro e rastreabilidade |

---

## Pontos de Atenção

- separar erro técnico de erro de negócio na classificação — tratativas são diferentes
- garantir que o log seja gravado antes de qualquer outra ação de resposta
- evitar reprocessamento automático sem critério definido — pode amplificar o erro
- monitorar reincidência por origem para identificar problemas estruturais nas fontes

---

## Posicionamento Final

> O fluxo de Exception Handling demonstra que a automação foi desenhada com **visão realista de produção**: controle de falhas, rastreabilidade e resposta estruturada a exceções são tão importantes quanto a execução bem-sucedida em si.

---

*[← Voltar para automate/README.md](./README.md)*

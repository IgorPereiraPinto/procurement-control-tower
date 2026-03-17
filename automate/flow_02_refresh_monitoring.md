# 🔄 Flow 02 — Refresh Monitoring

## Contexto

Após a entrada e validação dos arquivos, a solução precisa garantir que a informação seja atualizada de forma consistente e monitorada. Em um ambiente corporativo, não basta atualizar a base: é necessário saber quando a atualização ocorreu, se foi concluída com sucesso e se houve falhas no processo.

---

## Objetivo

Documentar um fluxo automatizado para orquestrar a atualização da camada analítica e monitorar o status das execuções, criando base para SLA operacional e indicadores de confiabilidade.

---

## Visão Geral do Fluxo
```text
[Arquivo validado disponível]
ou
[Janela programada atingida]
         │
         ▼
[Registrar início da execução]
         │
         ▼
[Acionar atualização da camada analítica]
         │
         ▼
[Capturar retorno da execução]
         │
    ┌────┴─────┐
  sucesso    falha / timeout
    │              │
    ▼              ▼
[Registrar  [Registrar erro
  fim com     + Notificar
  sucesso]    responsável]
    │              │
    └──────┬───────┘
           ▼
[Log de execução gravado]
         │
         ▼
[Dashboard Automation Monitor atualizado]
```

---

## Gatilho

| Tipo | Condição |
|---|---|
| **Orientado a evento** | Arquivo validado movido para a pasta de processamento pelo Flow 01 |
| **Agendado** | Horário fixo programado, para processos com janela de atualização definida |

---

## Entradas Esperadas

| Entrada | Descrição |
|---|---|
| Arquivo validado | Input previamente aprovado pelo Flow 01 |
| Parâmetro de execução | Identificação do processo e lote a ser processado |
| Configuração de timeout | Limite de tempo aceitável para a execução |
| Responsáveis configurados | Destinatários para alertas em caso de falha |

---

## Etapas do Fluxo

### Etapa 1 — Disparo do processamento
O fluxo identifica que existe um novo input válido disponível ou que chegou a janela programada de atualização.

### Etapa 2 — Registro de início
É gerado um log com data/hora de início, nome do fluxo, arquivo ou lote associado e status inicial `RUNNING`.

### Etapa 3 — Atualização da camada analítica
A automação aciona a rotina necessária para consolidar o arquivo, atualizar o dataset, disparar o refresh da base e sinalizar a etapa seguinte do pipeline.

### Etapa 4 — Captura do retorno
O fluxo verifica se a atualização foi concluída com sucesso, concluída com alerta ou interrompida por erro ou timeout.

### Etapa 5 — Registro final
O sistema registra data/hora de término, duração total, status final e mensagem de erro quando houver.

### Etapa 6 — Notificação de status
Em caso de falha ou atraso acima do timeout configurado, o fluxo envia alerta via e-mail ou Teams para o responsável técnico ou funcional.

---

## Log de Execução

Campos registrados a cada execução do fluxo:

| Campo | Descrição |
|---|---|
| `flow_execution_id` | Identificador único da execução |
| `flow_name` | Nome do fluxo executado |
| `execution_start_time` | Data e hora de início |
| `execution_end_time` | Data e hora de término |
| `execution_duration_seconds` | Duração total em segundos |
| `execution_status` | `SUCCESS` / `FAILED` / `TIMEOUT` |
| `processed_file_name` | Arquivo ou lote processado |
| `error_message` | Mensagem de erro, quando houver |

---

## Saídas Esperadas

| Saída | Condição |
|---|---|
| Camada analítica atualizada | Execução bem-sucedida |
| Log de execução registrado | Sempre — independente do resultado |
| Notificação de falha enviada | Status `FAILED` ou `TIMEOUT` |
| Dashboard Automation Monitor atualizado | Após gravação do log |

---

## Métricas Derivadas

Este fluxo alimenta diretamente o módulo **Automation Monitor** do dashboard:

| Métrica | Origem |
|---|---|
| Total de execuções | Contagem de registros no log |
| Taxa de sucesso (%) | `SUCCESS` / total de execuções |
| Taxa de falha (%) | `FAILED` + `TIMEOUT` / total |
| Tempo médio de execução | Média de `execution_duration_seconds` |
| Incidentes por período | Contagem de status não-sucesso por data |

---

## Benefícios de Negócio

| Benefício | Impacto |
|---|---|
| Reduz dependência de acompanhamento manual | Rotina roda e se auto-monitora sem intervenção humana |
| Melhora visibilidade do status da rotina | Time sabe imediatamente quando algo falhou |
| Aumenta confiabilidade da disponibilização | Informação atualizada no tempo certo, de forma rastreável |
| Cria base para SLA operacional | Histórico de execuções permite definir e monitorar metas |

---

## Pontos de Atenção

- definir timeout aceitável por tipo de processo antes de ativar o fluxo
- padronizar mensagens de erro para facilitar diagnóstico
- garantir que o log seja gravado mesmo em caso de falha — rastreabilidade não pode depender do sucesso
- prever lógica de reprocessamento controlado para falhas recuperáveis

---

## Posicionamento Final

> O fluxo de Refresh Monitoring transforma a atualização da solução em um **processo rastreável e gerenciável**, reforçando maturidade operacional e confiabilidade analítica — e criando a base de evidência que sustenta o dashboard de Automation Monitor.

---

*[← Voltar para automate/README.md](./README.md)*

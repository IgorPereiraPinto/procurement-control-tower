# 🚨 Flow 03 — Business Alerts

## Contexto

Uma solução de Procurement madura não deve apenas consolidar dados — ela deve sinalizar situações que exigem ação. Alertas de negócio transformam indicadores em eventos acionáveis, reduzindo tempo de resposta e apoiando a priorização da área.

---

## Objetivo

Documentar um fluxo automatizado de alertas para desvios críticos de Procurement, conectando indicadores e regras de negócio a notificações padronizadas e direcionadas.

---

## Visão Geral do Fluxo
```text
[Atualização concluída]
ou
[Janela programada atingida]
         │
         ▼
[Ler camada mais recente de indicadores]
         │
         ▼
[Aplicar regras de negócio]
         │
    ┌────┴──────────────────────┐
  nenhuma condição         condição atendida
  atendida                      │
    │                           ▼
    │              [Montar mensagem padronizada]
    │                           │
    │                           ▼
    │              [Enviar alerta (e-mail / Teams)]
    │                           │
    │                           ▼
    │              [Registrar alerta no log]
    │                           │
    └───────────────┬───────────┘
                   ▼
        [Execução concluída]
```

---

## Gatilhos

| Tipo | Condição |
|---|---|
| **Orientado a evento** | Ao final de cada atualização bem-sucedida da camada analítica |
| **Agendado** | Em janelas programadas de monitoramento |
| **Threshold** | Sempre que um indicador ultrapassar um limite definido |

---

## Regras de Alerta

| # | Alerta | Condição de disparo | Exemplo de uso |
|---|---|---|---|
| 1 | **Categoria acima do orçamento** | Gasto da categoria ultrapassa limite definido vs orçamento | Antecipar revisão de categoria ou renegociação |
| 2 | **Custo acima do benchmark** | Custo atual está acima da referência de benchmark | Sinalizar oportunidade de savings potencial |
| 3 | **Fornecedor com atraso recorrente** | Frequência de atraso acima do limite aceitável | Mitigar risco de abastecimento |
| 4 | **Supplier Risk Score elevado** | Score consolidado atinge faixa crítica (`HIGH RISK`) | Priorizar avaliação de fornecedor e continuidade |
| 5 | **Falha de qualidade relevante** | Não conformidade crítica ou reincidente detectada | Apoiar decisão de bloqueio, revisão ou escalonamento |

---

## Etapas do Fluxo

### Etapa 1 — Leitura da base atualizada
O fluxo acessa a camada mais recente de indicadores e exceções da solução analítica.

### Etapa 2 — Aplicação das regras de negócio
Cada regra compara o valor atual com o threshold definido. Apenas condições atendidas avançam para geração de alerta.

### Etapa 3 — Geração do alerta
O sistema monta uma mensagem padronizada contendo tipo do alerta, entidade afetada (categoria ou fornecedor), valor ou desvio encontrado, impacto resumido e ação recomendada.

### Etapa 4 — Envio
O alerta é enviado pelo canal configurado para aquele tipo de regra, com destinatários segmentados por perfil.

### Etapa 5 — Registro
Todo alerta emitido é registrado no log operacional para rastreabilidade e análise de recorrência.

---

## Canais de Envio

| Canal | Uso recomendado |
|---|---|
| **E-mail** | Alertas formais, com detalhe de impacto e ação recomendada |
| **Teams** | Alertas operacionais de resposta rápida para o time de Procurement |
| **Log operacional** | Registro permanente de todos os alertas emitidos |

---

## Log de Alertas

Campos registrados a cada alerta emitido:

| Campo | Descrição |
|---|---|
| `alert_id` | Identificador único do alerta |
| `alert_type` | Código da regra que gerou o alerta |
| `alert_datetime` | Data e hora de emissão |
| `affected_entity` | Categoria ou fornecedor afetado |
| `indicator_value` | Valor do indicador no momento do disparo |
| `threshold_value` | Limite configurado para a regra |
| `recipient` | Destinatário do alerta |
| `send_status` | `SENT` / `FAILED` |

---

## Exemplo de Mensagem

> **🚨 Alerta: Categoria acima do orçamento**
>
> A categoria **Embalagens** apresentou gasto **12,4% acima do orçamento do mês**.
> Impacto estimado: **R$ 180 mil** acima do previsto.
> Ação sugerida: priorizar revisão de spend e renegociação com fornecedores principais.

---

## Saídas Esperadas

| Saída | Condição |
|---|---|
| Alerta enviado ao responsável | Condição de negócio atendida |
| Log de alerta registrado | Sempre — independente do canal de envio |
| Nenhuma ação | Nenhuma condição atendida na execução |

---

## Benefícios de Negócio

| Benefício | Impacto |
|---|---|
| Acelera reação a desvios críticos | Menor janela entre o problema e a ação corretiva |
| Ajuda compradores a priorizar atuação | Foco no que realmente exige atenção no período |
| Reduz dependência de leitura manual | Dashboard não precisa ser consultado para detectar urgências |
| Aproxima analytics de tomada de decisão | Indicador vira sinal claro, com contexto e recomendação |

---

## Pontos de Atenção

- definir thresholds coerentes com o negócio antes de ativar o fluxo
- segmentar destinatários por tipo de alerta — nem todo alerta é para todos
- evitar excesso de alertas sem priorização: ruído reduz atenção
- revisar periodicamente as regras de disparo para refletir mudanças no negócio

---

## Posicionamento Final

> O fluxo de Business Alerts é a **ponte entre monitoramento e ação**. Ele transforma números em sinais claros, úteis e oportunos — aproximando a camada analítica da tomada de decisão real em Procurement.

---

*[← Voltar para automate/README.md](./README.md)*

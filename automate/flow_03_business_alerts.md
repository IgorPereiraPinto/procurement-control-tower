# Flow 03 — Business Alerts

## Contexto
Uma solução de Procurement madura não deve apenas consolidar dados, mas também sinalizar situações que exigem ação. Alertas de negócio ajudam a transformar indicadores em eventos acionáveis, reduzindo tempo de resposta e apoiando a priorização da área.

## Objetivo
Documentar um fluxo automatizado de alertas para desvios críticos de Procurement, conectando indicadores e regras de negócio a notificações padronizadas.

## Finalidade do fluxo
Este fluxo foi desenhado para:

- detectar condições críticas automaticamente
- alertar compradores e gestores
- reduzir dependência de monitoramento manual
- acelerar reação a risco e oportunidade

## Gatilhos sugeridos
- ao final de cada atualização
- em janelas programadas
- sempre que um indicador ultrapassar um limite definido

## Regras de alerta sugeridas

### 1. Categoria acima do orçamento
Disparar alerta quando o gasto da categoria ultrapassar limite definido versus orçamento.

**Exemplo de uso:** antecipar revisão de categoria ou negociação.

### 2. Custo acima do benchmark
Disparar alerta quando o custo atual estiver acima da referência de benchmark.

**Exemplo de uso:** sinalizar oportunidade de savings potencial.

### 3. Fornecedor com atraso recorrente
Disparar alerta quando o fornecedor apresentar frequência de atraso acima do limite aceitável.

**Exemplo de uso:** mitigar risco de abastecimento.

### 4. Supplier Risk Score elevado
Disparar alerta quando o score consolidado de risco atingir faixa crítica.

**Exemplo de uso:** priorizar avaliação de fornecedor e continuidade.

### 5. Falha de qualidade relevante
Disparar alerta quando houver não conformidade crítica ou reincidente.

**Exemplo de uso:** apoiar decisão de bloqueio, revisão ou escalonamento.

## Estrutura do fluxo

### Etapa 1 — Leitura da base atualizada
O fluxo acessa a camada mais recente de indicadores e exceções.

### Etapa 2 — Aplicação das regras de negócio
Cada regra compara o valor atual com o limite definido.

### Etapa 3 — Geração do alerta
Caso a condição seja atendida, o sistema monta uma mensagem padronizada contendo:
- tipo do alerta
- categoria ou fornecedor afetado
- valor ou desvio encontrado
- impacto resumido
- ação recomendada

### Etapa 4 — Envio
O alerta pode ser enviado por:
- e-mail
- Teams
- log operacional
- lista de acompanhamento

### Etapa 5 — Registro
Todo alerta emitido deve ser registrado com:
- data/hora
- tipo de alerta
- destinatário
- status de envio
- referência do indicador

## Saídas esperadas
- alertas automáticos
- histórico de alertas emitidos
- rastreabilidade da comunicação
- maior prontidão para ação corretiva ou preventiva

## Benefícios de negócio
- acelera reação a desvios críticos
- ajuda compradores a priorizar atuação
- reduz dependência de leitura manual de dashboards
- aproxima analytics de tomada de decisão

## Exemplo de mensagem de alerta
**Alerta: categoria acima do orçamento**  
A categoria **Embalagens** apresentou gasto **12,4% acima do orçamento do mês**.  
Impacto estimado: **R$ 180 mil** acima do previsto.  
Ação sugerida: **priorizar revisão de spend e renegociação com fornecedores principais**.

## Pontos de atenção
- evitar excesso de alertas sem priorização
- definir thresholds coerentes com o negócio
- segmentar destinatários por tipo de alerta
- revisar periodicamente as regras de disparo

## Posicionamento final
O fluxo de Business Alerts é a ponte entre monitoramento e ação. Ele transforma números em sinais claros, úteis e oportunos para a área de Procurement.

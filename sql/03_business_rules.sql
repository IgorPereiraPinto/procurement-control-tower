# 03_business_rules.sql
/*
=====================================================================
File    : 03_business_rules.sql
Project : Procurement Control Tower
Company : PrimeHarvest Foods Brasil
Layer   : Business Rules
Author  : Igor Pereira Pinto

Purpose:
    Aplicar regras de negócio, derivar atributos analíticos e
    construir as tabelas de consumo intermediário que alimentam
    os quality checks e os marts executivos da solução.

    Nesta camada os dados já estão limpos e tipados. O objetivo
    é transformar registros operacionais em inteligência de
    Procurement: classificações, métricas derivadas, scores e
    consolidações por período e categoria.

Pipeline:
    01_staging → 02_cleaning → [03_business_rules]
                             → 04_quality_checks → 05_marts

Tables:
    biz.purchase_orders_enriched        → Base enriquecida de pedidos
    biz.spend_monthly                   → Spend consolidado por mês
    biz.benchmark_monthly               → Benchmark médio por mês
    biz.purchase_savings_opportunity    → Savings potencial por pedido
    biz.supplier_risk_score             → Score de risco por fornecedor
    biz.budget_vs_actual                → Desvio orçamento vs realizado

Notes:
    - Estrutura demonstrativa para portfólio.
    - Sintaxe orientada a SQL Server.
    - Dados fictícios para fins didáticos.
    - Pesos do supplier_risk_score são simulados para fins
      de demonstração. Em produção, devem ser calibrados com
      o negócio antes de uso executivo.
=====================================================================
*/


-- =====================================================================
-- 1. Criação do schema de business rules
-- =====================================================================
-- Schema dedicado para separar a camada de regras analíticas
-- da limpeza técnica e do consumo executivo.

IF NOT EXISTS (
    SELECT 1
    FROM sys.schemas
    WHERE name = 'biz'
)
BEGIN
    EXEC('CREATE SCHEMA biz');
END;
GO


-- =====================================================================
-- 2. Base enriquecida de pedidos
-- =====================================================================
-- Join com fornecedores para enriquecer os pedidos com atributos
-- cadastrais. Deriva spend_band e procurement_group para segmentação
-- analítica. Base para spend, savings e supplier risk.

IF OBJECT_ID('biz.purchase_orders_enriched', 'U') IS NOT NULL
    DROP TABLE biz.purchase_orders_enriched;
GO

SELECT
    po.purchase_order_id,
    po.purchase_order_line_id,
    po.supplier_id,
    s.supplier_name,
    s.supplier_group,
    s.supplier_region,
    s.supplier_status,
    po.material_id,
    po.category_name,
    po.order_date,
    po.delivery_date,
    po.quantity,
    po.unit_price,
    po.total_amount,
    po.currency_code,
    po.plant_code,
    po.buyer_name,

    -- Lead time solicitado em dias
    DATEDIFF(DAY, po.order_date, po.delivery_date)          AS requested_lead_time_days,

    -- Classificação de faixa de spend por pedido
    CASE
        WHEN po.total_amount >= 100000 THEN 'HIGH'
        WHEN po.total_amount >= 25000  THEN 'MEDIUM'
        ELSE                                'LOW'
    END                                                     AS spend_band,

    -- Grupo de Procurement baseado na categoria
    CASE
        WHEN po.category_name IN (
            'TOMATE PROCESSADO', 'VEGETAIS PROCESSADOS',
            'CONDIMENTOS E TEMPEROS', 'VINAGRE E CONSERVANTES',
            'AÇÚCAR E INGREDIENTES SECOS', 'ÓLEOS E INSUMOS AUXILIARES DE PRODUÇÃO'
        ) THEN 'DIRECT'
        WHEN po.category_name IN (
            'FRASCOS PET', 'TAMPAS', 'SACHÊS', 'RÓTULOS',
            'CAIXAS DE EMBARQUE', 'FILMES E MATERIAIS DE EMPACOTAMENTO'
        ) THEN 'PACKAGING'
        WHEN po.category_name IN (
            'FRETE INBOUND', 'FRETE OUTBOUND', 'ARMAZENAGEM',
            'MOVIMENTAÇÃO INTERNA', 'SERVIÇOS DE TRANSPORTE DEDICADOS'
        ) THEN 'LOGISTICS'
        ELSE 'INDIRECT'
    END                                                     AS procurement_group

INTO biz.purchase_orders_enriched
FROM cln.purchase_orders po
LEFT JOIN cln.suppliers s
    ON po.supplier_id = s.supplier_id;
GO


-- =====================================================================
-- 3. Spend mensal por categoria e fornecedor
-- =====================================================================
-- Consolidação do spend em granularidade mensal.
-- Base para visão executiva de tendência e concentração de gasto.

IF OBJECT_ID('biz.spend_monthly', 'U') IS NOT NULL
    DROP TABLE biz.spend_monthly;
GO

SELECT
    YEAR(order_date)                                        AS fiscal_year,
    MONTH(order_date)                                       AS fiscal_month,
    category_name,
    supplier_id,
    supplier_name,
    procurement_group,
    SUM(total_amount)                                       AS spend_amount,
    COUNT(DISTINCT purchase_order_id)                       AS purchase_order_count
INTO biz.spend_monthly
FROM biz.purchase_orders_enriched
GROUP BY
    YEAR(order_date),
    MONTH(order_date),
    category_name,
    supplier_id,
    supplier_name,
    procurement_group;
GO


-- =====================================================================
-- 4. Benchmark mensal por categoria
-- =====================================================================
-- Agrega o preço de referência de mercado por categoria e mês.
-- Referência para cálculo de savings potencial e desvio vs benchmark.

IF OBJECT_ID('biz.benchmark_monthly', 'U') IS NOT NULL
    DROP TABLE biz.benchmark_monthly;
GO

SELECT
    YEAR(benchmark_date)                                    AS fiscal_year,
    MONTH(benchmark_date)                                   AS fiscal_month,
    category_name,
    AVG(reference_price)                                    AS avg_reference_price
INTO biz.benchmark_monthly
FROM cln.market_benchmark
GROUP BY
    YEAR(benchmark_date),
    MONTH(benchmark_date),
    category_name;
GO


-- =====================================================================
-- 5. Savings potencial por pedido
-- =====================================================================
-- Calcula o savings potencial por linha de pedido comparando
-- o preço unitário pago com o benchmark médio do período.
-- Somente sinaliza oportunidade quando o preço está acima do benchmark.

IF OBJECT_ID('biz.purchase_savings_opportunity', 'U') IS NOT NULL
    DROP TABLE biz.purchase_savings_opportunity;
GO

SELECT
    poe.purchase_order_id,
    poe.purchase_order_line_id,
    poe.category_name,
    poe.supplier_id,
    poe.supplier_name,
    poe.order_date,
    poe.quantity,
    poe.unit_price,
    bm.avg_reference_price,

    -- Savings potencial: diferença entre preço pago e benchmark * quantidade
    -- Retorna 0 quando benchmark ausente ou preço já está abaixo do benchmark
    CASE
        WHEN bm.avg_reference_price IS NOT NULL
             AND poe.unit_price > bm.avg_reference_price
            THEN (poe.unit_price - bm.avg_reference_price) * poe.quantity
        ELSE 0
    END                                                     AS savings_potential_amount

INTO biz.purchase_savings_opportunity
FROM biz.purchase_orders_enriched poe
LEFT JOIN biz.benchmark_monthly bm
    ON  YEAR(poe.order_date)  = bm.fiscal_year
    AND MONTH(poe.order_date) = bm.fiscal_month
    AND poe.category_name     = bm.category_name;
GO


-- =====================================================================
-- 6. Supplier risk score
-- =====================================================================
-- Consolida métricas de entrega, qualidade e concentração de spend
-- em um score composto de risco por fornecedor.
--
-- Composição dos pesos (simulada para portfólio):
--   30% → atraso médio em dias
--   20% → quantidade de entregas em atraso
--   20% → volume total de eventos de qualidade
--   20% → eventos de qualidade severos (HIGH / CRITICAL)
--   10% → faixa de concentração de spend
--
-- Nota: pesos devem ser calibrados com o negócio em produção.

IF OBJECT_ID('biz.supplier_risk_score', 'U') IS NOT NULL
    DROP TABLE biz.supplier_risk_score;
GO

WITH delivery_metrics AS (
    SELECT
        supplier_id,
        AVG(CAST(ISNULL(delay_days, 0) AS DECIMAL(18,2)))              AS avg_delay_days,
        SUM(CASE WHEN on_time_flag = 'N' THEN 1 ELSE 0 END)            AS delayed_deliveries
    FROM cln.supplier_delivery
    GROUP BY supplier_id
),
quality_metrics AS (
    SELECT
        supplier_id,
        COUNT(*)                                                        AS quality_events,
        SUM(CASE WHEN severity_level IN ('HIGH', 'CRITICAL')
                 THEN 1 ELSE 0 END)                                     AS severe_quality_events
    FROM cln.quality_events
    GROUP BY supplier_id
),
spend_concentration AS (
    SELECT
        supplier_id,
        SUM(total_amount)                                               AS total_spend
    FROM biz.purchase_orders_enriched
    GROUP BY supplier_id
)
SELECT
    s.supplier_id,
    s.supplier_name,
    ISNULL(dm.avg_delay_days, 0)                                        AS avg_delay_days,
    ISNULL(dm.delayed_deliveries, 0)                                    AS delayed_deliveries,
    ISNULL(qm.quality_events, 0)                                        AS quality_events,
    ISNULL(qm.severe_quality_events, 0)                                 AS severe_quality_events,
    ISNULL(sc.total_spend, 0)                                           AS total_spend,

    -- Score composto de risco (quanto maior, maior o risco)
    (
        ISNULL(dm.avg_delay_days, 0)            * 0.30 +
        ISNULL(dm.delayed_deliveries, 0)        * 0.20 +
        ISNULL(qm.quality_events, 0)            * 0.20 +
        ISNULL(qm.severe_quality_events, 0)     * 0.20 +
        CASE
            WHEN ISNULL(sc.total_spend, 0) >= 1000000 THEN 10
            WHEN ISNULL(sc.total_spend, 0) >=  250000 THEN  5
            ELSE                                             1
        END                                     * 0.10
    )                                                                   AS supplier_risk_score

INTO biz.supplier_risk_score
FROM cln.suppliers s
LEFT JOIN delivery_metrics    dm ON s.supplier_id = dm.supplier_id
LEFT JOIN quality_metrics     qm ON s.supplier_id = qm.supplier_id
LEFT JOIN spend_concentration sc ON s.supplier_id = sc.supplier_id;
GO


-- =====================================================================
-- 7. Desvio orçamento vs realizado
-- =====================================================================
-- Compara o spend realizado com o orçamento previsto por categoria
-- e período. Valor positivo em budget_variance indica extrapolação.

IF OBJECT_ID('biz.budget_vs_actual', 'U') IS NOT NULL
    DROP TABLE biz.budget_vs_actual;
GO

SELECT
    sm.fiscal_year,
    sm.fiscal_month,
    sm.category_name,
    SUM(sm.spend_amount)                                    AS actual_spend,
    SUM(pb.budget_amount)                                   AS budget_amount,
    SUM(sm.spend_amount) - SUM(pb.budget_amount)            AS budget_variance
INTO biz.budget_vs_actual
FROM biz.spend_monthly sm
LEFT JOIN cln.procurement_budget pb
    ON  sm.fiscal_year   = pb.fiscal_year
    AND sm.fiscal_month  = pb.fiscal_month
    AND sm.category_name = pb.category_name
GROUP BY
    sm.fiscal_year,
    sm.fiscal_month,
    sm.category_name;
GO


-- =====================================================================
-- 8. Resumo da camada
-- =====================================================================
/*
Tabelas criadas neste script:
    biz.purchase_orders_enriched        → Pedidos com atributos analíticos derivados
    biz.spend_monthly                   → Spend consolidado por mês, categoria e fornecedor
    biz.benchmark_monthly               → Benchmark médio por mês e categoria
    biz.purchase_savings_opportunity    → Savings potencial por linha de pedido
    biz.supplier_risk_score             → Score composto de risco por fornecedor
    biz.budget_vs_actual                → Comparativo orçado vs realizado por categoria

Regras aplicadas nesta camada:
    ✓ Enriquecimento de pedidos com atributos de fornecedor
    ✓ Classificação de spend_band por faixa de valor
    ✓ Classificação de procurement_group por categoria
    ✓ Derivação de lead time solicitado
    ✓ Consolidação mensal de spend
    ✓ Cálculo de savings potencial vs benchmark
    ✓ Score de risco composto com pesos por dimensão
    ✓ Apuração de desvio orçamentário por categoria e período

Fora do escopo desta camada:
    ✗ Validações de integridade e reconciliação
    ✗ Construção das visões finais para dashboard

Próxima etapa: 04_quality_checks.sql
*/

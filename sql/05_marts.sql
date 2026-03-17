# sql/05_marts.sql

/*
=====================================================================
File    : 05_marts.sql
Project : Procurement Control Tower
Company : PrimeHarvest Foods Brasil
Layer   : Analytical Marts
Author  : Igor Pereira Pinto

Purpose:
    Criar as views finais de consumo analítico que alimentam o
    dashboard executivo, o storytelling de Procurement e o
    monitoramento operacional da solução.

    Esta é a camada de entrega. Os dados chegam aqui já limpos,
    enriquecidos, validados e com regras de negócio aplicadas.
    O objetivo é expor visões claras, estáveis e orientadas
    a cada módulo do dashboard.

Pipeline:
    01_staging → 02_cleaning → 03_business_rules
               → 04_quality_checks → [05_marts]
                                   → Dashboard / Analytics

Views criadas:
    mart.procurement_spend_overview         → Módulo Spend Overview
    mart.procurement_savings_budget         → Módulo Savings & Budget
    mart.procurement_supplier_risk          → Módulo Supplier Risk
    mart.procurement_data_quality           → Módulo Data Quality
    mart.procurement_automation_monitor     → Módulo Automation Monitor
    mart.procurement_executive_snapshot     → Visão executiva consolidada

Notes:
    - Estrutura demonstrativa para portfólio.
    - Sintaxe orientada a SQL Server.
    - Dados fictícios para fins didáticos.
    - Views foram escolhidas em vez de tabelas físicas para
      garantir que o consumo sempre reflita o estado mais
      recente das camadas anteriores.
=====================================================================
*/


-- =====================================================================
-- 1. Criação do schema de mart
-- =====================================================================
-- Schema dedicado para a camada de consumo final.
-- Separa visões executivas de todas as camadas de transformação.

IF NOT EXISTS (
    SELECT 1
    FROM sys.schemas
    WHERE name = 'mart'
)
BEGIN
    EXEC('CREATE SCHEMA mart');
END;
GO


-- =====================================================================
-- 2. Spend Overview
-- =====================================================================
-- Visão de spend consolidado por período, categoria e fornecedor.
-- Alimenta o módulo Spend Overview do dashboard com leitura de
-- tendência, concentração e volume de pedidos.

IF OBJECT_ID('mart.procurement_spend_overview', 'V') IS NOT NULL
    DROP VIEW mart.procurement_spend_overview;
GO

CREATE VIEW mart.procurement_spend_overview AS
SELECT
    fiscal_year,
    fiscal_month,
    category_name,
    procurement_group,
    supplier_id,
    supplier_name,
    spend_amount,
    purchase_order_count
FROM biz.spend_monthly;
GO


-- =====================================================================
-- 3. Savings & Budget
-- =====================================================================
-- Visão que combina desvio orçamentário com savings potencial
-- por categoria e período. Alimenta o módulo Savings & Budget
-- com leitura de performance financeira e oportunidades.

IF OBJECT_ID('mart.procurement_savings_budget', 'V') IS NOT NULL
    DROP VIEW mart.procurement_savings_budget;
GO

CREATE VIEW mart.procurement_savings_budget AS
SELECT
    bva.fiscal_year,
    bva.fiscal_month,
    bva.category_name,
    bva.actual_spend,
    bva.budget_amount,
    bva.budget_variance,
    SUM(pso.savings_potential_amount)   AS total_savings_potential
FROM biz.budget_vs_actual bva
LEFT JOIN biz.purchase_savings_opportunity pso
    ON  YEAR(pso.order_date)  = bva.fiscal_year
    AND MONTH(pso.order_date) = bva.fiscal_month
    AND pso.category_name     = bva.category_name
GROUP BY
    bva.fiscal_year,
    bva.fiscal_month,
    bva.category_name,
    bva.actual_spend,
    bva.budget_amount,
    bva.budget_variance;
GO


-- =====================================================================
-- 4. Supplier Risk
-- =====================================================================
-- Visão do score de risco por fornecedor com classificação em band.
-- Alimenta o módulo Supplier Risk com leitura de exposição,
-- atraso, qualidade e concentração de spend.
--
-- Risk bands:
--   HIGH RISK   → score >= 20
--   MEDIUM RISK → score >= 10
--   LOW RISK    → score <  10

IF OBJECT_ID('mart.procurement_supplier_risk', 'V') IS NOT NULL
    DROP VIEW mart.procurement_supplier_risk;
GO

CREATE VIEW mart.procurement_supplier_risk AS
SELECT
    supplier_id,
    supplier_name,
    avg_delay_days,
    delayed_deliveries,
    quality_events,
    severe_quality_events,
    total_spend,
    supplier_risk_score,
    CASE
        WHEN supplier_risk_score >= 20 THEN 'HIGH RISK'
        WHEN supplier_risk_score >= 10 THEN 'MEDIUM RISK'
        ELSE                                'LOW RISK'
    END                             AS supplier_risk_band
FROM biz.supplier_risk_score;
GO


-- =====================================================================
-- 5. Data Quality
-- =====================================================================
-- Visão do resumo de problemas de qualidade detectados.
-- Alimenta o módulo Data Quality do dashboard com contagem
-- de issues por tipo, severidade e tabela de origem.

IF OBJECT_ID('mart.procurement_data_quality', 'V') IS NOT NULL
    DROP VIEW mart.procurement_data_quality;
GO

CREATE VIEW mart.procurement_data_quality AS
SELECT
    severity_level,
    issue_type,
    source_table,
    issue_count,
    first_detected,
    last_detected
FROM qlt.data_quality_summary;
GO


-- =====================================================================
-- 6. Automation Monitor
-- =====================================================================
-- Visão de performance operacional dos fluxos automatizados.
-- Alimenta o módulo Automation Monitor com execuções, falhas
-- e tempo médio de processamento por fluxo e data.

IF OBJECT_ID('mart.procurement_automation_monitor', 'V') IS NOT NULL
    DROP VIEW mart.procurement_automation_monitor;
GO

CREATE VIEW mart.procurement_automation_monitor AS
SELECT
    flow_name,
    CAST(execution_start_time AS DATE)                          AS execution_date,
    COUNT(*)                                                    AS total_executions,
    SUM(CASE WHEN execution_status = 'SUCCESS'
             THEN 1 ELSE 0 END)                                 AS successful_executions,
    SUM(CASE WHEN execution_status <> 'SUCCESS'
             THEN 1 ELSE 0 END)                                 AS failed_executions,
    CAST(
        100.0 * SUM(CASE WHEN execution_status = 'SUCCESS' THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0)
    AS DECIMAL(5,2))                                            AS success_rate_pct,
    AVG(DATEDIFF(SECOND,
        execution_start_time,
        execution_end_time))                                    AS avg_execution_seconds
FROM cln.automation_logs
GROUP BY
    flow_name,
    CAST(execution_start_time AS DATE);
GO


-- =====================================================================
-- 7. Executive Snapshot
-- =====================================================================
-- Visão executiva consolidada por período com os principais KPIs
-- da solução em uma única linha por mês.
-- Alimenta a página de visão executiva e o storytelling final.

IF OBJECT_ID('mart.procurement_executive_snapshot', 'V') IS NOT NULL
    DROP VIEW mart.procurement_executive_snapshot;
GO

CREATE VIEW mart.procurement_executive_snapshot AS
SELECT
    so.fiscal_year,
    so.fiscal_month,
    SUM(so.spend_amount)                                        AS total_spend,
    COUNT(DISTINCT so.supplier_id)                              AS active_suppliers,
    COUNT(DISTINCT so.category_name)                            AS active_categories,
    SUM(ISNULL(sb.total_savings_potential, 0))                  AS total_savings_potential,
    SUM(CASE WHEN sr.supplier_risk_band = 'HIGH RISK'
             THEN 1 ELSE 0 END)                                 AS high_risk_suppliers,
    SUM(CASE WHEN sr.supplier_risk_band = 'MEDIUM RISK'
             THEN 1 ELSE 0 END)                                 AS medium_risk_suppliers,
    SUM(CASE WHEN sb.budget_variance > 0
             THEN 1 ELSE 0 END)                                 AS categories_over_budget
FROM mart.procurement_spend_overview so
LEFT JOIN mart.procurement_savings_budget sb
    ON  so.fiscal_year    = sb.fiscal_year
    AND so.fiscal_month   = sb.fiscal_month
    AND so.category_name  = sb.category_name
LEFT JOIN mart.procurement_supplier_risk sr
    ON so.supplier_id = sr.supplier_id
GROUP BY
    so.fiscal_year,
    so.fiscal_month;
GO


-- =====================================================================
-- 8. Resumo da camada
-- =====================================================================
/*
Views criadas neste script:
    mart.procurement_spend_overview         → Spend por período, categoria e fornecedor
    mart.procurement_savings_budget         → Desvio orçamentário e savings potencial
    mart.procurement_supplier_risk          → Score e band de risco por fornecedor
    mart.procurement_data_quality           → Resumo de issues de qualidade detectados
    mart.procurement_automation_monitor     → Performance operacional dos fluxos
    mart.procurement_executive_snapshot     → KPIs consolidados para visão executiva

Decisão de design:
    Views foram escolhidas em vez de tabelas físicas para garantir
    que o consumo sempre reflita o estado mais recente das camadas
    anteriores, sem necessidade de re-execução desta camada.

Módulos do dashboard alimentados:
    ✓ Spend Overview        → mart.procurement_spend_overview
    ✓ Savings & Budget      → mart.procurement_savings_budget
    ✓ Supplier Risk         → mart.procurement_supplier_risk
    ✓ Data Quality          → mart.procurement_data_quality
    ✓ Automation Monitor    → mart.procurement_automation_monitor
    ✓ Executive Snapshot    → mart.procurement_executive_snapshot

Pipeline completo:
    01_staging → 02_cleaning → 03_business_rules
               → 04_quality_checks → 05_marts → [Dashboard]
*/

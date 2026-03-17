# 02_cleaning.sql
/*
=====================================================================
File    : 02_cleaning.sql
Project : Procurement Control Tower
Company : PrimeHarvest Foods Brasil
Layer   : Cleaning
Author  : Igor Pereira Pinto

Purpose:
    Aplicar padronização, tipagem e tratamento estrutural nos dados
    recebidos da camada de staging, preparando-os para aplicação
    de regras de negócio na próxima etapa do pipeline.

    Nesta camada os dados ainda não possuem validação de negócio.
    O objetivo é garantir consistência técnica: tipos corretos,
    campos padronizados e ausência de ruído estrutural.

Pipeline:
    01_staging → [02_cleaning] → 03_business_rules
                               → 04_quality_checks → 05_marts

Transformações aplicadas:
    - LTRIM / RTRIM em todos os campos de texto
    - UPPER em dimensões críticas (categoria, status, moeda etc.)
    - TRY_CONVERT para datas, inteiros e decimais
    - Preservação de source_file_name e ingestion_timestamp

Tables:
    cln.purchase_orders
    cln.suppliers
    cln.procurement_budget
    cln.market_benchmark
    cln.supplier_delivery
    cln.quality_events
    cln.automation_logs

Notes:
    - Estrutura demonstrativa para portfólio.
    - Sintaxe orientada a SQL Server.
    - Dados fictícios para fins didáticos.
    - Duplicidades e validações de negócio tratadas em etapas
      subsequentes (03_business_rules, 04_quality_checks).
=====================================================================
*/


-- =====================================================================
-- 1. Criação do schema de cleaning
-- =====================================================================
-- Schema dedicado para isolar os dados tratados dos dados brutos.
-- Garante separação clara entre staging e a camada analítica.

IF NOT EXISTS (
    SELECT 1
    FROM sys.schemas
    WHERE name = 'cln'
)
BEGIN
    EXEC('CREATE SCHEMA cln');
END;
GO


-- =====================================================================
-- 2. Pedidos de compra
-- =====================================================================
-- Limpeza da tabela principal da solução.
-- Conversões críticas: datas de pedido e entrega, quantidade,
-- preço unitário e valor total — base para spend e savings.

IF OBJECT_ID('cln.purchase_orders', 'U') IS NOT NULL
    DROP TABLE cln.purchase_orders;
GO

SELECT
    LTRIM(RTRIM(purchase_order_id))                         AS purchase_order_id,
    LTRIM(RTRIM(purchase_order_line_id))                    AS purchase_order_line_id,
    LTRIM(RTRIM(supplier_id))                               AS supplier_id,
    LTRIM(RTRIM(material_id))                               AS material_id,
    UPPER(LTRIM(RTRIM(category_name)))                      AS category_name,
    TRY_CONVERT(DATE, order_date, 120)                      AS order_date,
    TRY_CONVERT(DATE, delivery_date, 120)                   AS delivery_date,
    TRY_CONVERT(DECIMAL(18,2), quantity)                    AS quantity,
    TRY_CONVERT(DECIMAL(18,4), unit_price)                  AS unit_price,
    TRY_CONVERT(DECIMAL(18,2), total_amount)                AS total_amount,
    UPPER(LTRIM(RTRIM(currency_code)))                      AS currency_code,
    UPPER(LTRIM(RTRIM(plant_code)))                         AS plant_code,
    LTRIM(RTRIM(buyer_name))                                AS buyer_name,
    source_file_name,
    ingestion_timestamp
INTO cln.purchase_orders
FROM stg.purchase_orders_raw;
GO


-- =====================================================================
-- 3. Fornecedores
-- =====================================================================
-- Padronização do cadastro de fornecedores.
-- UPPER em campos dimensionais garante consistência nos joins
-- e na leitura de concentração e risco.

IF OBJECT_ID('cln.suppliers', 'U') IS NOT NULL
    DROP TABLE cln.suppliers;
GO

SELECT
    LTRIM(RTRIM(supplier_id))                               AS supplier_id,
    LTRIM(RTRIM(supplier_name))                             AS supplier_name,
    UPPER(LTRIM(RTRIM(supplier_group)))                     AS supplier_group,
    UPPER(LTRIM(RTRIM(supplier_region)))                    AS supplier_region,
    UPPER(LTRIM(RTRIM(supplier_status)))                    AS supplier_status,
    UPPER(LTRIM(RTRIM(category_primary)))                   AS category_primary,
    UPPER(LTRIM(RTRIM(contract_status)))                    AS contract_status,
    source_file_name,
    ingestion_timestamp
INTO cln.suppliers
FROM stg.suppliers_raw;
GO


-- =====================================================================
-- 4. Orçamento de Procurement
-- =====================================================================
-- Conversão de ano e mês fiscal para INT e de valor para DECIMAL.
-- Base para cálculo de desvio vs orçamento.

IF OBJECT_ID('cln.procurement_budget', 'U') IS NOT NULL
    DROP TABLE cln.procurement_budget;
GO

SELECT
    TRY_CONVERT(INT, fiscal_year)                           AS fiscal_year,
    TRY_CONVERT(INT, fiscal_month)                          AS fiscal_month,
    UPPER(LTRIM(RTRIM(category_name)))                      AS category_name,
    TRY_CONVERT(DECIMAL(18,2), budget_amount)               AS budget_amount,
    UPPER(LTRIM(RTRIM(currency_code)))                      AS currency_code,
    source_file_name,
    ingestion_timestamp
INTO cln.procurement_budget
FROM stg.procurement_budget_raw;
GO


-- =====================================================================
-- 5. Benchmark de mercado
-- =====================================================================
-- Conversão de data e preço de referência.
-- Base para savings potencial, desvio vs benchmark e cost model.

IF OBJECT_ID('cln.market_benchmark', 'U') IS NOT NULL
    DROP TABLE cln.market_benchmark;
GO

SELECT
    TRY_CONVERT(DATE, benchmark_date, 120)                  AS benchmark_date,
    UPPER(LTRIM(RTRIM(category_name)))                      AS category_name,
    TRY_CONVERT(DECIMAL(18,4), reference_price)             AS reference_price,
    UPPER(LTRIM(RTRIM(benchmark_type)))                     AS benchmark_type,
    LTRIM(RTRIM(source_name))                               AS source_name,
    source_file_name,
    ingestion_timestamp
INTO cln.market_benchmark
FROM stg.market_benchmark_raw;
GO


-- =====================================================================
-- 6. Performance logística
-- =====================================================================
-- Conversão de datas de entrega e dias de atraso.
-- Base para KPIs de SLA, lead time e supplier risk score.

IF OBJECT_ID('cln.supplier_delivery', 'U') IS NOT NULL
    DROP TABLE cln.supplier_delivery;
GO

SELECT
    LTRIM(RTRIM(delivery_event_id))                         AS delivery_event_id,
    LTRIM(RTRIM(supplier_id))                               AS supplier_id,
    LTRIM(RTRIM(purchase_order_id))                         AS purchase_order_id,
    TRY_CONVERT(DATE, expected_delivery_date, 120)          AS expected_delivery_date,
    TRY_CONVERT(DATE, actual_delivery_date, 120)            AS actual_delivery_date,
    TRY_CONVERT(INT, delay_days)                            AS delay_days,
    UPPER(LTRIM(RTRIM(on_time_flag)))                       AS on_time_flag,
    LTRIM(RTRIM(logistics_provider))                        AS logistics_provider,
    source_file_name,
    ingestion_timestamp
INTO cln.supplier_delivery
FROM stg.supplier_delivery_raw;
GO


-- =====================================================================
-- 7. Eventos de qualidade
-- =====================================================================
-- Padronização de tipo de não conformidade, severidade e reincidência.
-- Base para composição do supplier risk score.

IF OBJECT_ID('cln.quality_events', 'U') IS NOT NULL
    DROP TABLE cln.quality_events;
GO

SELECT
    LTRIM(RTRIM(quality_event_id))                          AS quality_event_id,
    LTRIM(RTRIM(supplier_id))                               AS supplier_id,
    LTRIM(RTRIM(material_id))                               AS material_id,
    TRY_CONVERT(DATE, event_date, 120)                      AS event_date,
    UPPER(LTRIM(RTRIM(non_conformity_type)))                AS non_conformity_type,
    UPPER(LTRIM(RTRIM(severity_level)))                     AS severity_level,
    UPPER(LTRIM(RTRIM(recurrence_flag)))                    AS recurrence_flag,
    source_file_name,
    ingestion_timestamp
INTO cln.quality_events
FROM stg.quality_events_raw;
GO


-- =====================================================================
-- 8. Logs de automação
-- =====================================================================
-- Conversão de timestamps de execução e padronização de status.
-- Base para o Automation Monitor e monitoramento operacional.

IF OBJECT_ID('cln.automation_logs', 'U') IS NOT NULL
    DROP TABLE cln.automation_logs;
GO

SELECT
    LTRIM(RTRIM(log_id))                                    AS log_id,
    LTRIM(RTRIM(flow_name))                                 AS flow_name,
    TRY_CONVERT(DATETIME, execution_start_time, 120)        AS execution_start_time,
    TRY_CONVERT(DATETIME, execution_end_time, 120)          AS execution_end_time,
    UPPER(LTRIM(RTRIM(execution_status)))                   AS execution_status,
    LTRIM(RTRIM(error_message))                             AS error_message,
    LTRIM(RTRIM(processed_file_name))                       AS processed_file_name,
    source_file_name,
    ingestion_timestamp
INTO cln.automation_logs
FROM stg.automation_logs_raw;
GO


-- =====================================================================
-- 9. Resumo da camada
-- =====================================================================
/*
Tabelas criadas neste script:
    cln.purchase_orders         → Pedidos tratados
    cln.suppliers               → Fornecedores padronizados
    cln.procurement_budget      → Orçamento convertido
    cln.market_benchmark        → Benchmark com tipos corretos
    cln.supplier_delivery       → Entregas com datas convertidas
    cln.quality_events          → Eventos de qualidade padronizados
    cln.automation_logs         → Logs com timestamps convertidos

Transformações aplicadas nesta camada:
    ✓ LTRIM / RTRIM em todos os campos de texto
    ✓ UPPER em dimensões críticas (categoria, status, moeda, flags)
    ✓ TRY_CONVERT para DATE, DATETIME, INT e DECIMAL
    ✓ Preservação de source_file_name e ingestion_timestamp

Fora do escopo desta camada:
    ✗ Validação de negócio (ex: preço zero, pedido sem fornecedor)
    ✗ Eliminação de duplicidades lógicas
    ✗ Derivação de KPIs e métricas calculadas

Próxima etapa: 03_business_rules.sql
*/

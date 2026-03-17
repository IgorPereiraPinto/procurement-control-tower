# staging.sql
/*
=====================================================================
File    : 01_staging.sql
Project : Procurement Control Tower
Company : PrimeHarvest Foods Brasil
Layer   : Staging
Author  : Igor Pereira Pinto

Purpose:
    Simular a camada inicial de staging para recebimento e
    organização das tabelas brutas utilizadas na solução de
    Procurement Analytics da PrimeHarvest Foods Brasil.

    Esta camada representa o ponto de entrada dos dados no pipeline
    analítico. Os campos são mantidos como VARCHAR para preservar
    os dados brutos sem transformação, permitindo rastreabilidade
    completa antes do tratamento nas camadas subsequentes.

Pipeline:
    [Fontes Brutas] → [01_staging] → 02_cleaning → 03_business_rules
                                   → 04_quality_checks → 05_marts

Tables:
    stg.purchase_orders_raw
    stg.suppliers_raw
    stg.procurement_budget_raw
    stg.market_benchmark_raw
    stg.supplier_delivery_raw
    stg.quality_events_raw
    stg.automation_logs_raw

Notes:
    - Estrutura demonstrativa para portfólio.
    - Sintaxe orientada a SQL Server.
    - Dados fictícios para fins didáticos.
    - Campos tipados como VARCHAR intencionalmente:
      conversão e validação ocorrem em 02_cleaning.sql.
=====================================================================
*/


-- =====================================================================
-- 1. Criação do schema de staging
-- =====================================================================
-- Schema dedicado para isolar os dados brutos das camadas analíticas.
-- Facilita governança, permissões e rastreabilidade de origem.

IF NOT EXISTS (
    SELECT 1
    FROM sys.schemas
    WHERE name = 'stg'
)
BEGIN
    EXEC('CREATE SCHEMA stg');
END;
GO


-- =====================================================================
-- 2. Pedidos de compra brutos
-- =====================================================================
-- Fonte principal da solução. Alimenta spend, lead time, savings e
-- análise transacional. Inclui rastreabilidade de origem via
-- source_file_name e ingestion_timestamp.

IF OBJECT_ID('stg.purchase_orders_raw', 'U') IS NOT NULL
    DROP TABLE stg.purchase_orders_raw;
GO

CREATE TABLE stg.purchase_orders_raw (
    purchase_order_id       VARCHAR(50),        -- Identificador único do pedido
    purchase_order_line_id  VARCHAR(50),        -- Identificador da linha do pedido
    supplier_id             VARCHAR(50),        -- Chave do fornecedor
    material_id             VARCHAR(50),        -- Chave do material
    category_name           VARCHAR(100),       -- Categoria de Procurement
    order_date              VARCHAR(50),        -- Data de emissão (bruta)
    delivery_date           VARCHAR(50),        -- Data de entrega (bruta)
    quantity                VARCHAR(50),        -- Quantidade pedida (bruta)
    unit_price              VARCHAR(50),        -- Preço unitário (bruto)
    total_amount            VARCHAR(50),        -- Valor total (bruto)
    currency_code           VARCHAR(10),        -- Código da moeda
    plant_code              VARCHAR(50),        -- Planta ou centro de custo
    buyer_name              VARCHAR(100),       -- Comprador responsável
    source_file_name        VARCHAR(255),       -- Arquivo de origem
    ingestion_timestamp     DATETIME DEFAULT GETDATE()  -- Timestamp de carga
);
GO


-- =====================================================================
-- 3. Fornecedores brutos
-- =====================================================================
-- Base cadastral de fornecedores. Enriquece a análise de spend,
-- concentração e supplier risk com atributos como região,
-- status e categoria primária atendida.

IF OBJECT_ID('stg.suppliers_raw', 'U') IS NOT NULL
    DROP TABLE stg.suppliers_raw;
GO

CREATE TABLE stg.suppliers_raw (
    supplier_id             VARCHAR(50),        -- Identificador único do fornecedor
    supplier_name           VARCHAR(255),       -- Razão social ou nome comercial
    supplier_group          VARCHAR(100),       -- Grupo econômico
    supplier_region         VARCHAR(100),       -- Região de atuação
    supplier_status         VARCHAR(50),        -- Status cadastral (ativo, bloqueado etc.)
    category_primary        VARCHAR(100),       -- Categoria principal atendida
    contract_status         VARCHAR(50),        -- Status contratual
    source_file_name        VARCHAR(255),
    ingestion_timestamp     DATETIME DEFAULT GETDATE()
);
GO


-- =====================================================================
-- 4. Orçamento de Procurement bruto
-- =====================================================================
-- Base gerencial de orçamento por categoria e período. Alimenta
-- o cálculo de desvio vs orçamento e o acompanhamento financeiro.

IF OBJECT_ID('stg.procurement_budget_raw', 'U') IS NOT NULL
    DROP TABLE stg.procurement_budget_raw;
GO

CREATE TABLE stg.procurement_budget_raw (
    fiscal_year             VARCHAR(10),        -- Ano fiscal
    fiscal_month            VARCHAR(10),        -- Mês fiscal
    category_name           VARCHAR(100),       -- Categoria orçada
    budget_amount           VARCHAR(50),        -- Valor orçado (bruto)
    currency_code           VARCHAR(10),        -- Código da moeda
    source_file_name        VARCHAR(255),
    ingestion_timestamp     DATETIME DEFAULT GETDATE()
);
GO


-- =====================================================================
-- 5. Benchmark de mercado bruto
-- =====================================================================
-- Referências externas ou analíticas de preço por categoria.
-- Alimenta savings potencial, desvio vs benchmark e cost model.

IF OBJECT_ID('stg.market_benchmark_raw', 'U') IS NOT NULL
    DROP TABLE stg.market_benchmark_raw;
GO

CREATE TABLE stg.market_benchmark_raw (
    benchmark_date          VARCHAR(50),        -- Data de referência (bruta)
    category_name           VARCHAR(100),       -- Categoria referenciada
    reference_price         VARCHAR(50),        -- Preço de referência (bruto)
    benchmark_type          VARCHAR(100),       -- Tipo de benchmark (externo, interno etc.)
    source_name             VARCHAR(100),       -- Fonte da referência
    source_file_name        VARCHAR(255),
    ingestion_timestamp     DATETIME DEFAULT GETDATE()
);
GO


-- =====================================================================
-- 6. Performance logística bruta
-- =====================================================================
-- Eventos de entrega por fornecedor e pedido. Alimenta os KPIs
-- de atraso, lead time, SLA e composição do supplier risk score.

IF OBJECT_ID('stg.supplier_delivery_raw', 'U') IS NOT NULL
    DROP TABLE stg.supplier_delivery_raw;
GO

CREATE TABLE stg.supplier_delivery_raw (
    delivery_event_id       VARCHAR(50),        -- Identificador do evento de entrega
    supplier_id             VARCHAR(50),        -- Chave do fornecedor
    purchase_order_id       VARCHAR(50),        -- Pedido associado
    expected_delivery_date  VARCHAR(50),        -- Data esperada (bruta)
    actual_delivery_date    VARCHAR(50),        -- Data efetiva (bruta)
    delay_days              VARCHAR(50),        -- Dias de atraso (bruto)
    on_time_flag            VARCHAR(10),        -- Indicador de pontualidade (bruto)
    logistics_provider      VARCHAR(100),       -- Transportador ou operador logístico
    source_file_name        VARCHAR(255),
    ingestion_timestamp     DATETIME DEFAULT GETDATE()
);
GO


-- =====================================================================
-- 7. Eventos de qualidade brutos
-- =====================================================================
-- Não conformidades e desvios de qualidade por fornecedor e material.
-- Alimenta o supplier risk score e o monitoramento de criticidade.

IF OBJECT_ID('stg.quality_events_raw', 'U') IS NOT NULL
    DROP TABLE stg.quality_events_raw;
GO

CREATE TABLE stg.quality_events_raw (
    quality_event_id        VARCHAR(50),        -- Identificador do evento
    supplier_id             VARCHAR(50),        -- Fornecedor relacionado
    material_id             VARCHAR(50),        -- Material relacionado
    event_date              VARCHAR(50),        -- Data do evento (bruta)
    non_conformity_type     VARCHAR(100),       -- Tipo de não conformidade
    severity_level          VARCHAR(50),        -- Nível de severidade
    recurrence_flag         VARCHAR(10),        -- Indicador de reincidência (bruto)
    source_file_name        VARCHAR(255),
    ingestion_timestamp     DATETIME DEFAULT GETDATE()
);
GO


-- =====================================================================
-- 8. Logs de automação brutos
-- =====================================================================
-- Registros de execução dos fluxos automatizados. Alimenta o
-- Automation Monitor com dados de performance e falhas operacionais.

IF OBJECT_ID('stg.automation_logs_raw', 'U') IS NOT NULL
    DROP TABLE stg.automation_logs_raw;
GO

CREATE TABLE stg.automation_logs_raw (
    log_id                  VARCHAR(50),        -- Identificador do log
    flow_name               VARCHAR(100),       -- Nome do fluxo executado
    execution_start_time    VARCHAR(50),        -- Início da execução (bruto)
    execution_end_time      VARCHAR(50),        -- Fim da execução (bruto)
    execution_status        VARCHAR(50),        -- Status (sucesso, falha etc.)
    error_message           VARCHAR(500),       -- Mensagem de erro, se houver
    processed_file_name     VARCHAR(255),       -- Arquivo processado na execução
    source_file_name        VARCHAR(255),
    ingestion_timestamp     DATETIME DEFAULT GETDATE()
);
GO


-- =====================================================================
-- 9. Resumo da camada
-- =====================================================================
/*
Tabelas criadas neste script:
    stg.purchase_orders_raw     → Pedidos de compra
    stg.suppliers_raw           → Cadastro de fornecedores
    stg.procurement_budget_raw  → Orçamento de Procurement
    stg.market_benchmark_raw    → Referências de mercado
    stg.supplier_delivery_raw   → Performance logística
    stg.quality_events_raw      → Eventos de qualidade
    stg.automation_logs_raw     → Logs de automação

Estado esperado dos dados nesta camada:
    - Campos tipados como VARCHAR para preservar o dado bruto
    - Datas e valores sem conversão ou validação
    - Possível presença de nulos, duplicidades e inconsistências
    - Rastreabilidade garantida por source_file_name e ingestion_timestamp

Próxima etapa: 02_cleaning.sql
*/

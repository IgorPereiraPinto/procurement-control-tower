# 04_quality_checks.sql
/*
=====================================================================
File    : 04_quality_checks.sql
Project : Procurement Control Tower
Company : PrimeHarvest Foods Brasil
Layer   : Quality Checks
Author  : Igor Pereira Pinto

Purpose:
    Executar validações de integridade, completude, consistência
    e reconciliação nos dados tratados, registrando os problemas
    encontrados antes da liberação para consumo analítico.

    Esta camada não transforma dados — ela os inspeciona.
    Cada regra detecta um tipo específico de problema, classifica
    sua severidade e registra o registro afetado para rastreabilidade.

Pipeline:
    01_staging → 02_cleaning → 03_business_rules → [04_quality_checks]
                                                  → 05_marts

Objects:
    qlt.data_quality_issues     → Tabela de registro de problemas detectados
    qlt.data_quality_summary    → View de resumo por tipo e severidade

Checks executados:
    [CRITICAL] MISSING_SUPPLIER     → Pedido sem fornecedor válido
    [CRITICAL] AMOUNT_MISMATCH      → Divergência entre total e qty * preço
    [CRITICAL] INVALID_UNIT_PRICE   → Preço zero, negativo ou nulo
    [HIGH]     MISSING_CATEGORY     → Pedido sem categoria válida
    [HIGH]     DUPLICATE_SUPPLIER   → Fornecedor duplicado no cadastro
    [HIGH]     MISSING_BUDGET       → Categoria com gasto sem orçamento
    [MEDIUM]   MISSING_BENCHMARK    → Pedido sem benchmark para savings

Severidade:
    CRITICAL → Bloqueia consumo analítico confiável
    HIGH     → Permite consumo parcial, correção prioritária
    MEDIUM   → Não inviabiliza uso, mas reduz qualidade

Notes:
    - Estrutura demonstrativa para portfólio.
    - Sintaxe orientada a SQL Server.
    - Dados fictícios para fins didáticos.
    - Em produção, este script deve ser executado após
      03_business_rules.sql e antes de 05_marts.sql.
=====================================================================
*/


-- =====================================================================
-- 1. Criação do schema de quality
-- =====================================================================
-- Schema dedicado para isolar todos os objetos de qualidade de dados,
-- facilitando governança e controle de acesso por camada.

IF NOT EXISTS (
    SELECT 1
    FROM sys.schemas
    WHERE name = 'qlt'
)
BEGIN
    EXEC('CREATE SCHEMA qlt');
END;
GO


-- =====================================================================
-- 2. Tabela consolidada de problemas detectados
-- =====================================================================
-- Repositório central de todos os problemas encontrados pelos checks.
-- Cada linha representa um registro problemático com seu contexto
-- completo: tipo, severidade, tabela de origem e chave do registro.

IF OBJECT_ID('qlt.data_quality_issues', 'U') IS NOT NULL
    DROP TABLE qlt.data_quality_issues;
GO

CREATE TABLE qlt.data_quality_issues (
    issue_id            INT IDENTITY(1,1) PRIMARY KEY,  -- Identificador único do problema
    issue_type          VARCHAR(100),                   -- Código do tipo de problema
    severity_level      VARCHAR(20),                    -- CRITICAL / HIGH / MEDIUM
    source_table        VARCHAR(100),                   -- Tabela onde o problema foi detectado
    record_key          VARCHAR(255),                   -- Chave do registro afetado
    issue_description   VARCHAR(500),                   -- Descrição legível do problema
    detected_at         DATETIME DEFAULT GETDATE()      -- Timestamp de detecção
);
GO


-- =====================================================================
-- 3. [CRITICAL] Pedido sem fornecedor
-- =====================================================================
-- Regra: nenhum pedido deve existir sem supplier_id válido.
-- Impacto: inviabiliza análise de spend por fornecedor e supplier risk.

INSERT INTO qlt.data_quality_issues (
    issue_type, severity_level, source_table, record_key, issue_description
)
SELECT
    'MISSING_SUPPLIER',
    'CRITICAL',
    'cln.purchase_orders',
    purchase_order_id,
    'Pedido sem supplier_id válido. Inviabiliza análise de spend e supplier risk.'
FROM cln.purchase_orders
WHERE supplier_id IS NULL
   OR LTRIM(RTRIM(supplier_id)) = '';
GO


-- =====================================================================
-- 4. [HIGH] Pedido sem categoria
-- =====================================================================
-- Regra: todo pedido deve estar classificado em uma categoria válida.
-- Impacto: distorce leitura de spend por categoria e savings potencial.

INSERT INTO qlt.data_quality_issues (
    issue_type, severity_level, source_table, record_key, issue_description
)
SELECT
    'MISSING_CATEGORY',
    'HIGH',
    'cln.purchase_orders',
    purchase_order_id,
    'Pedido sem categoria válida. Distorce spend por categoria e savings potencial.'
FROM cln.purchase_orders
WHERE category_name IS NULL
   OR LTRIM(RTRIM(category_name)) = '';
GO


-- =====================================================================
-- 5. [CRITICAL] Valor total divergente
-- =====================================================================
-- Regra: total_amount deve ser consistente com quantity * unit_price.
-- Tolerância de R$ 0,50 para diferenças de arredondamento.
-- Impacto: compromete spend, savings e controle orçamentário.

INSERT INTO qlt.data_quality_issues (
    issue_type, severity_level, source_table, record_key, issue_description
)
SELECT
    'AMOUNT_MISMATCH',
    'CRITICAL',
    'cln.purchase_orders',
    purchase_order_id,
    'Divergência entre total_amount e quantity * unit_price (tolerância: R$ 0,50).'
FROM cln.purchase_orders
WHERE ABS(
    ISNULL(total_amount, 0) - (ISNULL(quantity, 0) * ISNULL(unit_price, 0))
) > 0.50;
GO


-- =====================================================================
-- 6. [CRITICAL] Preço unitário inválido
-- =====================================================================
-- Regra: unit_price deve ser maior que zero e não nulo.
-- Impacto: quebra consistência financeira e cálculo de savings.

INSERT INTO qlt.data_quality_issues (
    issue_type, severity_level, source_table, record_key, issue_description
)
SELECT
    'INVALID_UNIT_PRICE',
    'CRITICAL',
    'cln.purchase_orders',
    purchase_order_id,
    'Preço unitário zero, negativo ou nulo. Impede cálculo financeiro confiável.'
FROM cln.purchase_orders
WHERE unit_price IS NULL
   OR unit_price <= 0;
GO


-- =====================================================================
-- 7. [HIGH] Fornecedor duplicado no cadastro
-- =====================================================================
-- Regra: supplier_id deve ser único no cadastro limpo.
-- Impacto: fragmenta spend por fornecedor e distorce análise de
--          concentração e supplier risk score.

INSERT INTO qlt.data_quality_issues (
    issue_type, severity_level, source_table, record_key, issue_description
)
SELECT
    'DUPLICATE_SUPPLIER',
    'HIGH',
    'cln.suppliers',
    supplier_id,
    'supplier_id duplicado no cadastro limpo. Fragmenta spend e distorce supplier risk.'
FROM cln.suppliers
GROUP BY supplier_id
HAVING COUNT(*) > 1;
GO


-- =====================================================================
-- 8. [HIGH] Orçamento ausente para categoria com gasto
-- =====================================================================
-- Regra: toda categoria com gasto realizado deve ter orçamento previsto.
-- Impacto: impossibilita cálculo de desvio vs orçamento para a categoria.

INSERT INTO qlt.data_quality_issues (
    issue_type, severity_level, source_table, record_key, issue_description
)
SELECT
    'MISSING_BUDGET',
    'HIGH',
    'biz.budget_vs_actual',
    CONCAT(fiscal_year, '-', RIGHT('0' + CAST(fiscal_month AS VARCHAR), 2), '-', category_name),
    'Categoria com gasto realizado sem orçamento correspondente. Desvio não calculável.'
FROM biz.budget_vs_actual
WHERE budget_amount IS NULL;
GO


-- =====================================================================
-- 9. [MEDIUM] Benchmark ausente para cálculo de savings
-- =====================================================================
-- Regra: pedidos em categorias elegíveis devem ter benchmark disponível.
-- Impacto: limita leitura de savings potencial e cost model.

INSERT INTO qlt.data_quality_issues (
    issue_type, severity_level, source_table, record_key, issue_description
)
SELECT
    'MISSING_BENCHMARK',
    'MEDIUM',
    'biz.purchase_savings_opportunity',
    purchase_order_id,
    'Pedido sem benchmark disponível. Savings potencial não calculado para este registro.'
FROM biz.purchase_savings_opportunity
WHERE avg_reference_price IS NULL;
GO


-- =====================================================================
-- 10. View de resumo por tipo e severidade
-- =====================================================================
-- Visão agregada para consumo no painel de Data Quality do dashboard.
-- Permite leitura rápida do volume e distribuição de problemas.

IF OBJECT_ID('qlt.data_quality_summary', 'V') IS NOT NULL
    DROP VIEW qlt.data_quality_summary;
GO

CREATE VIEW qlt.data_quality_summary AS
SELECT
    severity_level,
    issue_type,
    source_table,
    COUNT(*)            AS issue_count,
    MIN(detected_at)    AS first_detected,
    MAX(detected_at)    AS last_detected
FROM qlt.data_quality_issues
GROUP BY
    severity_level,
    issue_type,
    source_table;
GO


-- =====================================================================
-- 11. Resumo da camada
-- =====================================================================
/*
Objetos criados neste script:
    qlt.data_quality_issues     → Registro detalhado de cada problema detectado
    qlt.data_quality_summary    → View agregada para dashboard de Data Quality

Checks executados:
    Severidade  │ Código                │ Fonte
    ────────────┼───────────────────────┼───────────────────────────────
    CRITICAL    │ MISSING_SUPPLIER      │ cln.purchase_orders
    CRITICAL    │ AMOUNT_MISMATCH       │ cln.purchase_orders
    CRITICAL    │ INVALID_UNIT_PRICE    │ cln.purchase_orders
    HIGH        │ MISSING_CATEGORY      │ cln.purchase_orders
    HIGH        │ DUPLICATE_SUPPLIER    │ cln.suppliers
    HIGH        │ MISSING_BUDGET        │ biz.budget_vs_actual
    MEDIUM      │ MISSING_BENCHMARK     │ biz.purchase_savings_opportunity

Fora do escopo desta camada:
    ✗ Correção automática dos problemas detectados
    ✗ Construção das visões finais para dashboard

Próxima etapa: 05_marts.sql
*/

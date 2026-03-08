# Procurement Control Tower

## Overview
Procurement Control Tower is an end-to-end analytics and process automation case developed for a fictional food industry company, **PrimeHarvest Foods Brasil**.

The project simulates a senior-level Procurement BI and Automation initiative designed to improve visibility over spend, supplier performance, cost drivers, data quality, and operational workflows. It combines analytical thinking, process design, governance, and executive storytelling to support sourcing and renegotiation decisions.

Although the scenario uses fictional data and a fictional company name, the business logic, architecture, and deliverables were designed to closely reflect real corporate challenges in the food manufacturing industry.

---

## Business Context
PrimeHarvest Foods Brasil is a fictional food company operating in categories such as sauces, condiments, processed vegetables, packaging, and logistics. The Procurement team manages direct and indirect categories and needs more reliable, scalable, and automated analytical support to reduce manual effort and improve decision-making.

The business scenario behind this project assumes common Procurement pain points:

- fragmented spreadsheets and manual consolidations
- limited traceability across files and updates
- difficulty identifying savings opportunities
- lack of standardized supplier risk monitoring
- absence of automated business alerts
- inconsistent data quality checks
- low visibility into the impact of market signals on purchasing categories

---

## Project Objective
The objective of this repository is to demonstrate how a senior BI / Data / Automation professional could structure a complete Procurement analytics solution with:

- SQL-based dataset consolidation
- data quality and reconciliation logic
- business-oriented KPI design
- workflow automation concepts using Power Automate
- operational standardization using VBA
- an executive dashboard experience inspired by Power BI
- recommendations focused on risk, opportunity, and financial impact

---

## Core Modules
The solution is structured into six business modules:

### 1. Spend Overview
Provides visibility into total spend, spend by category, spend by supplier, and monthly variation.

### 2. Savings & Budget
Monitors savings delivered, savings potential, and deviations versus budget or benchmark references.

### 3. Supplier Risk
Tracks supplier concentration, delivery delays, quality events, and an overall supplier risk score.

### 4. Cost Model
Connects market signals such as commodity pressure, logistics cost, and currency variation to category-level cost impact.

### 5. Data Quality
Applies validation, reconciliation, and traceability rules to improve confidence in Procurement reporting.

### 6. Automation Monitor
Documents workflow automation concepts for file intake, validation, refresh orchestration, alerting, and exception handling.

---

## Repository Structure

```text
docs/        -> business documentation, KPI catalog, operating model, glossary and executive summary
sql/         -> SQL logic for staging, cleaning, business rules, quality checks and marts
automate/    -> Power Automate flow documentation and process design
vba/         -> VBA use case for spreadsheet standardization and intake preparation
dashboard/   -> HTML dashboard prototype inspired by a Power BI executive experience
outputs/     -> illustrative screenshots and visual artifacts used in the portfolio narrative

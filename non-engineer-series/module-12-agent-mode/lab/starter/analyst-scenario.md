# Analyst Scenario: Sales Dataset Report

**Module:** 12 — Agent Mode for Non-Engineers
**Role:** Business Analyst / Finance

---

## Your Scenario

You are a business analyst at a SaaS company. Your VP asked for a quick data quality assessment before the sales team starts using the new CRM export. The export is a 50-row CSV with some known issues. You need to document the problems and recommend cleaning steps.

Your goal: use agent mode to analyze the dataset, surface data quality issues, and generate a summary report — without writing any Python yourself.

## Your Goal (3-Step Agentic Task)

Use Copilot agent mode to:
1. **Load and describe** the sales dataset structure and basic statistics
2. **Identify** all data quality issues (nulls, inconsistencies, outliers)
3. **Generate** a formatted data quality report document

## Files You'll Use

- `non-engineer-series/module-06-python/lab/data/sales.csv` — The sales dataset

## Expected Issues to Find

The dataset has intentional data quality problems:
- Null values in `amount` (3 rows) and `customer_tier` (5 rows)
- Inconsistent `region` casing: "north", "NORTH", "North" are all different entries
- Mix of title case and uppercase product names
- Missing values affecting downstream aggregation accuracy

## What Good Looks Like

After completing this task, you should have:
- A count of nulls per column
- A list of the unique inconsistent values in the `region` column
- A markdown report with: Executive Summary, Data Issues table, Cleaning Recommendations

## Report Template

Your final report should include these sections:
1. Executive Summary (2 sentences)
2. Dataset Overview (rows, columns, date range)
3. Data Quality Issues (table: column, issue type, count, impact)
4. Recommended Cleaning Steps (numbered list)
5. Sign-off section with your name and date

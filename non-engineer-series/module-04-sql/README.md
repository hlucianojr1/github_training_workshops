# Module 04: SQL Without Fear

**Duration:** 120 minutes | **Audience:** Business Analysts, Finance, Operations, Data-adjacent roles | **Format:** Workshop

## Overview

SQL (Structured Query Language) is how you talk to databases — and with GitHub Copilot, you don't need to memorize syntax. You describe what you want in plain English, and Copilot writes the SQL. This module teaches you to answer real business questions from a database using Copilot as your SQL translator.

## Learning Objectives

By the end of this module, you will be able to:

1. Explain what a database table is and how tables relate to each other
2. Use Copilot to translate plain-English business questions into SQL queries
3. Run queries in a browser-based SQL tool (no installation required)
4. Interpret query results and identify data quality issues
5. Ask Copilot to explain, debug, and optimize SQL queries

## Agenda

| Time | Activity |
|------|----------|
| 0–15 min | What is a database? Tables, rows, columns explained |
| 15–30 min | Demo: SELECT, WHERE, ORDER BY in plain language |
| 30–45 min | Demo: GROUP BY and aggregate functions (COUNT, SUM, AVG) |
| 45–60 min | Demo: JOINs explained simply with a business example |
| 60–100 min | Lab: Answer 10 business questions with SQL |
| 100–120 min | Debugging SQL errors with Copilot, Q&A |

## Key Concepts

### Tables Are Spreadsheets

A database table is like a spreadsheet with rows and columns. The `customers` table has one row per customer. The `invoices` table has one row per invoice. Tables connect to each other through shared ID columns.

### The Basic Query Structure

Every SQL query follows the same pattern:

```sql
SELECT  what_you_want
FROM    which_table
WHERE   conditions
ORDER BY how_to_sort
LIMIT   how_many_rows;
```

### Natural Language → SQL with Copilot

You don't need to learn SQL syntax. Describe what you want:

> "Write SQL to find all customers on the 'enterprise' plan whose invoices are overdue. Show customer name, plan, and invoice amount."

Copilot writes the query. You paste it into your SQL tool and run it.

### JOINs in Plain English

A JOIN combines data from two tables:
> "Write SQL to join the customers table and invoices table on customer_id, then show customer name and total invoice amount for each customer."

### Asking Copilot to Explain SQL

If you get a query you don't understand:
> "Explain this SQL query in plain English, line by line: [paste query]"

### Database Safety

> ⚠️ **Never run generated SQL on a production database without a developer review.** Always test in a safe environment first. Read-only queries (SELECT) are safer than write queries (INSERT, UPDATE, DELETE).

## Prerequisites

- Module 00 (Foundations) recommended
- No SQL knowledge required

## Lab

See [lab/README.md](lab/README.md).

## Files

- `slides/outline.md`
- `lab/README.md` — Answer 10 Business Questions with SQL
- `lab/saas-business.sql` — CloudMetrics database schema + seed data
- `lab/questions.md` — 10 business questions to answer
- `facilitator-guide.md`
- `assessment.md`

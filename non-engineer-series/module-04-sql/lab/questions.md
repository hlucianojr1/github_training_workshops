# 10 Business Questions to Answer with SQL

**Module:** 04 — SQL Without Fear
**Database:** CloudMetrics (`saas-business.sql`)

Use GitHub Copilot to generate the SQL for each question. Paste the query into DB Fiddle (dbfiddle.uk), run it, and record the result.

**Copilot prompt template:**
> "Write SQLite SQL to answer this question using the CloudMetrics database (customers, invoices, support_tickets tables): [your question]. Show columns: [column names]."

---

## Question 1: Total MRR by Plan Tier

**Business question:** How much monthly recurring revenue do we have, broken down by plan?

**Hint prompt:**
> "Write SQL to calculate the total MRR for each plan tier in the customers table. Only include active customers (where churn_date is NULL). Show columns: plan, total_mrr. Order by total_mrr descending."

**Expected columns:** `plan`, `total_mrr`

---

## Question 2: Recently Churned Customers

**Business question:** Which customers have churned in the last 90 days?

**Hint prompt:**
> "Write SQL to find all customers whose churn_date is within the last 90 days of today. Show: customer name, plan, mrr, churn_date. Order by churn_date descending."

**Expected columns:** `name`, `plan`, `mrr`, `churn_date`

---

## Question 3: Average Invoice Amount by Plan

**Business question:** How does the average invoice size differ by customer plan?

**Hint prompt:**
> "Write SQL to join the invoices and customers tables and calculate the average invoice amount for each customer plan. Show: plan, avg_invoice_amount. Round to 2 decimal places."

**Expected columns:** `plan`, `avg_invoice_amount`

---

## Question 4: Support Ticket Count by Severity

**Business question:** How many support tickets do we have at each severity level?

**Hint prompt:**
> "Write SQL to count support tickets by severity. Show: severity, ticket_count. Order from most critical to least."

**Expected columns:** `severity`, `ticket_count`

---

## Question 5: Customers with Multiple Overdue Invoices

**Business question:** Which customers have more than 1 overdue invoice (potential churn risk)?

**Hint prompt:**
> "Write SQL to find customers who have more than 1 invoice with status 'overdue'. Show: customer name, plan, count of overdue invoices. Order by count descending."

**Expected columns:** `name`, `plan`, `overdue_count`

---

## Question 6: New Signups by Month

**Business question:** How many new customers signed up each month in 2024?

**Hint prompt:**
> "Write SQL to count new customer signups by month for the year 2024. Show: month (as YYYY-MM format), signup_count. Order by month ascending."

**Expected columns:** `month`, `signup_count`

---

## Question 7: Average Ticket Resolution Time

**Business question:** On average, how many days does it take to resolve a support ticket?

**Hint prompt:**
> "Write SQL to calculate the average number of days between created_at and resolved_at for support tickets that have been resolved (resolved_at is not NULL). Show a single value: avg_days_to_resolve. Round to 1 decimal place."

**Expected columns:** `avg_days_to_resolve`

---

## Question 8: Top 5 Customers by Total Spend

**Business question:** Who are our 5 highest-spending customers based on total invoice amounts?

**Hint prompt:**
> "Write SQL to find the top 5 customers by total invoice spend (sum of all invoice amounts). Join customers and invoices. Show: customer name, plan, total_spend. Order by total_spend descending. Limit to 5."

**Expected columns:** `name`, `plan`, `total_spend`

---

## Question 9: Churn Rate by Plan

**Business question:** What percentage of customers have churned, by plan tier?

**Hint prompt:**
> "Write SQL to calculate the churn rate for each plan. Churn rate = (number of customers with a churn_date / total customers in that plan) * 100. Show: plan, total_customers, churned_customers, churn_rate_pct. Round to 1 decimal place."

**Expected columns:** `plan`, `total_customers`, `churned_customers`, `churn_rate_pct`

---

## Question 10: Customers Who Never Opened a Support Ticket

**Business question:** Which customers have never submitted a support ticket (potentially disengaged)?

**Hint prompt:**
> "Write SQL to find all customers who do not have any rows in the support_tickets table. Show: customer name, plan, mrr, signup_date. Order by mrr descending."

**Expected columns:** `name`, `plan`, `mrr`, `signup_date`

---

## Bonus Question: Overdue Invoice Revenue at Risk

**Business question:** How much revenue is at risk from overdue invoices?

**Hint prompt:**
> "Write SQL to calculate the total amount of all overdue invoices, grouped by customer plan. Show: plan, overdue_amount. Order by overdue_amount descending."

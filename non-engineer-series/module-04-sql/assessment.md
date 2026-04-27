# Assessment: Module 04 — SQL Without Fear

## Pre-Quiz

**1. What does SQL stand for?**
- A) System Query Layer
- B) Structured Query Language
- C) Sequential Question Logic
- D) Simple Query List

**2. In a database, a "table" most closely resembles which of the following?**
- A) A chart or graph
- B) A spreadsheet with rows and columns
- C) A folder of documents
- D) A form with input fields

**3. Which SQL keyword is used to filter rows based on a condition?**
- A) FILTER
- B) SELECT
- C) WHERE
- D) GROUP

**4. What is a JOIN used for in SQL?**
- A) Combining rows from two or more tables that share a related column
- B) Adding new data to a table
- C) Sorting results alphabetically
- D) Deleting duplicate rows

**5. Which of the following is a safe practice when running AI-generated SQL?**
- A) Run it immediately on the production database to get real results
- B) Test it in a development or sandbox environment first
- C) Share the database credentials with the AI tool for better results
- D) Only run it on weekends to minimize impact

---

## Post-Quiz

**1. You want to find all customers on the "growth" plan whose invoices are overdue. Which SQL clause would filter for the overdue invoices?**
- A) `ORDER BY status = 'overdue'`
- B) `GROUP BY invoices.status`
- C) `WHERE invoices.status = 'overdue'`
- D) `SELECT status FROM overdue`

**2. Which Copilot prompt would most reliably generate a correct SQL query?**
- A) "SQL to find customers"
- B) "Write SQLite SQL to find all customers on the 'enterprise' plan who have at least one unpaid invoice. Show: customer name, plan, invoice amount. Use the customers and invoices tables joined on customer_id."
- C) "Get me the data I need from the database about enterprise customers"
- D) "Database query for invoice report"

**3. Your SQL query returns 0 rows, but you expect at least 10. What is the BEST first step?**
- A) Delete all the data and re-import it
- B) Change the database engine
- C) Ask Copilot: "This query returns 0 rows but I expect results. Here is the query: [paste]. What might be wrong?"
- D) The query is correct; the database must be empty

**4. You want to count how many customers are on each plan. Which SQL construct would you use?**
- A) WHERE plan = 'count'
- B) SELECT plan, COUNT(*) FROM customers GROUP BY plan
- C) ORDER BY plan COUNT
- D) HAVING plan = each

**5. A business stakeholder asks: "What is our total revenue from overdue invoices by customer plan?" Which Copilot prompt best captures this?**
- A) "Overdue invoices query"
- B) "Write SQL to find overdue invoices"
- C) "Write SQLite SQL to calculate the total amount of overdue invoices, grouped by customer plan. Join the invoices and customers tables. Show: plan, total_overdue_amount. Order by total descending."
- D) "SQL for revenue report by plan type with overdue status"

---

## Practical Challenge

**Instructions:**

Ask a data question that matters to your actual job.

1. Think of a real data question you've asked a colleague or analyst in the last 6 months
2. Write it as a Copilot prompt that specifies: the tables needed, the filter conditions, and the output columns
3. Use DB Fiddle with the `saas-business.sql` schema (or adapt to a schema your team uses) to test it
4. If the query fails, use Copilot to debug it

**Submit:** Share your question, the prompt you used, and whether the result matched your expectation.

---

## Answer Key

### Pre-Quiz
1. **B** — Structured Query Language
2. **B** — A spreadsheet analogy works well for relational tables
3. **C** — WHERE filters rows
4. **A** — JOIN combines rows from related tables
5. **B** — Always test in a safe environment first

### Post-Quiz
1. **C** — `WHERE invoices.status = 'overdue'`
2. **B** — The complete prompt with table names, join key, and output columns
3. **C** — Copilot is best at debugging its own output when given the query and the error
4. **B** — GROUP BY with COUNT is the correct pattern
5. **C** — The complete, specific prompt with all required context

### Practical Challenge Rubric
- [ ] Question is based on real work context (not fabricated)
- [ ] Prompt specifies table names and join conditions
- [ ] Prompt specifies output columns
- [ ] Participant attempted at least one debugging iteration if the first query failed
- [ ] Result was verified manually (not just trusted blindly)

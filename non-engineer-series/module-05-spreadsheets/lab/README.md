# Lab: 5 Formula Challenges

**Time:** 20 minutes | **Module:** 05 — Spreadsheet Superpowers

## What You'll Do

Solve 5 spreadsheet formula challenges using GitHub Copilot — from VLOOKUP to Apps Script macros. No formula memorization required.

## Setup

1. Open Google Sheets or Excel (either works for challenges 1–4)
2. Open GitHub Copilot Chat
3. Open `lab/formula-challenges.md` for the data descriptions

---

## How to Use Copilot for Formulas

For every challenge, use this prompt structure:
> "Write an [Excel/Google Sheets] formula to [describe what you need]. My data has: [describe column layout]. [Add any constraints like 'handle missing values']."

Then:
1. Copy the formula
2. Paste it into a spreadsheet cell
3. Test with the sample data
4. If it fails, ask Copilot to fix the error

---

## Challenge 1: VLOOKUP → XLOOKUP

**Context:** You have an employee roster and a separate salary table. You need to look up each employee's salary by their ID.

**Data:** Column A = Employee ID, Column B = Employee Name. Salary table on Sheet2: Column A = ID, Column B = Annual Salary.

**Prompt:**
> "Write a Google Sheets XLOOKUP formula to look up the annual salary for each employee. The employee ID is in column A. The lookup table is on Sheet2 where column A has IDs and column B has salaries. Return 'Not Found' if the employee ID is missing."

**Test it:** Add a row with an ID that doesn't exist in the lookup table. Does it return "Not Found"?

---

## Challenge 2: Multi-Condition Sum (SUMIFS)

**Context:** You manage a regional sales spreadsheet. You need to sum Q3 sales for the West region.

**Data:** Column A = Region, Column B = Quarter, Column C = Sales Amount.

**Prompt:**
> "Write an Excel SUMIFS formula to sum values in column C only where column A equals 'West' AND column B equals 'Q3'."

**Extension:** Change the formula to also filter by a third condition: Product Category in column D = "Recurring".

---

## Challenge 3: Nested IF — Revenue Tier Classification

**Context:** You want to automatically classify deal sizes for pipeline reporting.

**Rules:** Amount < $10,000 = "Small", $10,000–$49,999 = "Medium", $50,000–$199,999 = "Large", ≥ $200,000 = "Enterprise"

**Prompt:**
> "Write an Excel nested IF formula to categorize the deal amount in cell D2 as: 'Small' if under $10,000, 'Medium' if $10,000 to $49,999, 'Large' if $50,000 to $199,999, and 'Enterprise' if $200,000 or more."

**Test it:** Enter amounts of $5,000, $25,000, $75,000, and $250,000 and verify the categories.

---

## Challenge 4: Debug a Broken Formula

Open a new sheet and paste this broken formula into cell E2:
`=SUMIFS(D:D,A:A,"West,B:B,"Q3")`

**Prompt:**
> "This Excel formula has an error: =SUMIFS(D:D,A:A,"West,B:B,"Q3"). What is wrong and what is the corrected formula?"

**Verify:** Can you spot the error yourself before reading Copilot's answer?

---

## Challenge 5: Google Apps Script Macro

**Context:** Your weekly report spreadsheet has a "Status" column (column E). You want to automatically color a row red when the status is "Overdue".

**Prompt:**
> "Write a Google Apps Script function called highlightOverdue that loops through all rows in Sheet1 with data in column A and colors the entire row red if column E contains the text 'Overdue'. Ignore the header row."

**To run it:**
1. In Google Sheets: Tools → Apps Script
2. Paste the function
3. Click Run → authorize → check the result

---

## Reflection

- Which challenge took the longest? What made it harder to describe?
- How would you ask Copilot to undo the formatting applied by the Apps Script?
- What repetitive spreadsheet task at your job could be automated with a script?

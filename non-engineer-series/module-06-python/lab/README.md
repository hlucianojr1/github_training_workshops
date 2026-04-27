# Lab: Clean and Analyze the Sales Dataset

**Time:** 40 minutes | **Module:** 06 — Light Python for Analysts

## What You'll Build

A clean, analysis-ready version of the sales dataset, plus a bar chart visualization — all generated with GitHub Copilot in a Python environment.

## Setup

**Option A — GitHub Codespace (recommended):**
1. Click "Code" → "Codespaces" → "Create codespace on this branch"
2. Wait ~60 seconds for setup to complete
3. A VS Code environment opens in your browser with Python pre-installed

**Option B — Local Python:**
1. Install Python 3.11+ and run `pip install pandas matplotlib`
2. Open VS Code, install the Python and Copilot extensions

---

## Task 1: Load and Inspect the Data

**Step 1:** In VS Code, open the Copilot Chat panel.

**Step 2:** Type this prompt:

> "Write Python to load lab/data/sales.csv using pandas and print: the first 5 rows, the shape (rows and columns), and the column data types."

**Step 3:** Copy the generated code. Create a new file called `analysis.py` in the `lab/` folder. Paste the code and run it with `python analysis.py`.

**Expected output:** A table showing 5 rows of data and the DataFrame info.

**Reflection:** How many rows and columns does the dataset have? Which columns have unexpected data types?

---

## Task 2: Find Data Quality Issues

**Prompt:**
> "Add code to the existing analysis to show: which columns have null values and how many nulls are in each column, and the unique values in the 'region' column."

**Expected output:** A count of nulls per column and a list showing the region inconsistencies (e.g., "north", "NORTH", "North" are all different entries).

---

## Task 3: Fix Null Values

**Prompt:**
> "Add code to: fill null values in the 'customer_tier' column with 'Unknown', and drop rows where the 'amount' column is null. Print the shape before and after to show the change."

**Expected output:** Shape before (50 rows) and after (rows reduced by the number of null amounts).

---

## Task 4: Standardize the Region Column

**Prompt:**
> "Add code to standardize the 'region' column so all values are title case (North, South, East, West). Print the unique values before and after to confirm."

**Expected output:** Before showing mixed case values, after showing consistent title case.

---

## Task 5: Group and Aggregate

**Prompt:**
> "Add code to group the cleaned DataFrame by 'region' and calculate: total sales amount, average units sold, and number of transactions per region. Sort by total sales descending. Print the results as a formatted table."

**Expected output:** A table with one row per region showing the three calculated metrics.

---

## Task 6: Create a Bar Chart

**Prompt:**
> "Add code to create a horizontal bar chart showing total sales amount by region using matplotlib. Use a blue color palette. Add a title 'Total Sales by Region', axis labels, and save the chart as 'lab/sales_by_region.png'."

**Expected output:** A `sales_by_region.png` file appears in the `lab/` folder.

---

## Task 7: Export Cleaned Data

**Prompt:**
> "Add code to export the cleaned DataFrame to a CSV file named 'lab/cleaned_sales.csv'. Do not include the row index in the output."

---

## What to Do If It Crashes

**Error message:** `ModuleNotFoundError: No module named 'pandas'`
- Fix: Run `pip install pandas matplotlib` in the terminal

**Error message:** `FileNotFoundError: lab/data/sales.csv`
- Fix: Make sure you're running the script from the module root folder. Ask Copilot: "How do I fix a FileNotFoundError when the file path looks correct?"

**Any other error:**
> "My Python script returned this error: [paste error]. Here is the code: [paste code]. What is wrong and how do I fix it?"

---

## Reflection

- Which data quality issues would have caused errors if you hadn't cleaned them?
- How would you add a second chart (e.g., sales by product)?
- How would you schedule this script to run automatically every week?

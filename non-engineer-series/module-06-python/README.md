# Module 06: Light Python for Analysts

**Duration:** 150 minutes | **Audience:** Business Analysts, Data-adjacent roles | **Format:** Hands-on Lab

## Overview

Python is the world's most popular language for data work — but you don't need to be a programmer to use it. With GitHub Copilot, you describe what you want to do with your data, and Copilot writes the Python. This module teaches you to clean, analyze, and visualize a real dataset using Copilot in a GitHub Codespace (no installation required).

## Learning Objectives

By the end of this module, you will be able to:

1. Open a Python environment in a GitHub Codespace with zero local setup
2. Load a CSV file into a pandas DataFrame using a Copilot-generated script
3. Identify and fix common data quality issues (nulls, inconsistent casing, wrong types)
4. Group and aggregate data to answer business questions
5. Create a bar chart visualization and save it as an image file

## Agenda

| Time | Activity |
|------|----------|
| 0–15 min | Why Python, why now? The analyst case |
| 15–25 min | Codespaces orientation — what you have, how to navigate |
| 25–40 min | Demo: Load and inspect the sales dataset |
| 40–60 min | Demo: Clean data quality issues with Copilot |
| 60–80 min | Demo: Group by and calculate aggregates |
| 80–100 min | Demo: Create and save a bar chart |
| 100–140 min | Lab: Clean and analyze the sales dataset |
| 140–150 min | Debrief, export to Excel, Q&A |

## Key Concepts

### Why a Codespace?

A GitHub Codespace is a full development environment in your browser. No installation, no Python setup, no "it works on my machine." The `.devcontainer/` folder in this module pre-installs everything you need — Python, pandas, and Jupyter — so you can start immediately.

### pandas in One Sentence

pandas is a Python library for working with tabular data (think spreadsheet-style tables). A pandas DataFrame is like an Excel table in memory — rows, columns, filters, formulas, all in code.

### The Analyst Workflow

```
Load data → Inspect → Clean → Transform → Analyze → Visualize → Export
```
Each step maps to a Copilot prompt. You don't write Python from scratch — you describe each step and let Copilot generate it.

### Copilot Prompt Patterns for Data Work

| Task | Prompt Pattern |
|------|---------------|
| Load data | "Write Python to load [file] using pandas and show the first 5 rows" |
| Find nulls | "Show which columns have null values and how many" |
| Fix nulls | "Fill nulls in [column] with [value] and drop rows where [column] is null" |
| Standardize | "Standardize the [column] column so all values are title case" |
| Aggregate | "Group by [column] and calculate total [metric] per group" |
| Visualize | "Create a bar chart of [metric] by [group] using matplotlib" |
| Export | "Export the DataFrame to a CSV file named [filename]" |

### When Things Break

Python errors look scary but Copilot can explain and fix them:
> "My Python script returned this error: [paste error message]. Here is the code: [paste code]. What is wrong and how do I fix it?"

## Prerequisites

- Module 00 (Foundations) recommended
- GitHub account (to create a Codespace)
- No Python knowledge required

## Lab

See [lab/README.md](lab/README.md). Uses the `.devcontainer/` Codespace setup.

## Files

- `slides/outline.md`
- `.devcontainer/devcontainer.json` — Codespace configuration
- `.devcontainer/requirements.txt` — Python package list
- `lab/README.md` — Clean and Analyze the Sales Dataset
- `lab/data/sales.csv` — 50-row sales dataset with intentional data quality issues
- `facilitator-guide.md`
- `assessment.md`

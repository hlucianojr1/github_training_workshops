# Assessment: Module 13 — Custom Instructions & Copilot Setup

## Pre-Quiz

**1. Where does a repository-scoped `copilot-instructions.md` file need to be placed?**
- A) In the root of the repository
- B) In the `.github/` folder
- C) In a folder called `copilot/`
- D) In the `docs/` folder

**2. What is the PRIMARY purpose of a `copilot-instructions.md` file?**
- A) To store API keys and secrets for Copilot to use
- B) To tell Copilot about the repository's context, audience, tone, and standards
- C) To disable certain Copilot features for compliance
- D) To train a custom AI model on your codebase

**3. Which of the following would be MOST useful to include in a copilot-instructions.md for an HR team?**
- A) The company's stock ticker symbol
- B) A glossary of HR terms like "HRBP", "headcount", and "leveling"
- C) The names and email addresses of all HR team members
- D) The organization chart in ASCII format

**4. Who can see a `copilot-instructions.md` file in a public GitHub repository?**
- A) Only the repository owner
- B) Only GitHub employees
- C) Anyone who can access the repository
- D) Only users with Copilot licenses

**5. What is an "example pair" in a copilot-instructions.md file?**
- A) Two versions of the same instruction in different languages
- B) A sample prompt and a description of the expected output quality, showing Copilot the desired behavior
- C) Two linked repositories that share the same instructions
- D) A pair of team members who co-own the file

---

## Post-Quiz

**1. A new marketing manager joins your team and complains that Copilot keeps using technical jargon in content she generates. What is the BEST solution?**
- A) Tell her to add "use simple language" to every prompt
- B) Ask her to use a different AI tool
- C) Add a tone section to your team's copilot-instructions.md specifying plain language and reading level
- D) Turn off Copilot for the marketing team

**2. Your team's copilot-instructions.md has a glossary but Copilot still uses the wrong term for an internal process. What should you add?**
- A) The term in ALL CAPS to the glossary so Copilot notices it
- B) An example pair showing a prompt that uses the term and the expected response using the correct terminology
- C) A new file called "glossary-override.md"
- D) Submit a bug report to GitHub

**3. Which of the following instructions would have the HIGHEST impact on improving Copilot output quality for a healthcare team?**
- A) "Always respond quickly."
- B) "Use a professional tone."
- C) "Target grade 8 reading level, avoid clinical jargon (use our glossary instead), address the reader as 'you', and never use passive voice."
- D) "Follow all healthcare regulations."

**4. You want to share your team's copilot-instructions.md with a different department. What is the BEST approach?**
- A) Copy the file and paste it into a Slack message
- B) Create a pull request in their repository with an adapted version of your instructions file
- C) Email them a PDF version
- D) Custom instructions cannot be shared between departments

**5. After setting up copilot-instructions.md, a colleague reports that Copilot is now ignoring most of the instructions. What should you do FIRST?**
- A) Delete the file and start over
- B) Use a longer, more detailed instructions file
- C) Review the file for contradictions and verify the file is in `.github/copilot-instructions.md` exactly
- D) Contact GitHub support

---

## Practical Challenge

**Instructions:**

Write a `copilot-instructions.md` file for a real repository you own or manage.

1. Choose a real GitHub repository (or create one for your team)
2. Write the instructions file with at least: Repository Purpose, Audience description, Tone section (3+ rules), a Glossary (5+ domain terms), and 2 example pairs
3. Commit it to `.github/copilot-instructions.md`
4. Test it: run the same prompt before and after adding the file and compare the outputs

**Submit:** Share a brief summary of: what changed between the before/after responses, which instruction had the most impact, and one thing you would add next.

---

## Answer Key

### Pre-Quiz
1. **B** — `.github/copilot-instructions.md` is the correct path
2. **B** — The file provides repository context, audience, tone, and standards
3. **B** — A domain glossary is the most immediately useful addition for a specialized team
4. **C** — Anyone with repo access can see the file (in public repos, that's everyone)
5. **B** — Example pairs show Copilot the desired behavior through demonstration

### Post-Quiz
1. **C** — The right fix is updating the instructions for the whole team, not patching individual prompts
2. **B** — Example pairs have higher impact than glossary entries alone
3. **C** — Specific, actionable rules outperform vague tone guidance
4. **B** — A PR with an adapted version is the professional, version-controlled approach
5. **C** — Check for contradictions and verify the exact file path first

### Practical Challenge Rubric
- [ ] File is in `.github/copilot-instructions.md` (correct path)
- [ ] Includes at least 5 domain glossary terms with plain-language definitions
- [ ] Includes at least 2 example pairs (prompt + expected output description)
- [ ] Participant ran a before/after comparison and documented the difference
- [ ] Tone rules are specific (not just "be professional")

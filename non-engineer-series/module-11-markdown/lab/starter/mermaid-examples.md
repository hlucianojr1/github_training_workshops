# Mermaid Diagram Examples

GitHub renders Mermaid diagrams directly in Markdown files. Copy these examples as starting points and ask Copilot to modify them for your use case.

---

## Example 1: Flowchart — Employee Onboarding Process

Use this for any process with decisions (yes/no branches).

```mermaid
flowchart TD
    A([New Hire Accepts Offer]) --> B[HR sends welcome email]
    B --> C[IT creates accounts]
    C --> D{Manager assigned?}
    D -->|Yes| E[Schedule Day 1 orientation]
    D -->|No| F[Assign interim manager]
    F --> E
    E --> G[Complete compliance training]
    G --> H{Training passed?}
    H -->|Yes| I[Add to team channels]
    H -->|No| J[Schedule retraining]
    J --> G
    I --> K([Onboarding Complete])
```

**Copilot prompt to adapt this:**
> "Modify this Mermaid flowchart to show the [YOUR PROCESS] process. Keep the same structure but replace the steps with: [describe your steps]."

---

## Example 2: Sequence Diagram — Approval Request Flow

Use this for processes involving multiple people or systems communicating in sequence.

```mermaid
sequenceDiagram
    actor Employee
    participant System as Expense System
    participant Manager
    participant Finance

    Employee->>System: Submit expense report
    System-->>Employee: Confirmation email sent
    System->>Manager: Approval request notification
    Manager->>System: Reviews and approves
    System-->>Employee: Approval notification
    System->>Finance: Route for payment
    Finance->>System: Mark as paid
    System-->>Employee: Payment confirmation
```

**Copilot prompt to adapt this:**
> "Create a Mermaid sequence diagram showing [YOUR PROCESS] with these participants: [list roles/systems]. The sequence of events is: [describe steps in order]."

---

## Example 3: Gantt Chart — Product Launch Timeline

Use this for project timelines with phases and milestones.

```mermaid
gantt
    title Product Launch Timeline — Q2 2024
    dateFormat  YYYY-MM-DD
    section Discovery
    Market research          :done,    research, 2024-01-15, 2024-02-01
    Stakeholder interviews   :done,    interviews, 2024-01-22, 2024-02-05
    section Development
    Feature specification    :done,    spec, 2024-02-05, 2024-02-20
    Engineering sprint 1     :active,  sprint1, 2024-02-20, 2024-03-15
    Engineering sprint 2     :         sprint2, 2024-03-15, 2024-04-10
    section Launch
    Beta testing             :         beta, 2024-04-01, 2024-04-20
    Marketing campaign prep  :         mktg, 2024-03-20, 2024-04-25
    Launch day               :milestone, launch, 2024-04-30, 1d
```

**Copilot prompt to adapt this:**
> "Create a Mermaid Gantt chart for the following project timeline: [describe your phases and approximate dates]. Include at least one milestone marker."

---

## Tips for Working with Mermaid and Copilot

- If the diagram doesn't render, ask Copilot: "This Mermaid diagram has a syntax error: [paste code]. Fix it."
- Keep node labels short — under 40 characters works best
- Use `---` (flowchart) for processes, `sequenceDiagram` for interactions, `gantt` for timelines
- Preview Mermaid diagrams at [mermaid.live](https://mermaid.live) before committing

name: Bug Report
description: Report a problem with the CloudMetrics platform
title: "[Bug]: "
labels: ["bug", "needs-triage"]
# TODO: Add assignees field using Copilot
# Prompt: "Add an assignees field to this GitHub issue template YAML that defaults to empty"

body:
  - type: markdown
    attributes:
      value: |
        Thanks for reporting a bug! Please fill in as much detail as possible.

  - type: input
    id: summary
    attributes:
      label: Summary
      description: A clear, one-sentence description of the bug
      placeholder: "Example: The Export to CSV button does nothing when clicked"
    validations:
      required: true

  # TODO: Add "Steps to Reproduce" section using Copilot
  # Prompt: "Add a textarea field to this YAML issue template for steps to reproduce the bug.
  # Label it 'Steps to Reproduce', make it required, and add a placeholder showing numbered steps."

  # TODO: Add "Expected Behavior" field
  # TODO: Add "Actual Behavior" field
  # TODO: Add "Severity" dropdown (low, medium, high, critical)
  # TODO: Add "Environment" checkboxes (Web, iOS, Android, API)

  - type: checkboxes
    id: terms
    attributes:
      label: Checklist
      options:
        - label: I have checked that this bug has not been reported before
          required: true
        - label: I can reproduce this issue consistently
          required: false

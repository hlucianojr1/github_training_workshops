# MeetingMind — Product Requirements Document

**Version:** 1.0 | **Status:** Draft for review | **Author:** Jordan Rivera, PM

---

## Problem Statement

Remote-first teams hold an average of 12 meetings per week. Fewer than 40% of those meetings result in documented action items. As a result, decisions are forgotten, work gets duplicated, and accountability is unclear. MeetingMind automates meeting documentation so teams spend less time writing notes and more time doing the work.

## Target Users

- **Primary:** Remote and hybrid team leads (5–50 person teams)
- **Secondary:** Executive assistants, project managers, operations leads
- **Buyer:** Director of Operations, Chief of Staff, VP of Engineering

## Target Audience Personas

- **Taylor, Team Lead:** Runs 8+ meetings per week. Has no time to write notes. Sends action items via Slack and forgets to follow up.
- **Morgan, EA:** Manages notes for 3 executives. Spends 2 hours per day writing and distributing meeting summaries.
- **Casey, PM:** Needs meeting outcomes tracked in Jira tickets. Currently copies action items manually.

## Core Features

### 1. Auto-Transcription
- Real-time transcription of meetings in Zoom, Google Meet, and Microsoft Teams
- Speaker identification (who said what)
- Supports English; Spanish and French planned for Q3
- 95%+ accuracy target for clear audio

### 2. Action Item Detection
- AI identifies action items from transcript ("I'll send that by Friday", "Can you follow up on X")
- Each action item: owner, description, due date (if mentioned)
- Manual override: edit, add, or delete detected items before distribution
- Confidence score displayed for each detection

### 3. Slack / Email Distribution
- Send meeting summary to a Slack channel or email list immediately after meeting ends
- Configurable template: choose what to include (summary, decisions, action items, full transcript)
- One-click distribution from the MeetingMind dashboard
- Follow-up reminders sent 24 hours before action item due dates

### 4. Searchable Archive
- Full-text search across all meeting transcripts and summaries
- Filter by date, attendee, project, or keyword
- Retention: 12 months on Growth plan, unlimited on Enterprise
- Export individual meetings as PDF or Markdown

### 5. Calendar Integration
- Syncs with Google Calendar and Outlook to automatically join scheduled meetings
- Meeting metadata auto-populated (title, attendees, date) from calendar event
- Optional: auto-create calendar event for each action item's due date

## Success Metrics

- Meeting documentation coverage: 80% of meetings have a summary within 5 minutes of ending
- Time saved per user per week: 30 minutes (vs. manual note-taking)
- Action item completion rate: 20% improvement vs. teams without MeetingMind
- 30-day user retention: > 65%
- NPS: > 50

## Out of Scope (v1.0)

- Video recording storage
- Legal/compliance grade transcription
- Real-time translation during meetings
- Direct Jira/Asana integration (planned v1.5)

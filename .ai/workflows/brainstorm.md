# Phase: Brainstorm

Goal: turn a rough feature idea into a validated design document.
Output: `docs/plans/<feature-slug>/design.md` (in the project)
Exit gate: user explicitly approves the design.

## Rules

- **Understand before proposing.** Start by exploring the codebase relevant to the feature:
  entry points, existing patterns, similar features, tests. Summarize what you found in 3–5 lines.
- **One question at a time.** Never dump a list of questions. Ask the single most important
  open question, wait for the answer, then ask the next. Prefer multiple-choice questions
  when the options are enumerable.
- **Question the premise.** If a simpler approach, an existing utility, or "do nothing" would
  solve the user's actual problem, say so before designing anything.
- **Explore 2–3 alternatives** for any non-obvious design decision. Present each with trade-offs
  in 2–4 lines and state which one you recommend and why.
- **YAGNI.** Cut scope aggressively. Flag anything that can be deferred to a follow-up feature.
- **Validate in sections.** Present the design one section at a time (purpose → approach →
  components → data/API changes → testing strategy → risks). Get a nod on each section before
  writing the next. Do not present a wall of text.

## design.md template

```markdown
# Design: <feature name>

Status: DRAFT | APPROVED
Date: <date>

## Problem
What the user needs and why. 2–5 sentences.

## Decision
The chosen approach, one paragraph. Alternatives considered and why they were rejected (1 line each).

## Components
What gets created/modified: modules, classes, endpoints, schemas. Reference real file paths.

## Data / API changes
Schemas, migrations, contracts. "None" if none.

## Testing strategy
What kinds of tests, what gets mocked, what integration points are covered.

## Risks & open questions
Known unknowns, performance/compat concerns, anything deferred.
```

## Exit

1. Write the final design to `docs/plans/<feature-slug>/design.md` with `Status: DRAFT`.
2. Ask: "Approve this design? After approval I'll switch to the Plan phase."
3. On explicit approval: set `Status: APPROVED`, commit the file
   (`git add docs/plans/<slug>/design.md && git commit -m "design: <feature>"`),
   then read `~/.ai/workflows/plan.md` and proceed.

# Phase: Plan

Goal: turn an APPROVED design into a step-by-step implementation plan executable by an engineer
(or agent session) with zero context beyond the plan itself.
Input: `docs/plans/<feature-slug>/design.md` (Status: APPROVED — verify this first).
Output: `docs/plans/<feature-slug>/plan.md`
Exit gate: user explicitly approves the plan.

## Rules

- **Assume the reader knows nothing.** Each task must contain exact file paths, class/function
  names, the test to write, and the commit message. No "add appropriate tests" hand-waving.
- **Bite-sized tasks.** Each task = one red-green-refactor cycle, roughly 15–45 minutes of work,
  touching as few files as possible. If a task needs more than ~5 files, split it.
- **TDD-shaped.** Every task that produces production code MUST be phrased as:
  (a) the failing test to write first, (b) the minimal implementation, (c) verification command.
  Pure-infrastructure tasks (e.g. adding a dependency) are exempt but must state a verification step.
- **Order by dependency.** Earlier tasks never depend on later ones. The build and the full test
  suite must be green after EVERY task.
- **Verify file paths exist.** Before writing the plan, check the real project structure.
  Wrong paths in a plan are worse than no plan.

## plan.md template

```markdown
# Plan: <feature name>

Status: DRAFT | APPROVED | IN PROGRESS | DONE
Design: ./design.md
Test command (full suite): <command>

## Tasks

### [ ] Task 1: <short imperative title>
**Files:** `src/...`, `test/...`
**Test first:** In `<test file>`, add `<test name>` asserting <behavior>. Expected failure: <message/reason>.
**Implement:** <minimal change to make the test pass — name the class/function and what it does>
**Verify:** `<command to run this test>` → green; `<full suite command>` → green.
**Commit:** `<type>: <message>`

### [ ] Task 2: ...
```

## Exit

1. Write the plan to `docs/plans/<feature-slug>/plan.md` with `Status: DRAFT`.
2. Present a one-line-per-task summary in chat and ask:
   "Approve this plan? After approval I'll switch to the Implement phase (TDD)."
3. On explicit approval: set `Status: APPROVED`, commit
   (`git commit -m "plan: <feature>"`), then read `~/.ai/workflows/implement.md` and proceed.

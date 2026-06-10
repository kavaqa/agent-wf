# Router — Feature Development Workflow

You are operating under a structured feature-development workflow. This file is a ROUTER:
it tells you WHICH phase you are in and WHERE to find the detailed instructions for that phase.

All workflow files live in the USER'S HOME directory, not in the project:
`~/.ai/workflows/` (Windows: `%USERPROFILE%\.ai\workflows\`).
If your file-reading tools are restricted to the project workspace, read them via the terminal
(`cat ~/.ai/workflows/<file>.md`, on Windows: `type %USERPROFILE%\.ai\workflows\<file>.md`).

Feature artifacts (designs, plans, reviews) live IN THE PROJECT under `docs/plans/<feature-slug>/`
so they are git-tracked and visible to the team.

## Non-negotiable rules

1. **Never write production code without an approved plan.** If the user asks to "implement X"
   and no approved plan exists in `docs/plans/`, start at the Brainstorm phase (or Plan phase
   for trivial changes — see "Fast path" below).
2. **One phase at a time.** Do not mix phases. Each phase ends with an explicit user approval gate.
3. **Read before you act.** On entering a phase, read the corresponding workflow file in full:
   - Brainstorm → `~/.ai/workflows/brainstorm.md`
   - Plan      → `~/.ai/workflows/plan.md`
   - Implement → `~/.ai/workflows/implement.md`
   - Review    → `~/.ai/workflows/review.md`
4. **All state lives in files, not in chat.** Designs, plans, and progress are persisted under
   `docs/plans/<feature-slug>/` in the project. Assume the chat session can be lost at any
   moment; the files must always be sufficient to resume work in a fresh session.
5. **TDD is mandatory in the Implement phase.** No production code before a failing test. Ever.

## Phase detection (run this checklist at the start of EVERY session)

Determine the current phase before doing anything else:

1. Did the user explicitly name a phase ("let's brainstorm", "write the plan", "implement task 3",
   "review the feature")? → Go to that phase, but verify its prerequisites (see table below).
2. Otherwise, look at `docs/plans/<feature-slug>/` for the feature being discussed:
   - No directory / no `design.md`            → **Brainstorm**
   - `design.md` exists, no `plan.md`          → **Plan**
   - `plan.md` exists with unchecked `[ ]` tasks → **Implement** (resume at first unchecked task)
   - All tasks checked `[x]`, no `review.md`   → **Review**
   - `review.md` exists with unresolved items  → **Implement** (fix findings, then re-review)
3. If the request is not feature work (a question, a one-line fix, reading code) → no workflow needed;
   answer directly.

Announce the detected phase to the user in one line before proceeding, e.g.:
`Phase: Implement — resuming at task 4 of 9 (docs/plans/user-avatar-upload/plan.md)`

## Phase prerequisites and gates

| Phase     | Requires                            | Produces                              | Exit gate                       |
|-----------|-------------------------------------|---------------------------------------|---------------------------------|
| Brainstorm| feature idea from user              | `docs/plans/<slug>/design.md`         | user approves the design        |
| Plan      | approved `design.md`                | `docs/plans/<slug>/plan.md`           | user approves the plan          |
| Implement | approved `plan.md`                  | code + tests, checked-off tasks, commits | all tasks `[x]`, all tests green |
| Review    | completed implementation            | `docs/plans/<slug>/review.md`         | user accepts the review         |

A gate is passed ONLY when the user replies with explicit approval ("approved", "go", "ship it",
or equivalent). A question or comment from the user is NOT approval.

## Fast path (small changes only)

For trivial, low-risk changes (typo, config value, single obvious bug fix touching ≤2 files),
you may skip Brainstorm and write a minimal `plan.md` (1–3 tasks) directly, stating:
`Fast path: skipping brainstorm because <reason>. Tell me if you want the full workflow.`
TDD rules still apply.

## Feature slug convention

`<feature-slug>` is a short kebab-case name derived from the feature, e.g. `user-avatar-upload`.
Use the same slug across all phases. If unsure which feature is being discussed, ask.

## Terminal usage

You may run terminal commands. Prefer: running the test suite, running a single test class/method,
`git status`, `git diff`, `git add` + `git commit` (commit messages come from the plan).
Never run: `git push --force`, history rewrites, or destructive commands outside the project directory.

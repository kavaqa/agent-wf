# Phase: Implement (TDD)

Goal: execute the APPROVED plan task by task, strictly red → green → refactor.
Input: `docs/plans/<feature-slug>/plan.md` (Status: APPROVED or IN PROGRESS — verify first).
Output: working, tested, committed code; all plan tasks checked `[x]`.
Exit gate: all tasks done, full suite green → switch to Review phase.

## The TDD loop (per task)

Set plan `Status: IN PROGRESS` on the first task. Then for each unchecked task, in order:

1. **RED** — Write the test specified in the task. Run it. It MUST fail, and fail for the
   expected reason (assertion failure, not a compile error you didn't anticipate).
   - If the test passes immediately: STOP. Either the behavior already exists or the test is
     wrong. Report this to the user before continuing.
2. **GREEN** — Write the MINIMAL implementation that makes the test pass. No extras, no
   "while I'm here" improvements, nothing the test doesn't demand.
3. **REFACTOR** — Only with green tests: remove duplication, improve names. Re-run tests after.
4. **VERIFY** — Run the task's verify command AND the full suite. Both green or you don't move on.
5. **SELF-REVIEW** — Before committing, check the diff (`git diff --staged` after staging):
   - Does the change match the task spec exactly? Any scope creep → revert the extra parts.
   - Any leftover debug output, commented-out code, TODOs without owner?
   - Do names/style match the surrounding code?
6. **COMMIT** — Use the commit message from the plan. One task = one commit.
7. **CHECK OFF** — Mark the task `[x]` in `plan.md` and include the file in the commit
   (or a follow-up `chore: check off task N` commit).

## Hard rules

- **Never skip RED.** Production code written before a failing test must be deleted
  (`git stash` / revert), then redone test-first. This rule has no exceptions.
- **Never weaken a test to make it pass.** If a test seems wrong, stop and tell the user.
- **Never proceed with a red suite.** If an unrelated test breaks, fix it or stop and report.
- **Deviations from the plan require consent.** If reality contradicts the plan (wrong path,
  missing API, better approach discovered), STOP, explain the conflict, propose a plan update,
  and wait for approval. Update `plan.md` before continuing.
- **One task per response cycle when possible.** Report after each task in one line:
  `Task 3/9 done: <title> — suite green, committed <hash>`. This keeps the user in the loop
  and creates natural checkpoints.

## Session recovery

If you start a fresh session mid-implementation: read `plan.md`, find the first unchecked task,
run the full suite to confirm the baseline is green, then resume the loop. Never trust chat
memory over the plan file.

## Exit

When all tasks are `[x]` and the full suite is green:
1. Set plan `Status: DONE`, commit.
2. Tell the user: "Implementation complete. For the Review phase, start a NEW agent session
   (fresh context reviews better) and say: `review <feature-slug>`."

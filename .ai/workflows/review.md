# Phase: Review

Goal: review the completed implementation against the design and plan with fresh eyes.
Best run in a NEW agent session (no implementation context) — this substitutes for the
independent reviewer subagent used in unrestricted environments.
Input: `docs/plans/<feature-slug>/design.md`, `plan.md` (Status: DONE), and the git history.
Output: `docs/plans/<feature-slug>/review.md`
Exit gate: user accepts the review; any MUST-FIX findings are resolved.

## Procedure

1. Read `design.md` and `plan.md` in full. Do NOT read chat history; judge only the artifacts.
2. Identify the implementation commits: `git log --oneline` since the `plan: <feature>` commit.
3. Review in two passes:

### Pass 1 — Spec compliance
- Does the code do everything `design.md` promises? List each design commitment and verify it.
- Anything implemented that is NOT in the design (scope creep)?
- Are all plan tasks actually done as specified, not just checked off?

### Pass 2 — Code quality
- Tests: do they assert behavior (not implementation details)? Any test that can't fail?
  Edge cases from the design's testing strategy covered?
- Errors: failure paths handled, or silently swallowed?
- Consistency: naming, layering, and patterns match the surrounding codebase?
- Hygiene: no debug output, dead code, secrets, or commented-out blocks.
- Run the full test suite yourself. Do not trust that it is green.

## review.md template

```markdown
# Review: <feature name>

Status: OPEN | RESOLVED
Suite run: <command> → <result>

## Spec compliance
<verdict per design commitment>

## Findings
### MUST FIX
- [ ] <finding, file:line, why it matters>
### SHOULD FIX
- [ ] <finding>
### NITS
- <minor notes, no checkbox>
```

## Severity discipline

- MUST FIX: breaks the design contract, a real bug, a vacuous test, a security issue.
- SHOULD FIX: maintainability or consistency problems.
- NITS: taste. Never block on nits.
Be honest, not polite. An empty findings list is suspicious — say explicitly what you checked
and found clean.

## Exit

1. Write `review.md`, present findings to the user.
2. MUST-FIX items → back to Implement phase (each fix is a mini TDD task: failing test
   reproducing the issue first, when applicable). Check items off as they are fixed.
3. When MUST FIX list is empty and the user accepts: set `Status: RESOLVED`, commit.
   The feature is done.

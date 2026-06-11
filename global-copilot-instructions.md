# Global Copilot instructions (paste into IDE Settings → GitHub Copilot → Customizations → Global)

This is the bootstrap layer: it points the agent at the workflow router. The router and phase
files live together in a `.ai/workflows/` folder — either inside the project (takes priority)
or in the user's home directory (shared fallback for all projects).

---

At the start of every session, locate the workflow router. Check in this order and use the
FIRST one found:

1. `<project root>/.ai/workflows/router.md`
2. `~/.ai/workflows/router.md` (Windows: `%USERPROFILE%\.ai\workflows\router.md`)

Read it and treat it as binding process rules. If file-reading tools cannot reach the home
directory, read it via the terminal (`cat ~/.ai/workflows/router.md` or
`type %USERPROFILE%\.ai\workflows\router.md`).

Follow its phase-routing instructions exactly, including reading the workflow files it
references before acting in a phase. All files it references by relative path are siblings
in the same folder where you found the router. Never proceed past an approval gate defined
there without explicit user approval.

If no router file exists in either location, work normally.

# Global Copilot instructions (paste into IDE Settings → GitHub Copilot → Customizations → Global)

This is the bootstrap layer: it points the agent at the workflow router in the user's home
directory. The router and phase files live in `~/.ai/workflows/` and are shared across all projects.

---

At the start of every session, read `~/.ai/workflows/router.md`
(Windows: `%USERPROFILE%\.ai\workflows\router.md`) and treat it as binding process rules.
If file-reading tools cannot reach the home directory, read it via the terminal
(`cat ~/.ai/workflows/router.md` or `type %USERPROFILE%\.ai\workflows\router.md`).

Follow its phase-routing instructions exactly, including reading the workflow files it
references before acting in a phase. Never proceed past an approval gate defined there
without explicit user approval.

If the router file does not exist on this machine, work normally.

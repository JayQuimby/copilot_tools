# Getting Claude-Code-Level Results from GitHub Copilot

## Why it feels different with the same model
The model is only part of what you're using. The rest is the **harness** around it: the system prompt, which tools it has, how much context it gets, how long it can keep working, and what it's told to do before it stops. Claude Code's harness pushes the model to:

- explore the codebase before editing (search, read whole files)
- keep a visible todo list for multi-step work
- run commands (typecheck, tests) and iterate until they pass
- keep going for many steps without asking permission for each one
- hand off big searches to subagents so its own context stays clean

Copilot's harness is built for a broader audience, and many of its interactions are short (Ask, Edit, inline chat). Its defaults are more conservative, and it may give the model less context or fewer steps before pausing. So the same Claude model often edits sooner, reads less and stops earlier.

**You can close most of that gap with configuration.** That's what this package does.

## What this package does about it
| Claude Code behavior | How we reproduce it in Copilot |
|---|---|
| Explore before editing | `copilot-instructions.md` §1 "Understand before you change anything"; `planner` agent |
| Todo list for multi-step work | Instructions + every prompt file requires a todo list |
| Verify with real commands | `verify-changes` skill; every prompt ends with it; `implementer` agent's loop |
| Don't stop early / no placeholders | "Finish the job" and "Never leave placeholders" rules |
| Specialized modes | Custom agents: `planner`, `implementer`, `reviewer`, `frontend-auditor`, `ui-designer` |
| Plan → build → review workflow | Agent **handoffs** (buttons that pass context to the next agent) |
| Deep domain knowledge on demand | **Skills** load only when relevant, so they don't use context all the time |
| File-type rules | `.instructions.md` files with `applyTo` globs load only for matching files |

## How to use Copilot so it works harder
1. **Use Agent mode**, not Ask or Edit. Only Agent mode can run commands, use tools, follow skills and loop.
2. **Pick a Claude model** in the model picker. Use the strongest one available for audits and planning; a faster one is fine for small edits.
3. **Raise the request limit** (`chat.agent.maxRequests`, see `templates/vscode-settings.jsonc`) so long tasks don't pause every 25 steps.
4. **Start from a prompt file or agent**, not a blank message. `/audit-frontend`, `/new-feature`, `/refactor-react` and the others carry the process with them.
5. **One task per chat.** Start a new chat for unrelated work. Long, mixed conversations dilute context.
6. **Give it anchors**: `#file:path`, `#codebase`, pasted errors, the audit report path. Specific context beats "look around".
7. **Plan first for anything non-trivial**: use the `planner` agent, read the plan, then press "Implement this plan".
8. **Make it prove it**: if it says "done" without a verification table, reply "run verify-changes".
9. **Review with a fresh agent**: switch to `reviewer` after implementation; a second pass catches what the first missed.
10. **Keep always-on instructions lean.** `copilot-instructions.md` is sent on every request. Detail belongs in skills and `applyTo`-scoped files, which is how this package is laid out.

## Where each file type lives and when it loads
| File | Location | Loaded |
|---|---|---|
| Repo instructions | `.github/copilot-instructions.md` | Every request |
| Scoped instructions | `.github/instructions/*.instructions.md` | When files matching `applyTo` are in context |
| Skills | `.github/skills/<name>/SKILL.md` (+ references) | When the task matches the skill `description`, or via `/skill-name` |
| Prompt files | `.github/prompts/*.prompt.md` | When you type `/name` |
| Custom agents | `.github/agents/*.agent.md` | When selected in the agent picker or via a handoff |
| AGENTS.md | repo root / subfolders | Every request, if enabled; also read by Copilot code review |

User-level equivalents (available in every workspace): `~/.copilot/skills/`, `~/.copilot/agents/`, `~/.copilot/instructions/`.

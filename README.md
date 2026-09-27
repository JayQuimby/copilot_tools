# copilot-tools

A set of GitHub Copilot instructions, skills, prompts and custom agents for building **consistent, professional, feature-complete web apps** with Node.js, React and TypeScript/JSX. It is also meant to get Claude-Code-style effort out of Copilot's agent mode.

Everything here uses public knowledge and Copilot's native file formats, so no extra tools or extensions are needed.

## What's inside

```
.github/
├── copilot-instructions.md        Always-on: how to work (explore → plan → build → verify → finish)
├── instructions/                  Auto-applied by file type (applyTo globs)
│   ├── typescript.instructions.md
│   ├── react.instructions.md
│   ├── styling-ui.instructions.md
│   ├── accessibility.instructions.md
│   ├── node-backend.instructions.md
│   ├── testing.instructions.md
│   └── security.instructions.md
├── skills/                        Loaded on demand when the task matches
│   ├── frontend-audit/            ★ Full functional + aesthetic audit (checklist, search patterns, report template)
│   ├── frontend-design/           Professional UI: brief → tokens → layout → review (tokens.css, patterns, anti-patterns)
│   ├── react-patterns/            React 19 patterns + 18 before/after refactor recipes
│   ├── webapp-completeness/       Definition of done for features
│   ├── node-api/                  Backend patterns + review checklist
│   └── verify-changes/            Typecheck → lint → test → build loop with honest reporting
├── prompts/                       Slash commands
│   ├── audit-frontend.prompt.md   /audit-frontend
│   ├── audit-backend.prompt.md    /audit-backend
│   ├── fix-audit-findings.prompt.md
│   ├── new-feature.prompt.md
│   ├── new-component.prompt.md
│   ├── design-polish.prompt.md
│   ├── refactor-react.prompt.md
│   └── review-changes.prompt.md
└── agents/                        Custom agents with handoff buttons
    ├── planner.agent.md           → Implement this plan
    ├── implementer.agent.md       → Review these changes
    ├── reviewer.agent.md          → Fix the Must-fix items
    ├── frontend-auditor.agent.md  → Fix Critical & High / Polish visuals
    └── ui-designer.agent.md       → Review the result
docs/
├── PRINCIPLES.md                  The 10 guiding principles + default stack
├── copilot-vs-claude-code.md      Why Copilot feels weaker and how this package compensates
└── sources.md                     Where the guidance comes from
templates/
├── tsconfig.strict.json
├── eslint.config.js               Flat config: typescript-eslint strict, react, react-hooks, jsx-a11y
└── vscode-settings.jsonc          Settings that let agent mode do more
scripts/
├── install.sh                     macOS / Linux
└── install.ps1                    Windows
```

## Install

**Per project (recommended).** Commit this into each app repo so teammates and Copilot code review get it too:

```bash
./scripts/install.sh ~/code/my-app          # macOS/Linux
.\scripts\install.ps1 -Project C:\code\my-app   # Windows
```

**For yourself, in every workspace.** This copies skills, agents and instructions into `~/.copilot/`:

```bash
./scripts/install.sh --user
.\scripts\install.ps1 -User
```

Neither script overwrites existing files unless you pass `--force` / `-Force`. If a project already has a `copilot-instructions.md`, the package version is saved alongside it for you to merge.

No scripts allowed? Copy the `.github/` folder into your project by hand. That's all the scripts do.

Then apply the settings from [templates/vscode-settings.jsonc](templates/vscode-settings.jsonc). The most important one is raising `chat.agent.maxRequests`.

## Use

In Copilot Chat, switch to **Agent** mode and pick a Claude model. Then:

| I want to… | Do this |
|---|---|
| Audit an existing frontend | `/audit-frontend` (or select the **frontend-auditor** agent) |
| Fix what the audit found | Click the handoff button, or `/fix-audit-findings docs/audits/<report>.md` |
| Audit an API | `/audit-backend` |
| Build a feature properly | **planner** agent → review plan → "Implement this plan" |
| Quick full-stack feature | `/new-feature` |
| Add a reusable component | `/new-component` |
| Make a screen look professional | `/design-polish` or the **ui-designer** agent |
| Clean up bad React code | `/refactor-react` |
| Review before committing | `/review-changes` or the **reviewer** agent |

Skills also load automatically when your request matches their description. Asking "is this feature complete?" pulls in `webapp-completeness`, for example.

## The audit workflow
1. `/audit-frontend`: Copilot maps the app, runs typecheck/lint/tests/build, sweeps ~65 search patterns, reviews 16 categories (123 checks with IDs), scores each 0–5, and writes `docs/audits/frontend-audit-<date>.md`.
2. Read the top-10 list. Every finding has `file:line`, evidence, impact and a fix.
3. `/fix-audit-findings` works through Critical/High findings, verifies each fix, and marks them fixed in the report.
4. Re-run the audit later. Category scores show whether things are improving.

## Customizing
- **Your own conventions win.** Edit the instruction files to match your team's choices (styling approach, data library, folder layout). Keep `copilot-instructions.md` short, because it's sent with every request. Put detail in skills.
- **Brand:** replace the primitive colors in [tokens.css](.github/skills/frontend-design/references/tokens.css).
- **Add a skill:** create `.github/skills/<name>/SKILL.md`. Its `name` must match the folder, and its `description` should say *what* it does and *when* to use it (≤ 1024 chars).

See [docs/copilot-vs-claude-code.md](docs/copilot-vs-claude-code.md) for how to get the most out of Copilot's agent mode.

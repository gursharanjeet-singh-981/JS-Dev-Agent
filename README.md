# React-Dev-Agent

Plug-and-play GitHub Copilot agents for **React, Next.js, Vue, and Node.js** projects in **VS Code**: development, debugging, test generation, code review, and planning.

Everything runs inside VS Code Copilot Chat. There is nothing to build or run outside the editor, and you choose the AI model with the VS Code model picker.

## Requirements

- VS Code with the GitHub Copilot and Copilot Chat extensions, signed in
- A JavaScript/TypeScript project (React, Next.js, Vue, or Node.js)

## Install

Run `install.sh` from this repo's folder. It copies the agents, slash commands, and framework guides into your project's `.github/` folder, or into your VS Code profile.

```bash
./install.sh /path/to/your-project          # install into one project (share it with your team via git)
./install.sh --user                         # install for every workspace via your VS Code profile
./install.sh --force /path/to/your-project  # overwrite files that already exist
```

- Without `--force`, existing files are skipped.
- Running `./install.sh` with no arguments prints the usage and exits with an error.
- To try it without installing, open this repo in VS Code.

Then **reload VS Code**.

## Use

1. Open Copilot Chat (`Ctrl+Cmd+I` on macOS, `Ctrl+Alt+I` on Windows/Linux).
2. Pick an agent from the agent dropdown in the chat box.
3. Pick a model in the model picker, if you want a different one.
4. Describe your task, or type a slash command.

### Agents

| Agent | Use it to |
|---|---|
| **JS Dev** | Start here. It detects your framework, builds features, and hands off to the others |
| **JS Debugger** | Find the root cause of an error or stack trace and fix it |
| **JS Test Engineer** | Write and run tests (Jest, Vitest, Testing Library, Vue Test Utils, Supertest, Playwright) |
| **JS Reviewer** | Review code, audit security and performance, or choose libraries. It is read-only and never edits files |
| **FE Architect** | Turn a Jira ticket and Figma designs into an implementation plan. NAVCO-specific, see below |

### Slash commands

| Command | Example |
|---|---|
| `/js-build` | `/js-build` then "A paginated users table with search" |
| `/js-debug` | `/js-debug` then paste the error or stack trace |
| `/js-test` | `/js-test` with the file open, to test the current file |
| `/js-review` | `/js-review` with the file open, to review the current file |

### Example prompts for JS Dev

```text
Add a dark-mode toggle to the header and persist it in localStorage.
Why do I get a hydration mismatch on /products? (paste the console error)
Write unit tests for src/utils/formatPrice.ts and run them.
Review src/app/api/orders/route.ts for security issues.
Which scroller library should I use for a horizontal carousel in Next.js?
```

### Handoffs

After a reply, use the buttons **Debug This**, **Write Tests**, and **Review Changes** to pass the work to another agent with the context kept.

### What to expect

The agent reads your `package.json` and config files first to learn your framework, TypeScript setup, test runner, and package manager. It then edits files and runs your type-check, lint, and tests. Edits and terminal commands follow your normal VS Code approval prompts. Review the diff before you commit.

## What is included

```
.github/
├── agents/
│   ├── js-dev.agent.md            # Main agent: detects stack, builds features, delegates
│   ├── js-debugger.agent.md       # Root-cause debugging + fix
│   ├── js-test-engineer.agent.md  # Unit / component / API / e2e tests
│   ├── js-reviewer.agent.md       # Read-only review & recommendations
│   └── fe-architect.agent.md      # Jira + Figma -> tech plan in .github/plans/
├── skills/                        # react-dev, nextjs-dev, vue-dev, node-dev (loaded on demand)
└── prompts/                       # /js-build, /js-debug, /js-test, /js-review
install.sh
```

## FE Architect (NAVCO)

This agent plans features for the NAVCO AEM + React islands project. It reads a Jira ticket and Figma designs, checks Confluence and the codebase, and saves a plan to `.github/plans/NAVCO-<ticket>-implementation.md`. It never writes application code.

It needs two MCP servers whose names match its `tools:` list in [fe-architect.agent.md](.github/agents/fe-architect.agent.md):

- `mcp-atlassian` for Jira and Confluence
- `figma-mcp` for Figma

Add servers under those names in `.vscode/mcp.json` or your user `mcp.json`, or edit the `tools:` list to match the names you use. Because it is project-specific, delete this agent before installing the kit into unrelated projects.

## Customize

- Add your team's conventions to the relevant `.github/skills/*/SKILL.md`.
- Each agent's frontmatter controls its `tools:` and optionally its `model:`.
- Each slash command is a file in `.github/prompts/`.

## Troubleshooting

| Symptom | Fix |
|---|---|
| Agents or slash commands don't appear | Reload VS Code, and confirm the files are in `.github/agents` and `.github/prompts` of the open workspace (or installed with `--user`) |
| `install.sh` exits with an error and prints usage | Pass a target folder or `--user` |
| Files were skipped during install | They already exist. Re-run with `--force` to overwrite |
| FE Architect can't read Jira, Confluence, or Figma | Your MCP server names don't match its `tools:` list. See [FE Architect (NAVCO)](#fe-architect-navco) |
| The agent picks the wrong test runner or package manager | Say which one to use in your prompt, or add it to the matching `SKILL.md` |

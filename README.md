# ultra

`/ultra` runs isolated worker, critic and verifier subagents on Google Antigravity.

## Install

From a clone of this repo:

```bash
git clone https://github.com/cekYc/GeminiUltra.git && cd GeminiUltra
bash install.sh                        # global: ~/.gemini/config/
bash install.sh --project ~/code/app   # one project: ~/code/app/.agents/
```

```powershell
.\install.ps1                          # global: ~\.gemini\config\
.\install.ps1 -Project C:\code\app     # one project: C:\code\app\.agents\
```

Manual copy, no script. For one project, use `<project>/.agents/` instead of
`~/.gemini/config/`:

```bash
mkdir -p ~/.gemini/config/skills ~/.gemini/config/agents
cp -R .agents/skills/ultra ~/.gemini/config/skills/
cp -R .agents/agents/ultra-worker .agents/agents/ultra-critic .agents/agents/ultra-verifier ~/.gemini/config/agents/
```

```powershell
New-Item -ItemType Directory -Force ~\.gemini\config\skills, ~\.gemini\config\agents | Out-Null
Copy-Item -Recurse .agents\skills\ultra ~\.gemini\config\skills\
Copy-Item -Recurse .agents\agents\ultra-* ~\.gemini\config\agents\
```

Piped one-liners download the repo and do the same copy. Read the script first:

```bash
curl -fsSL https://raw.githubusercontent.com/cekYc/GeminiUltra/main/install.sh | bash
```

```powershell
irm https://raw.githubusercontent.com/cekYc/GeminiUltra/main/install.ps1 | iex
```

The installers also delete `skills/gemini-ultra`, the previous release of this
repo, because it claims `/ultra` too. To uninstall: `bash uninstall.sh
[--project DIR]` or `.\uninstall.ps1 [-Project DIR]`.

## Run

```text
/ultra <task>
```

The main agent writes a short plan (parts with files, acceptance and a verify
command), then calls `invoke_subagent` for:

1. `ultra-worker`, one per part, in parallel when their files don't overlap
2. `ultra-critic`, a read-only review: races, auth, missing tests, unsafe crypto
3. `ultra-verifier`, which only runs the verify commands and reports exit
   codes and output

A failed verify goes back to a worker with the log, up to 3 verifier runs. The
run ends with an Ultra Brief: subagent IDs, files changed, verify command and
exit code, critic findings.

To check that subagents really ran, open `/agents` (CLI) or the Subagents pane
(Antigravity app) during the run. If you only see one chat, the skill failed.

## When not to use

- Typos, one-line changes, "explain this code", questions. `/ultra` refuses
  these; use a normal prompt with high effort.
- Changes nothing can check. Without a test, build, typecheck or lint command
  the verifier has nothing to run.
- When quota or time matters more than a second look: a run costs at least
  three subagents plus the main agent.

## Honest limits

- Same model family. Subagents inherit your current model. This is
  orchestration, not a new or bigger model.
- Isolation comes from `invoke_subagent`: each subagent starts with no parent
  chat history, only the prompt it is given. The critic shares the worker's
  model, so it catches different mistakes, not all of them.
- The agent files use the format Antigravity's own `define_subagent` writes
  (`agents/<name>/agent.md`). Antigravity's public docs don't list an agents
  folder. If a subagent type isn't found, the skill defines it from these
  files with `define_subagent`. In that case the verifier also gets edit tools
  and is only told not to use them.

## Files

```
.agents/skills/ultra/SKILL.md             orchestrator instructions
.agents/agents/ultra-worker/agent.md      implements one plan part
.agents/agents/ultra-critic/agent.md      read-only review
.agents/agents/ultra-verifier/agent.md    runs the verify commands, nothing else
```

MIT licensed.

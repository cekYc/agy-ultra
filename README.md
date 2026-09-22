<div align="center">

# 🚀 AgyUltra

### High-Effort Multi-Agent Swarm Mode for Google Antigravity

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Google Antigravity](https://img.shields.io/badge/Platform-Google_Antigravity-blue.svg)](https://antigravity.google)
[![Model](https://img.shields.io/badge/Model-Gemini_3.8_Flash_(High)-8E24AA.svg)](https://deepmind.google)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://github.com/cekYc/GeminiUltra/pulls)

<p align="center">
  <b>Tired of single-model blind spots?</b><br>
  GeminiUltra orchestrates an autonomous team of specialized AI agents working together in a phased consensus, adversarial review, and self-healing loop.
</p>

</div>

---

## ⚡ 1-Minute Quick Install

Install GeminiUltra globally on your machine with a single terminal command:

### 🪟 Windows (PowerShell)
```powershell
irm https://raw.githubusercontent.com/cekYc/GeminiUltra/main/install.ps1 | iex
```

### 🍎 macOS & 🐧 Linux (Bash)
```bash
curl -fsSL https://raw.githubusercontent.com/cekYc/GeminiUltra/main/install.sh | bash
```

> **Done!** The skill is now active globally across all your projects in Google Antigravity.

---

## 💡 How to Use

Once installed, open **Google Antigravity** (IDE or `agy` CLI) in any project and invoke the swarm:

```text
/ultra <your task, feature request, or refactoring problem>
```

### Examples:
```text
/ultra Implement an end-to-end OAuth2 PKCE login flow with unit tests
```
```text
/ultra Refactor the payment webhook handler to be idempotent and handle network dropouts
```

---

## 🧠 Why Gemini 3.8 Flash (High)?

Claude Code and OpenAI Codex introduced "Ultra" modes by chaining heavy reasoning steps. GeminiUltra optimizes this for Google's latest **Gemini 3.8 Flash (High)**:

* ⚡ **Blazing Execution Speed**: Subagents debate and generate code in parallel in seconds instead of minutes.
* 🧩 **Reasoning Tokens**: Deep thinking effort unlocks architectural foresight, catching edge cases and security vulnerabilities early.
* 📚 **1M+ Context Window**: Feed entire codebases, database schemas, and stack traces without chunking or context loss.
* 💎 **Ultra-Efficient**: Run 4 specialized agents simultaneously with zero quota anxiety.

---

## 🤖 The Swarm Architecture

GeminiUltra divides every task among 4 specialized subagents:

```
                            [ User Request / /ultra ]
                                         │
                                         ▼
                 ┌───────────────────────────────────────────────┐
                 │          GeminiUltra Orchestrator             │
                 │      (Swarm Coordination & Consensus)         │
                 └───────────────────────┬───────────────────────┘
                                         │
                    ┌────────────────────┴────────────────────┐
                    ▼                                         ▼
         ┌─────────────────────┐                   ┌─────────────────────┐
         │   ultra_architect   │ ◄── [Adversarial]─►│   ultra_critic_qa   │
         │ (Architecture & RFC)│      Review       │ (Edge-Case & Security│
         │ Model: Flash (High) │                   │  Specialist)        │
         └──────────┬──────────┘                   └─────────────────────┘
                    │ (Consensus-Approved Specification)
                    ▼
         ┌─────────────────────┐
         │     ultra_coder     │
         │ (Precision Coding)  │
         │ Model: Flash (High) │
         └──────────┬──────────┘
                    │ (Modified Codebase)
                    ▼
         ┌─────────────────────┐
         │   ultra_verifier    │
         │ (Test Suite & Lint) │ ───► [Self-Correction Loop to Coder if failed]
         │ Model: Flash (High) │
         └──────────┬──────────┘
                    │ (100% Green Sign-Off)
                    ▼
         ┌─────────────────────┐
         │    Ultra Briefing   │
         │  (Final Summary)    │
         └─────────────────────┘
```

| Agent | Role | Responsibility |
| :--- | :--- | :--- |
| 📐 **`ultra_architect`** | Chief Solution Architect | Maps repo dependencies, designs clean abstractions, and drafts Architecture RFCs. |
| 🛡️ **`ultra_critic_qa`** | Adversarial Reviewer | Red-teams proposals for race conditions, security flaws, edge cases, and breaking changes. |
| 💻 **`ultra_coder`** | Lead Implementation Engineer | Writes clean, idiomatic code and applies surgical file edits without modifying unaffected lines. |
| 🧪 **`ultra_verifier`** | Verification & Self-Correction | Runs builds, tests, and linters in terminal. Isolates stack traces and triggers self-healing if tests fail. |

---

## 🛠️ Alternative: Manual / Per-Project Installation

If you prefer installing GeminiUltra only in a specific project rather than globally:

1. Clone or copy the `.agents/skills/gemini-ultra` folder into your project's root:
   ```bash
   git clone https://github.com/cekYc/GeminiUltra.git
   cp -r GeminiUltra/.agents/skills/gemini-ultra /path/to/your/project/.agents/skills/
   ```
2. Antigravity will automatically detect the skill within that project!

---

## 🗑️ Uninstallation

If you ever wish to remove GeminiUltra:

**Windows (PowerShell):**
```powershell
irm https://raw.githubusercontent.com/cekYc/GeminiUltra/main/uninstall.ps1 | iex
```

**macOS / Linux (Bash):**
```bash
curl -fsSL https://raw.githubusercontent.com/cekYc/GeminiUltra/main/uninstall.sh | bash
```

---

## 🤝 Contributing

Contributions, feedback, and pull requests are warmly welcomed!
- Feel free to report issues or suggest agent enhancements in [GitHub Issues](https://github.com/cekYc/GeminiUltra/issues).
- Want to add new agent archetypes or fine-tune prompts? Open a Pull Request!

---

## 📄 License

Distributed under the [MIT License](LICENSE). Built for the AI developer community.

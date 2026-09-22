# GeminiUltra Repository & Agent Guidelines

Welcome to the **GeminiUltra** project workspace.

This repository hosts the **GeminiUltra** multi-agent high-effort engineering swarm, designed for Google Antigravity and powered by **Gemini 3.8 Flash (High Reasoning)**.

---

## 1. Operating Rules for Antigravity

- **Swarm Activation**: Whenever the user invokes `/ultra`, `/gemini-ultra`, or asks for an "ultra" multi-agent mode, activate the `.agents/skills/gemini-ultra/SKILL.md` skill immediately.
- **Model Standard**: All specialized subagents (`ultra_architect`, `ultra_critic_qa`, `ultra_coder`, `ultra_verifier`) MUST use `Model: flash` to leverage Gemini 3.8 Flash's high-effort reasoning tokens and blazing execution speed.
- **Quality Gates**:
  1. No code change shall be committed without an architectural review.
  2. No proposal shall bypass the `ultra_critic_qa` adversarial check.
  3. Every code change must be validated by `ultra_verifier` in the terminal.
- **Code Style**:
  - Python: PEP 8, strict type hints, clean docstrings.
  - TypeScript/JavaScript: Modern ESNext, strict TypeScript typing, clean modular structure.
  - Zero unnecessary boilerplate; prefer clean standard library solutions where possible.

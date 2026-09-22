---
name: gemini-ultra
description: >-
  Activates GeminiUltra mode - a high-effort multi-agent engineering swarm
  leveraging Gemini 3.8 Flash (High reasoning) models in parallel specialized
  roles (Architect, Critic/QA, Coder, Verifier) for complex coding,
  architectural design, and self-healing implementations. Use when the user types
  /ultra, /gemini-ultra, asks for Ultra mode, or requests multi-agent deep
  reasoning.
---

# GeminiUltra: Multi-Agent High-Effort Engineering Swarm

GeminiUltra coordinates a team of specialized **Gemini 3.8 Flash (High Reasoning)** agents to achieve state-of-the-art software engineering output. By combining rapid inference, deep thinking tokens, and adversarial self-correction, GeminiUltra delivers robust, clean, and thoroughly verified code.

For complete role definitions and communication schemas, refer to:
- [Subagent Specifications](./references/agents_spec.md)
- [Workflow & Consensus Protocols](./references/workflow_protocols.md)

---

## Operational Runbook

When the user activates `/ultra` or requests GeminiUltra mode, follow this 5-phase protocol strictly:

### Phase 1: Swarm Initialization (Define Subagents)

Ensure the four specialized subagents are registered. If they have not been defined in the current conversation, call `define_subagent` for each:

1. **`ultra_architect`**:
   - `name`: `ultra_architect`
   - `description`: "System architect specialized in codebase mapping, RFC design, and dependency analysis."
   - `enable_write_tools`: `false`
   - `enable_subagent_tools`: `false`
   - `enable_mcp_tools`: `false`
   - `system_prompt`: (See [ultra_architect system prompt](./references/agents_spec.md#1-ultra_architect-system--solution-architect))

2. **`ultra_critic_qa`**:
   - `name`: `ultra_critic_qa`
   - `description`: "Constructive adversary auditing designs and code for security, edge cases, and regressions."
   - `enable_write_tools`: `false`
   - `enable_subagent_tools`: `false`
   - `enable_mcp_tools`: `false`
   - `system_prompt`: (See [ultra_critic_qa system prompt](./references/agents_spec.md#2-ultra_critic_qa-adversarial-reviewer--security-specialist))

3. **`ultra_coder`**:
   - `name`: `ultra_coder`
   - `description`: "Precision software engineer generating idiomatic, clean code and applying surgical modifications."
   - `enable_write_tools`: `true`
   - `enable_subagent_tools`: `false`
   - `enable_mcp_tools`: `false`
   - `system_prompt`: (See [ultra_coder system prompt](./references/agents_spec.md#3-ultra_coder-precision-software-engineer))

4. **`ultra_verifier`**:
   - `name`: `ultra_verifier`
   - `description`: "Quality assurance and testing specialist running builds, linters, and isolating test failures."
   - `enable_write_tools`: `true` (for running commands)
   - `enable_subagent_tools`: `false`
   - `enable_mcp_tools`: `false`
   - `system_prompt`: (See [ultra_verifier system prompt](./references/agents_spec.md#4-ultra_verifier-test-runner--self-correction-specialist))

---

### Phase 2: Architectural Exploration

1. Invoke `ultra_architect` using `invoke_subagent`:
   - `TypeName`: `ultra_architect`
   - `Role`: "Chief Solution Architect"
   - `Model`: `flash`
   - `Prompt`: Instruct the architect to explore the workspace, review relevant files, and produce an **Architecture RFC** following the [RFC Template](./references/workflow_protocols.md#architecture-rfc-template).
2. Wait for the architect's message.

---

### Phase 3: Adversarial Review & Consensus

1. Invoke `ultra_critic_qa` using `invoke_subagent`:
   - `TypeName`: `ultra_critic_qa`
   - `Role`: "Adversarial Code Reviewer & Security QA"
   - `Model`: `flash`
   - `Prompt`: Provide the architect's RFC. Instruct the critic to red-team the proposal for edge cases, security vulnerabilities, and potential regressions.
2. If the critic requests revisions (`REVISE_REQUIRED`), forward the critical points back to the architect for an immediate update.
3. Once `APPROVED`, synthesize the final consensus specification.

---

### Phase 4: Precision Implementation

1. Invoke `ultra_coder` using `invoke_subagent`:
   - `TypeName`: `ultra_coder`
   - `Role`: "Lead Implementation Engineer"
   - `Model`: `flash`
   - `Prompt`: Provide the consensus specification, list of target files, and coding standards. Instruct the coder to make the required modifications using `write_to_file` and `replace_file_content`.
2. Wait for the coder to confirm completion of changes.

---

### Phase 5: Verification & Self-Correction

1. Invoke `ultra_verifier` using `invoke_subagent`:
   - `TypeName`: `ultra_verifier`
   - `Role`: "Verification & Self-Correction Specialist"
   - `Model`: `flash`
   - `Prompt`: Instruct the verifier to execute the build, linters, and test suites via `run_command`.
2. **Self-Correction Loop**:
   - If any test or command fails:
     - The verifier produces a **Self-Correction Bug Report** (see [Bug Report Template](./references/workflow_protocols.md#self-correction-bug-report-template)).
     - Send the report to `ultra_coder` via `send_message` to apply fixes.
     - Have `ultra_verifier` re-run the tests until 100% green.

---

### Phase 6: Ultra Briefing

Deliver the final **Ultra Briefing** to the user in clean GitHub-flavored markdown:
- **Executive Summary**: Core accomplishments.
- **Swarm Consensus Notes**: Crucial edge cases caught and resolved.
- **Files Modified / Created**: Links to each touched file.
- **Verification Evidence**: Commands run and passing status.

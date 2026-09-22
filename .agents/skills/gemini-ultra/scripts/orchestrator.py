"""
GeminiUltra Swarm Orchestrator & Utility Engine
-----------------------------------------------
Core orchestration logic, state machine, and communication contracts for
the GeminiUltra multi-agent engineering swarm.

Can be run standalone to inspect swarm profiles or simulate pipeline execution:
    python orchestrator.py --status
    python orchestrator.py --simulate "Implement a caching layer for user profiles"
"""

import sys
import json
import time
import argparse
from typing import Dict, List, Optional, Any
from dataclasses import dataclass, field, asdict
from enum import Enum

# Ensure UTF-8 output encoding on Windows terminals
if hasattr(sys.stdout, 'reconfigure'):
    try:
        sys.stdout.reconfigure(encoding='utf-8', errors='replace')
        sys.stderr.reconfigure(encoding='utf-8', errors='replace')
    except Exception:
        pass



class AgentRole(str, Enum):
    ORCHESTRATOR = "orchestrator"
    ARCHITECT = "ultra_architect"
    CRITIC_QA = "ultra_critic_qa"
    CODER = "ultra_coder"
    VERIFIER = "ultra_verifier"


class ReviewStatus(str, Enum):
    APPROVED = "APPROVED"
    REVISE_REQUIRED = "REVISE_REQUIRED"
    BLOCKED = "BLOCKED"


class SwarmPhase(str, Enum):
    IDLE = "IDLE"
    INITIALIZATION = "INITIALIZATION"
    ARCHITECTURE = "ARCHITECTURE"
    ADVERSARIAL_REVIEW = "ADVERSARIAL_REVIEW"
    IMPLEMENTATION = "IMPLEMENTATION"
    VERIFICATION = "VERIFICATION"
    SELF_CORRECTION = "SELF_CORRECTION"
    COMPLETED = "COMPLETED"
    FAILED = "FAILED"


# Terminal ANSI Colors for Ultra Visual Styling
class Colors:
    HEADER = '\033[95m'
    BLUE = '\033[94m'
    CYAN = '\033[96m'
    GREEN = '\033[92m'
    YELLOW = '\033[93m'
    RED = '\033[91m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'
    RESET = '\033[0m'


@dataclass
class SwarmMessage:
    sender: str
    recipient: str
    phase: SwarmPhase
    payload: Dict[str, Any]
    timestamp: float = field(default_factory=time.time)


@dataclass
class SwarmSession:
    session_id: str
    user_goal: str
    current_phase: SwarmPhase = SwarmPhase.IDLE
    history: List[SwarmMessage] = field(default_factory=list)
    files_touched: List[str] = field(default_factory=list)
    critic_verdict: Optional[ReviewStatus] = None
    verification_success: bool = False
    stats: Dict[str, Any] = field(default_factory=lambda: {
        "turns": 0,
        "self_correction_loops": 0,
        "model": "gemini-3.8-flash (high-reasoning)",
    })

    def log_message(self, sender: str, recipient: str, phase: SwarmPhase, payload: Dict[str, Any]):
        msg = SwarmMessage(sender=sender, recipient=recipient, phase=phase, payload=payload)
        self.history.append(msg)
        self.stats["turns"] += 1
        return msg


SWARM_AGENT_DEFINITIONS = {
    AgentRole.ARCHITECT.value: {
        "name": "ultra_architect",
        "title": "Chief Solution Architect",
        "model": "flash",
        "tools": ["read_only", "grep_search", "find_by_name", "view_file", "list_dir"],
        "focus": "Repository mapping, architectural design, dependency analysis, RFC generation.",
    },
    AgentRole.CRITIC_QA.value: {
        "name": "ultra_critic_qa",
        "title": "Adversarial Reviewer & Security QA",
        "model": "flash",
        "tools": ["read_only", "grep_search", "find_by_name", "view_file"],
        "focus": "Security vulnerability analysis, race conditions, edge-case audit, breaking changes.",
    },
    AgentRole.CODER.value: {
        "name": "ultra_coder",
        "title": "Lead Implementation Engineer",
        "model": "flash",
        "tools": ["read_only", "write_to_file", "replace_file_content", "run_command"],
        "focus": "Precision coding, idiomatic refactoring, clean surgical edits.",
    },
    AgentRole.VERIFIER.value: {
        "name": "ultra_verifier",
        "title": "Verification & Self-Correction Specialist",
        "model": "flash",
        "tools": ["run_command", "view_file", "grep_search"],
        "focus": "Automated test execution, static analysis, linter checks, bug report generation.",
    },
}


def print_banner():
    banner = f"""
{Colors.CYAN}{Colors.BOLD}╔═════════════════════════════════════════════════════════════════════╗
║                      GEMINI ULTRA SWARM MODE                        ║
║     Multi-Agent High-Effort Engineering Engine (Gemini 3.8 Flash)   ║
╚═════════════════════════════════════════════════════════════════════╝{Colors.RESET}
"""
    print(banner)


def show_status():
    print_banner()
    print(f"{Colors.BOLD}Registered Swarm Agents & Profiles:{Colors.RESET}\n")
    for agent_id, details in SWARM_AGENT_DEFINITIONS.items():
        print(f"  {Colors.GREEN}● {Colors.BOLD}{details['title']}{Colors.RESET} (`{agent_id}`)")
        print(f"    - Model     : {Colors.YELLOW}{details['model']} (High Reasoning){Colors.RESET}")
        print(f"    - Focus     : {details['focus']}")
        print(f"    - Toolsets  : {', '.join(details['tools'])}\n")
    print(f"{Colors.BLUE}Workflow Pipeline:{Colors.RESET}")
    print("  [1. Architect RFC] -> [2. Critic Adversarial Review] -> [3. Coder Synthesis] -> [4. Verifier & Self-Healing]\n")


def simulate_swarm(goal: str):
    print_banner()
    session = SwarmSession(session_id=f"ultra-{int(time.time())}", user_goal=goal)
    print(f"{Colors.BOLD}Session ID:{Colors.RESET} {session.session_id}")
    print(f"{Colors.BOLD}Target Goal:{Colors.RESET} {goal}\n")

    # Phase 1: Init
    session.current_phase = SwarmPhase.INITIALIZATION
    print(f"{Colors.CYAN}[Phase 1/5: Initialization]{Colors.RESET} Subagents defined and configured.")

    # Phase 2: Architect
    session.current_phase = SwarmPhase.ARCHITECTURE
    print(f"{Colors.BLUE}[Phase 2/5: ultra_architect]{Colors.RESET} Mapping repo & drafting Architecture RFC...")
    arch_payload = {
        "rfc_title": f"RFC: {goal}",
        "impacted_files": ["src/service.py", "tests/test_service.py"],
        "strategy": "Modular separation with strict error handling",
    }
    session.log_message(AgentRole.ARCHITECT.value, AgentRole.ORCHESTRATOR.value, SwarmPhase.ARCHITECTURE, arch_payload)

    # Phase 3: Critic
    session.current_phase = SwarmPhase.ADVERSARIAL_REVIEW
    print(f"{Colors.YELLOW}[Phase 3/5: ultra_critic_qa]{Colors.RESET} Red-teaming proposal for edge cases and security...")
    critic_payload = {
        "status": ReviewStatus.APPROVED.value,
        "edge_cases_flagged": ["Null pointer on empty input", "Resource leak on exception"],
        "resolutions": ["Enforce try-finally block", "Add input validation gate"],
    }
    session.critic_verdict = ReviewStatus.APPROVED
    session.log_message(AgentRole.CRITIC_QA.value, AgentRole.ORCHESTRATOR.value, SwarmPhase.ADVERSARIAL_REVIEW, critic_payload)
    print(f"  └── Verdict: {Colors.GREEN}{Colors.BOLD}APPROVED (Consensus Reached){Colors.RESET}")

    # Phase 4: Coder
    session.current_phase = SwarmPhase.IMPLEMENTATION
    print(f"{Colors.BLUE}[Phase 4/5: ultra_coder]{Colors.RESET} Implementing consensus spec with surgical precision...")
    coder_payload = {
        "modified_files": ["src/service.py"],
        "added_files": ["tests/test_service.py"],
    }
    session.files_touched = coder_payload["modified_files"] + coder_payload["added_files"]
    session.log_message(AgentRole.CODER.value, AgentRole.ORCHESTRATOR.value, SwarmPhase.IMPLEMENTATION, coder_payload)

    # Phase 5: Verifier
    session.current_phase = SwarmPhase.VERIFICATION
    print(f"{Colors.GREEN}[Phase 5/5: ultra_verifier]{Colors.RESET} Running automated test suite and linter...")
    verif_payload = {
        "command": "pytest tests/ -v",
        "exit_code": 0,
        "tests_passed": 12,
        "tests_failed": 0,
    }
    session.verification_success = True
    session.log_message(AgentRole.VERIFIER.value, AgentRole.ORCHESTRATOR.value, SwarmPhase.VERIFICATION, verif_payload)
    print(f"  └── Test Suite: {Colors.GREEN}{Colors.BOLD}PASSED (12/12 Green){Colors.RESET}")

    # Final Briefing
    session.current_phase = SwarmPhase.COMPLETED
    print(f"\n{Colors.GREEN}{Colors.BOLD}✓ GEMINI ULTRA BRIEFING COMPLETE{Colors.RESET}")
    print(f"  - Files Changed: {', '.join(session.files_touched)}")
    print(f"  - Swarm Turns  : {session.stats['turns']}")
    print(f"  - Model Engine : {session.stats['model']}\n")


def main():
    parser = argparse.ArgumentParser(description="GeminiUltra Swarm Orchestrator")
    parser.add_argument("--status", action="store_true", help="Display registered subagent profiles and configuration")
    parser.add_argument("--simulate", type=str, metavar="GOAL", help="Simulate a swarm execution loop for a given task")
    args = parser.parse_args()

    if args.status:
        show_status()
    elif args.simulate:
        simulate_swarm(args.simulate)
    else:
        show_status()


if __name__ == "__main__":
    main()

# agent-skills

Custom AI coding agent skills for automated development workflows. Agent-agnostic — works with [Claude Code](https://docs.anthropic.com/en/docs/claude-code), [Codex](https://github.com/openai/codex), or any agent that supports markdown-based skills.

## Skills

| Skill | Description |
|-------|-------------|
| [pr-review-loop](./pr-review-loop/) | Automated PR review-fix-verify cycle for [superpowers](https://github.com/obra/superpowers) + [pr-review-toolkit](https://github.com/anthropics/claude-code/tree/main/plugins). Chains review, evaluation, implementation, verification, and re-review into a loop that runs until clean. |
| [reviewing-plans](./reviewing-plans/) | Two-stage review gate for the [superpowers](https://github.com/obra/superpowers) design→plan→execution workflow. Reviews designs before planning, then reviews plans against designs before execution. |

## Installation

Symlink skills into your agent's skills directory:

```bash
# Claude Code — single skill
ln -s /path/to/agent-skills/pr-review-loop ~/.claude/skills/pr-review-loop

# Claude Code — all skills
for skill in /path/to/agent-skills/*/; do
  name=$(basename "$skill")
  [ -f "$skill/SKILL.md" ] || continue
  ln -sf "$skill" ~/.claude/skills/"$name"
done

# Codex — all compatible skills
for skill in /path/to/agent-skills/*/; do
  name=$(basename "$skill")
  [ -f "$skill/SKILL.md" ] || continue
  ln -sf "$skill" ~/.agents/skills/"$name"
done
```

> **Note:** Not all skills are compatible with all agents. Check each skill's README for compatibility.

Skills are available immediately in all sessions after symlinking.

## Prerequisites

Skills in this repo may depend on:

- [superpowers](https://github.com/obra/superpowers) — core skills library (TDD, debugging, code review, etc.)
- [pr-review-toolkit](https://github.com/anthropics/claude-code/tree/main/plugins) — specialized PR review agents

Check each skill's SKILL.md and README for specific requirements.

## Adding a New Skill

```bash
mkdir skill-name
# Add SKILL.md (required) and README.md (recommended)
# Update the table in this README
```

## License

MIT

# agent-skills

Custom AI coding agent skills for automated development workflows. Agent-agnostic — works with [Claude Code](https://docs.anthropic.com/en/docs/claude-code), [Codex](https://github.com/openai/codex), or any agent that supports markdown-based skills.

## Skills

| Skill | Description |
|-------|-------------|
| [pr-review-loop](./pr-review-loop/) | Automated PR review-fix-verify cycle. Chains review, evaluation, implementation, verification, and re-review into a loop that runs until clean. |

## Installation

Symlink skills into your agent's skills directory:

```bash
# Claude Code
ln -s /path/to/agent-skills/pr-review-loop ~/.claude/skills/pr-review-loop

# Codex
ln -s /path/to/agent-skills/pr-review-loop ~/.agents/skills/pr-review-loop

# Install all skills for Claude Code
for skill in /path/to/agent-skills/*/; do
  name=$(basename "$skill")
  [ -f "$skill/SKILL.md" ] || continue
  ln -sf "$skill" ~/.claude/skills/"$name"
done

# Install all skills for Codex
for skill in /path/to/agent-skills/*/; do
  name=$(basename "$skill")
  [ -f "$skill/SKILL.md" ] || continue
  ln -sf "$skill" ~/.agents/skills/"$name"
done
```

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

# agent-skills

Custom [Claude Code](https://docs.anthropic.com/en/docs/claude-code) skills for automated development workflows.

## Skills

| Skill | Description |
|-------|-------------|
| [pr-review-loop](./pr-review-loop/) | Automated PR review-fix-verify cycle. Chains review, evaluation, implementation, verification, and re-review into a loop that runs until clean. |

## Installation

Symlink individual skills into your Claude Code personal skills directory:

```bash
# Install a single skill
ln -s /path/to/agent-skills/pr-review-loop ~/.claude/skills/pr-review-loop

# Or install all skills
for skill in /path/to/agent-skills/*/; do
  name=$(basename "$skill")
  [ "$name" = "node_modules" ] && continue
  [ -f "$skill/SKILL.md" ] || continue
  ln -sf "$skill" ~/.claude/skills/"$name"
done
```

Skills are available immediately in all Claude Code sessions after symlinking.

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

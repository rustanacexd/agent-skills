# CLAUDE.md

## What This Is

Personal agent skills repo — reusable workflow skills for Claude Code and Codex. Skills are symlinked into `~/.claude/skills/` and loaded on demand.

## Structure

```
skill-name/
  SKILL.md              # Main skill file (required)
  references/           # Supporting docs if needed
```

Each skill is a self-contained directory with a `SKILL.md` following superpowers:writing-skills conventions.

## Symlinks

Skills are consumed via symlinks from agent skill directories:
- Claude Code: `~/.claude/skills/skill-name` → this repo's `skill-name/`
- Codex: `~/.agents/skills/skill-name` → this repo's `skill-name/`

**Edits to files here are live immediately** — no copy or reinstall needed. Be aware that changes affect all active sessions.

## Editing Skills

**Writing skills IS TDD.** You MUST use `superpowers:writing-skills` for all skill creation and edits — no exceptions, not even "small fixes."

- RED: Run pressure scenario without the skill change, document baseline failure
- GREEN: Write minimal skill content addressing the specific failure
- REFACTOR: Close loopholes, re-test until bulletproof

## Dependencies

Skills here may reference:
- [superpowers](https://github.com/obra/superpowers) — core skills (TDD, debugging, verification, etc.)
- [pr-review-toolkit](https://github.com/anthropics/claude-code/tree/main/plugins) — PR review agents

## Git Rules

- Commit directly to `main`
- One skill change per commit
- Prefix: `fix(skill-name):` or `feat(skill-name):`

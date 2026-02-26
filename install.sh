#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

has_claude() {
  command -v claude >/dev/null 2>&1 || command -v claude-code >/dev/null 2>&1
}

link_all_skills() {
  local target_dir="$1"
  mkdir -p "$target_dir"

  local skill
  for skill in "$ROOT_DIR"/*/; do
    [ -d "$skill" ] || continue
    local skill_dir="${skill%/}"
    [ -f "$skill_dir/SKILL.md" ] || continue
    ln -sfn "$skill_dir" "$target_dir/$(basename "$skill_dir")"
  done
}

if has_claude; then
  link_all_skills "$HOME/.claude/skills"
  echo "Installed skills for Claude Code -> $HOME/.claude/skills"
else
  echo "Skipping Claude Code (binary not found: claude/claude-code)"
fi

if command -v codex >/dev/null 2>&1; then
  link_all_skills "$HOME/.agents/skills"
  echo "Installed skills for Codex -> $HOME/.agents/skills"
else
  echo "Skipping Codex (binary not found: codex)"
fi

echo "Done."

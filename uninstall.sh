#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

has_claude() {
  command -v claude >/dev/null 2>&1 || command -v claude-code >/dev/null 2>&1
}

unlink_all_skills() {
  local target_dir="$1"
  [ -d "$target_dir" ] || return 0

  local skill
  for skill in "$ROOT_DIR"/*/; do
    [ -d "$skill" ] || continue
    local skill_dir="${skill%/}"
    [ -f "$skill_dir/SKILL.md" ] || continue

    local name
    name="$(basename "$skill_dir")"
    local link_path="$target_dir/$name"

    if [ -L "$link_path" ] && [ "$(readlink "$link_path")" = "$skill_dir" ]; then
      rm -f "$link_path"
      echo "Removed $link_path"
    fi
  done
}

if has_claude; then
  unlink_all_skills "$HOME/.claude/skills"
else
  echo "Skipping Claude Code (binary not found: claude/claude-code)"
fi

if command -v codex >/dev/null 2>&1; then
  unlink_all_skills "$HOME/.agents/skills"
else
  echo "Skipping Codex (binary not found: codex)"
fi

echo "Done."

#!/usr/bin/env bash
set -euo pipefail

target="${1:-both}"
skill_name="authorized-apk-ad-cleanup"
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source_dir="$script_dir/$skill_name"

if [[ ! -d "$source_dir" ]]; then
  echo "Skill folder not found: $source_dir" >&2
  exit 1
fi

install_skill() {
  local root="$1"
  local skills_dir="$root/skills"
  mkdir -p "$skills_dir"
  rm -rf "$skills_dir/$skill_name"
  cp -R "$source_dir" "$skills_dir/"
  echo "Installed $skill_name to $skills_dir"
}

case "$target" in
  codex)
    install_skill "$HOME/.codex"
    ;;
  claude)
    install_skill "$HOME/.claude"
    ;;
  both)
    install_skill "$HOME/.codex"
    install_skill "$HOME/.claude"
    ;;
  *)
    echo "Usage: ./install.sh [codex|claude|both]" >&2
    exit 1
    ;;
esac

echo 'Done. Start a new Claude or Codex session, then invoke: Use $authorized-apk-ad-cleanup ...'

#!/usr/bin/env bash
# Install the Copilot package into a project, or into your user profile.
#
#   scripts/install.sh <path-to-project>   # copy into <project>/.github
#   scripts/install.sh --user              # copy skills/agents/instructions into ~/.copilot
#   add --force to overwrite files that already exist
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$REPO_ROOT/.github"
FORCE=0
MODE=""
TARGET=""

for arg in "$@"; do
  case "$arg" in
    --force) FORCE=1 ;;
    --user) MODE="user" ;;
    -h|--help) sed -n '2,7p' "$0"; exit 0 ;;
    *) MODE="${MODE:-project}"; TARGET="$arg" ;;
  esac
done

if [[ -z "$MODE" ]]; then
  echo "Usage: $0 <path-to-project> | --user  [--force]" >&2
  exit 1
fi

copied=0; skipped=0
copy_file() { # src dest
  local src="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [[ -e "$dest" && $FORCE -eq 0 ]]; then
    echo "  skip (exists): $dest"; skipped=$((skipped + 1))
  else
    cp "$src" "$dest"; copied=$((copied + 1))
  fi
}
copy_tree() { # src_dir dest_dir
  local src_dir="$1" dest_dir="$2"
  while IFS= read -r -d '' f; do
    copy_file "$f" "$dest_dir/${f#"$src_dir"/}"
  done < <(find "$src_dir" -type f -print0)
}

if [[ "$MODE" == "project" ]]; then
  [[ -d "$TARGET" ]] || { echo "Not a directory: $TARGET" >&2; exit 1; }
  DEST="$(cd "$TARGET" && pwd)/.github"
  echo "Installing into $DEST"
  if [[ -e "$DEST/copilot-instructions.md" && $FORCE -eq 0 ]]; then
    copy_file "$SRC/copilot-instructions.md" "$DEST/copilot-instructions.package.md"
    echo "  NOTE: project already has copilot-instructions.md — package version saved as"
    echo "        copilot-instructions.package.md. Merge the two by hand."
  else
    copy_file "$SRC/copilot-instructions.md" "$DEST/copilot-instructions.md"
  fi
  for d in instructions prompts agents skills; do copy_tree "$SRC/$d" "$DEST/$d"; done
else
  DEST="$HOME/.copilot"
  echo "Installing into $DEST (available in every workspace)"
  copy_tree "$SRC/skills" "$DEST/skills"
  copy_tree "$SRC/agents" "$DEST/agents"
  copy_tree "$SRC/instructions" "$DEST/instructions"
  # The always-on operating instructions become a user-level instructions file.
  tmp="$(mktemp)"
  { printf -- '---\nname: Operating principles\ndescription: How to work — explore, plan, verify, finish.\napplyTo: "**"\n---\n\n'; cat "$SRC/copilot-instructions.md"; } > "$tmp"
  copy_file "$tmp" "$DEST/instructions/operating-principles.instructions.md"
  rm -f "$tmp"
  echo "  NOTE: prompt files (/audit-frontend etc.) are per-project. To use them everywhere,"
  echo "        run 'Chat: New Prompt File' → User and paste them in, or install per project."
fi

echo "Done: $copied copied, $skipped skipped."

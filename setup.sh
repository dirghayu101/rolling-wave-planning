#!/usr/bin/env bash
# Install the rolling-wave-planning skill family into an agent skills directory,
# or check an existing install. See --help.
set -euo pipefail

SKILLS_DIR="${HOME}/.agents/skills"
MODE=install          # install | check
DRY_RUN=0
FORCE=0
DO_CLAUDE=0
PROBLEMS=0            # any entry that is skipped
NOT_A_LINK=0          # a real file/dir sits where an entry belongs

# The six skills-directory entries and their path inside the repo ("" = the repo root).
ENTRY_NAMES=(rolling-wave-planning pre-rolling-wave-planning human-assisted-verification \
             mentor-documentation-system human-engineering-docs senior-mentor)
ENTRY_RELS=("" \
            "skills/pre-rolling-wave-planning" \
            "skills/human-assisted-verification" \
            "skills/mentor-documentation-system" \
            "skills/mentor-documentation-system/skills/human-engineering-docs" \
            "skills/mentor-documentation-system/skills/senior-mentor")
# `mentor-documentation-system` is a bundle, not a skill: it has no SKILL.md of its own,
# only a README and the two nested skills that are entries in their own right. It is
# linked so that paths inside it stay reachable, and it resolves on the directory alone.
ENTRY_KINDS=(skill skill skill bundle skill skill)

usage() {
  cat <<'EOF'
setup.sh - install the rolling-wave-planning skill family.

Usage: ./setup.sh [options]

  --skills-dir <path>  Skills directory to link into (default: $HOME/.agents/skills).
  --claude             Also link the six entries into $HOME/.claude/skills.
  --check              Report state only, change nothing. Exit 0 if all six resolve.
  --dry-run            Print what would be done, change nothing.
  --force              Replace a symlink that points elsewhere. Never deletes a real
                       file or directory.
  -h, --help           This message.

Exit codes: 0 ok, 1 an entry is unresolved or skipped, 2 not a rolling-wave-planning repo.
EOF
}

# Physical absolute path of $1, following every symlink in the chain.
resolve_path() {
  local p=$1 t d b
  while [ -L "$p" ]; do
    t=$(readlink "$p")
    case $t in /*) p=$t ;; *) p="$(dirname "$p")/$t" ;; esac
  done
  d=$(cd "$(dirname "$p")" 2>/dev/null && pwd -P) || { printf '%s\n' "$p"; return 0; }
  b=$(basename "$p")
  if [ -d "$d/$b" ]; then (cd "$d/$b" && pwd -P); else printf '%s\n' "${d%/}/$b"; fi
}

# Path of $1 relative to directory $2, or $1 unchanged if they share no ancestor but /.
relpath() {
  local t=$1 s=$2 up=''
  while [ "${t#"$s"/}" = "$t" ]; do
    [ "$s" = "/" ] && { printf '%s\n' "$t"; return 0; }
    s=$(dirname "$s"); up="../$up"
  done
  printf '%s%s\n' "$up" "${t#"$s"/}"
}

report() { printf '%s  %s  ->  %s\n' "$1" "$2" "$3"; }

# link_one <name> <target_abs> <target_link> <dir>; returns 1 if the entry was skipped.
link_one() {
  local name=$1 target_abs=$2 target_link=$3 dir=$4
  local path="$dir/$name" cur
  if [ -L "$path" ]; then
    cur=$(resolve_path "$path")
    if [ "$cur" = "$target_abs" ]; then report "ok" "$name" "$target_link"; return 0; fi
    if [ "$MODE" = check ]; then report "skipped: points elsewhere (use --force)" "$name" "$cur"; return 1; fi
    if [ "$FORCE" -eq 1 ]; then
      [ "$DRY_RUN" -eq 1 ] && { report "would link" "$name" "$target_link"; return 0; }
      rm -f "$path"; ln -s "$target_link" "$path"
      report "replaced" "$name" "$target_link"; return 0
    fi
    report "skipped: points elsewhere (use --force)" "$name" "$cur"; return 1
  fi
  if [ -e "$path" ]; then
    # --force must never delete real content, so this state is reported, not resolved.
    report "skipped: exists and is not a link" "$name" "$path"
    NOT_A_LINK=1; return 1
  fi
  if [ "$MODE" = check ]; then report "missing" "$name" "$target_link"; return 1; fi
  [ "$DRY_RUN" -eq 1 ] && { report "would link" "$name" "$target_link"; return 0; }
  ln -s "$target_link" "$path"; report "linked" "$name" "$target_link"
}

while [ $# -gt 0 ]; do
  case $1 in
    --skills-dir) [ $# -ge 2 ] || { echo "--skills-dir needs a path" >&2; exit 2; }
                  SKILLS_DIR=$2; shift 2 ;;
    --claude)     DO_CLAUDE=1; shift ;;
    --check)      MODE=check; shift ;;
    --dry-run)    DRY_RUN=1; shift ;;
    --force)      FORCE=1; shift ;;
    -h|--help)    usage; exit 0 ;;
    *)            echo "unknown option: $1" >&2; usage >&2; exit 2 ;;
  esac
done

REPO_DIR=$(dirname "$(resolve_path "${BASH_SOURCE[0]}")")
REPO_DIR=$(cd "$REPO_DIR" && pwd -P)
if [ ! -f "$REPO_DIR/SKILL.md" ] || [ ! -f "$REPO_DIR/skills/pre-rolling-wave-planning/SKILL.md" ]; then
  echo "error: $REPO_DIR is not a rolling-wave-planning repo (SKILL.md or skills/pre-rolling-wave-planning/SKILL.md missing)" >&2
  exit 2
fi

if [ ! -d "$SKILLS_DIR" ]; then
  if [ "$MODE" = check ] || [ "$DRY_RUN" -eq 1 ]; then
    echo "note: skills dir $SKILLS_DIR does not exist"
  else
    mkdir -p "$SKILLS_DIR"
  fi
fi
[ -d "$SKILLS_DIR" ] && SKILLS_DIR=$(cd "$SKILLS_DIR" && pwd -P)

echo "repo:       $REPO_DIR"
echo "skills dir: $SKILLS_DIR"
echo

# Relative link targets only when the repo itself lives under the skills dir.
REPO_UNDER_SKILLS=0
case "$REPO_DIR/" in "$SKILLS_DIR"/*) REPO_UNDER_SKILLS=1 ;; esac

i=0
while [ $i -lt ${#ENTRY_NAMES[@]} ]; do
  name=${ENTRY_NAMES[$i]}; rel=${ENTRY_RELS[$i]}; i=$((i + 1))
  target_abs=$REPO_DIR; [ -n "$rel" ] && target_abs="$REPO_DIR/$rel"
  if [ "$REPO_UNDER_SKILLS" -eq 1 ]; then
    target_link=${target_abs#"$SKILLS_DIR"/}
  else
    target_link=$target_abs
  fi
  if [ -z "$rel" ] && [ "$REPO_DIR" = "$SKILLS_DIR/$name" ]; then
    report "in place" "$name" "$REPO_DIR"
    continue
  fi
  link_one "$name" "$target_abs" "$target_link" "$SKILLS_DIR" || PROBLEMS=$((PROBLEMS + 1))
done

resolved=0
i=0
while [ $i -lt ${#ENTRY_NAMES[@]} ]; do
  name=${ENTRY_NAMES[$i]}; kind=${ENTRY_KINDS[$i]}; i=$((i + 1))
  if [ -r "$SKILLS_DIR/$name/SKILL.md" ]; then resolved=$((resolved + 1))
  elif [ "$kind" = bundle ] && [ -r "$SKILLS_DIR/$name" ] && [ -d "$SKILLS_DIR/$name" ]; then
    resolved=$((resolved + 1))
  fi
done
echo
echo "$resolved/${#ENTRY_NAMES[@]} skills resolve"

if [ "$DO_CLAUDE" -eq 1 ]; then
  echo
  CLAUDE_DIR="$HOME/.claude/skills"
  if [ -d "$CLAUDE_DIR" ] && [ "$(resolve_path "$CLAUDE_DIR")" = "$SKILLS_DIR" ]; then
    echo "claude dir: $CLAUDE_DIR resolves to the skills dir, nothing to do"
  else
    if [ ! -d "$CLAUDE_DIR" ] && [ "$MODE" != check ] && [ "$DRY_RUN" -eq 0 ]; then
      mkdir -p "$CLAUDE_DIR"
    fi
    echo "claude dir: $CLAUDE_DIR"
    if [ -d "$CLAUDE_DIR" ]; then
      CLAUDE_DIR=$(cd "$CLAUDE_DIR" && pwd -P)
      for name in "${ENTRY_NAMES[@]}"; do
        target_abs="$SKILLS_DIR/$name"
        link_one "$name" "$(resolve_path "$target_abs")" "$(relpath "$target_abs" "$CLAUDE_DIR")" \
          "$CLAUDE_DIR" || PROBLEMS=$((PROBLEMS + 1))
      done
    else
      echo "would create $CLAUDE_DIR and link ${#ENTRY_NAMES[@]} entries"
    fi
  fi
fi

echo
echo "Referenced skills (advice only, never changes the exit code)"
LIST="$REPO_DIR/setup/referenced-skills.txt"
if [ ! -f "$LIST" ]; then
  echo "  note: $LIST not found, skipping"
else
  plugin_block=0; sname=""; shint=""
  while IFS=$'\t' read -r sname shint || [ -n "$sname" ]; do
    case $sname in ''|'#'*) continue ;; '[plugin]') plugin_block=1; echo; continue ;; esac
    if [ "$plugin_block" -eq 1 ]; then
      printf '  plugin (check in your harness)  %s  (%s)\n' "$sname" "$shint"
    elif [ -f "$SKILLS_DIR/$sname/SKILL.md" ]; then
      printf '  present  %s\n' "$sname"
    else
      printf '  missing  %s  (%s)\n' "$sname" "$shint"
    fi
  done < "$LIST"
fi

echo
echo "Tools"
for tool in agent-browser graphify node npx git; do
  if command -v "$tool" >/dev/null 2>&1; then printf '  on PATH    %s\n' "$tool"
  else printf '  not found  %s\n' "$tool"; fi
done

if [ "$MODE" = check ]; then
  [ "$resolved" -eq "${#ENTRY_NAMES[@]}" ] && exit 0 || exit 1
fi
if [ "$NOT_A_LINK" -eq 1 ] || [ "$PROBLEMS" -gt 0 ]; then exit 1; fi
if [ "$DRY_RUN" -eq 0 ] && [ "$resolved" -ne "${#ENTRY_NAMES[@]}" ]; then exit 1; fi
exit 0

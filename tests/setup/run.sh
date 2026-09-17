#!/usr/bin/env bash
# Prove setup.sh and setup.ps1 work on a clean machine, using Docker.
# The repo is mounted read-only at /repo and copied inside the container, so every case
# links against a real clone-like directory and nothing here touches the developer's own
# skills directory.
set -uo pipefail

START=$SECONDS
REPO_DIR=$(cd "$(dirname "$0")/../.." && pwd -P)
UBUNTU_IMAGE=ubuntu:24.04
PWSH_IMAGE=mcr.microsoft.com/powershell:latest

DOCKER_ARCH=$(docker version --format '{{.Server.Arch}}' 2>/dev/null)

# MCR publishes no linux/arm64 PowerShell image, so on an arm64 host the amd64 one runs
# emulated. The memory cap is not cosmetic: without it .NET sizes its heap to the whole VM
# and the kernel kills pwsh at startup. Under Docker Desktop on Apple silicon that emulation
# crashes outright (exit 134/139), so by default the pwsh cases are skipped there; set
# RUN_PWSH=1 to force them anyway (still emulated, still crash-prone). TODO: build an arm64
# pwsh test image so this whole workaround goes away.
PWSH_ARGS=()
PWSH_PULL_ARGS=()
if [ "$DOCKER_ARCH" != "amd64" ]; then
  PWSH_PULL_ARGS=(--platform linux/amd64)
  PWSH_ARGS=(--platform linux/amd64 -m 1500m)
fi

SKIP_PWSH=0
if [ "$DOCKER_ARCH" != "amd64" ] && [ "${RUN_PWSH:-}" != "1" ]; then
  SKIP_PWSH=1
fi

pull() {
  docker pull -q "$@" >/dev/null 2>&1 && return 0
  echo "retrying pull: $*" >&2
  docker pull -q "$@" >/dev/null 2>&1 && return 0
  echo "BLOCKED: docker could not pull $* after one retry; check the daemon and network" >&2
  exit 3
}
pull "$UBUNTU_IMAGE"
if [ "$SKIP_PWSH" -eq 0 ]; then
  pull "${PWSH_PULL_ARGS[@]}" "$PWSH_IMAGE"
fi

# Shared assertion helpers, sourced by both container scripts.
read -r -d '' PRELUDE <<'PRE' || true
set -u
PASSED=0; FAILED=0
ok()  { echo "PASS  $1"; PASSED=$((PASSED + 1)); }
bad() { echo "FAIL  $1: $2"; FAILED=$((FAILED + 1)); }
eq()  { if [ "$2" = "$3" ]; then ok "$1"; else bad "$1" "expected [$3], got [$2]"; fi; }
NAMES="rolling-wave-planning pre-rolling-wave-planning human-assisted-verification mentor-documentation-system human-engineering-docs senior-mentor"
# A clone-like copy of the repo, without the git dir.
mkclone() { mkdir -p "$(dirname "$1")"; cp -a /repo "$1"; rm -rf "$1/.git"; }
# The status column of the one output line for entry $2.
status_of() { sed -n "s|^\(.*\)  $2  ->  .*|\1|p" "$1" | head -1; }
fingerprint() { for n in $NAMES; do stat -c '%i %Y' "$1/$n" 2>/dev/null || echo "-"; done; }
# mentor-documentation-system is a bundle with no SKILL.md of its own, so it resolves on
# the directory. This mirrors the rule in setup.sh / setup.ps1.
BUNDLES=" mentor-documentation-system "
entry_resolves() {
  [ -r "$1/$2/SKILL.md" ] && return 0
  case "$BUNDLES" in *" $2 "*) [ -d "$1/$2" ] && [ -r "$1/$2" ] && return 0 ;; esac
  return 1
}
# Prints the entries that do not resolve under skills dir $1, or "0" when all six do.
unresolved() { u=""; for n in $NAMES; do entry_resolves "$1" "$n" || u="$u $n"; done; echo "${u:-0}"; }
PRE

BASH_LOG=$(mktemp)
echo "=== bash cases ($UBUNTU_IMAGE) ==="
docker run --rm -i -v "$REPO_DIR":/repo:ro "$UBUNTU_IMAGE" bash -s <<BASHCASES | tee "$BASH_LOG"
$PRELUDE
SH=/home/t/src/rolling-wave-planning/setup.sh

# --- B1 fresh install into the default skills dir -------------------------------------
export HOME=/home/t
mkclone /home/t/src/rolling-wave-planning
bash \$SH >/tmp/b1.out 2>&1; rc=\$?
eq "B1 exit 0" "\$rc" "0"
eq "B1 six entries resolve" "\$(unresolved "\$HOME/.agents/skills")" "0"
if grep -q '^6/6 skills resolve\$' /tmp/b1.out; then ok "B1 summary line"; else bad "B1 summary line" "\$(grep 'skills resolve' /tmp/b1.out)"; fi

# --- B2 idempotent --------------------------------------------------------------------
before=\$(fingerprint "\$HOME/.agents/skills")
bash \$SH >/tmp/b2.out 2>&1; rc=\$?
after=\$(fingerprint "\$HOME/.agents/skills")
eq "B2 exit 0" "\$rc" "0"
eq "B2 no link recreated (inode+mtime)" "\$after" "\$before"
b2bad=""
for n in \$NAMES; do s=\$(status_of /tmp/b2.out "\$n"); case "\$s" in ok|"in place") ;; *) b2bad="\$b2bad \$n=[\$s]" ;; esac; done
eq "B2 every entry reads ok or in place" "\$b2bad" ""

# --- B3 repo already sitting in the skills dir ----------------------------------------
export HOME=/home/t2
mkclone /home/t2/.agents/skills/rolling-wave-planning
bash /home/t2/.agents/skills/rolling-wave-planning/setup.sh >/tmp/b3.out 2>&1; rc=\$?
eq "B3 exit 0" "\$rc" "0"
eq "B3 root entry in place" "\$(status_of /tmp/b3.out rolling-wave-planning)" "in place"
b3bad=""
for n in \$NAMES; do
  [ "\$n" = "rolling-wave-planning" ] && continue
  t=\$(readlink "\$HOME/.agents/skills/\$n")
  case "\$t" in rolling-wave-planning/*) ;; *) b3bad="\$b3bad \$n=[\$t]" ;; esac
done
eq "B3 five relative sub-skill links" "\$b3bad" ""
eq "B3 six entries resolve" "\$(unresolved "\$HOME/.agents/skills")" "0"

# --- B4 check mode --------------------------------------------------------------------
export HOME=/home/t
bash \$SH --check >/tmp/b4a.out 2>&1; eq "B4 --check exits 0 after install" "\$?" "0"
if grep -q '^6/6 skills resolve\$' /tmp/b4a.out; then ok "B4 --check reports 6/6"; else bad "B4 --check reports 6/6" "\$(grep 'skills resolve' /tmp/b4a.out)"; fi
mkdir -p /home/t4/empty
bash \$SH --check --skills-dir /home/t4/empty >/tmp/b4b.out 2>&1; eq "B4 --check exits 1 on an empty skills dir" "\$?" "1"
eq "B4 --check made no changes" "\$(ls -A /home/t4/empty | wc -l)" "0"

# --- B5 a real directory where an entry belongs is never deleted ----------------------
export HOME=/home/t5
mkdir -p /home/t5/.agents/skills/pre-rolling-wave-planning
echo keep > /home/t5/.agents/skills/pre-rolling-wave-planning/real.txt
for pass in "" "--force"; do
  label="B5\${pass:+ --force}"
  bash \$SH \$pass >/tmp/b5.out 2>&1; rc=\$?
  eq "\$label exit 1" "\$rc" "1"
  eq "\$label real dir survives" "\$(cat /home/t5/.agents/skills/pre-rolling-wave-planning/real.txt 2>&1)" "keep"
  s=\$(status_of /tmp/b5.out pre-rolling-wave-planning)
  case "\$s" in skipped*) ok "\$label reports skipped" ;; *) bad "\$label reports skipped" "got [\$s]" ;; esac
done

# --- B6 --claude ----------------------------------------------------------------------
export HOME=/home/t6
bash \$SH --claude >/tmp/b6.out 2>&1; rc=\$?
eq "B6 exit 0" "\$rc" "0"
nolink=""; for n in \$NAMES; do [ -L "\$HOME/.claude/skills/\$n" ] || nolink="\$nolink \$n"; done
eq "B6 six symlinks under \\\$HOME/.claude/skills" "\${nolink:-0}" "0"
eq "B6 six entries resolve through them" "\$(unresolved "\$HOME/.claude/skills")" "0"

# --- B7 dry run creates nothing -------------------------------------------------------
export HOME=/home/t7
bash \$SH --dry-run >/tmp/b7.out 2>&1; rc=\$?
eq "B7 exit 0" "\$rc" "0"
eq "B7 nothing created" "\$([ -e /home/t7/.agents ] || [ -e /home/t7/.claude ] && echo exists || echo absent)" "absent"
if grep -q '^would link  rolling-wave-planning  ->  ' /tmp/b7.out; then ok "B7 prints would link"; else bad "B7 prints would link" "no such line"; fi

echo "bash: \$PASSED passed, \$FAILED failed"
[ "\$FAILED" -eq 0 ]
BASHCASES
BASH_RC=${PIPESTATUS[0]}
BASH_SUMMARY=$(grep '^bash: ' "$BASH_LOG" | tail -1)
BASH_PASSED=$(echo "$BASH_SUMMARY" | sed -n 's/^bash: \([0-9][0-9]*\) passed.*/\1/p')
BASH_FAILED=$(echo "$BASH_SUMMARY" | sed -n 's/.*, \([0-9][0-9]*\) failed$/\1/p')
BASH_PASSED=${BASH_PASSED:-0}
BASH_FAILED=${BASH_FAILED:-0}
rm -f "$BASH_LOG"

PWSH_SKIPPED=0
echo
if [ "$SKIP_PWSH" -eq 1 ]; then
  echo "=== powershell cases (skipped) ==="
  for case_id in "P1 fresh install" "P2 idempotent" "P4 check mode" "P5 real directory preserved" "P7 dry run"; do
    echo "skip  $case_id (pwsh cases need an amd64 daemon; set RUN_PWSH=1 to force; TODO arm64 image)"
    PWSH_SKIPPED=$((PWSH_SKIPPED + 1))
  done
  PWSH_PASSED=0
  PWSH_FAILED=0
  PWSH_RC=0
else
  echo "=== powershell cases ($PWSH_IMAGE${PWSH_ARGS:+, ${PWSH_ARGS[*]}}) ==="
  echo "note: the Windows junction fallback in setup.ps1 is not exercised here; it needs a Windows host."
  PWSH_LOG=$(mktemp)
  docker run --rm -i "${PWSH_ARGS[@]}" -v "$REPO_DIR":/repo:ro "$PWSH_IMAGE" bash -s <<PWSHCASES | tee "$PWSH_LOG"
$PRELUDE
PS1F=/home/t/src/rolling-wave-planning/setup.ps1
run() { pwsh -NoProfile -File \$PS1F "\$@"; }

# --- P1 fresh install -----------------------------------------------------------------
export HOME=/home/t
mkclone /home/t/src/rolling-wave-planning
run >/tmp/p1.out 2>&1; rc=\$?
eq "P1 exit 0" "\$rc" "0"
eq "P1 six entries resolve" "\$(unresolved "\$HOME/.agents/skills")" "0"
if grep -q '^6/6 skills resolve\$' /tmp/p1.out; then ok "P1 summary line"; else bad "P1 summary line" "\$(cat /tmp/p1.out)"; fi

# --- P2 idempotent --------------------------------------------------------------------
before=\$(fingerprint "\$HOME/.agents/skills")
run >/tmp/p2.out 2>&1; rc=\$?
after=\$(fingerprint "\$HOME/.agents/skills")
eq "P2 exit 0" "\$rc" "0"
eq "P2 no link recreated (inode+mtime)" "\$after" "\$before"
p2bad=""
for n in \$NAMES; do s=\$(status_of /tmp/p2.out "\$n"); case "\$s" in ok|"in place") ;; *) p2bad="\$p2bad \$n=[\$s]" ;; esac; done
eq "P2 every entry reads ok or in place" "\$p2bad" ""

# --- P4 check mode --------------------------------------------------------------------
run -Check >/tmp/p4a.out 2>&1; eq "P4 -Check exits 0 after install" "\$?" "0"
mkdir -p /home/p4/empty
run -Check -SkillsDir /home/p4/empty >/tmp/p4b.out 2>&1; eq "P4 -Check exits 1 on an empty skills dir" "\$?" "1"
eq "P4 -Check made no changes" "\$(ls -A /home/p4/empty | wc -l)" "0"

# --- P5 a real directory where an entry belongs is never deleted ----------------------
export HOME=/home/p5
mkdir -p /home/p5/.agents/skills/pre-rolling-wave-planning
echo keep > /home/p5/.agents/skills/pre-rolling-wave-planning/real.txt
for pass in "" "-Force"; do
  label="P5\${pass:+ -Force}"
  run \$pass >/tmp/p5.out 2>&1; rc=\$?
  eq "\$label exit 1" "\$rc" "1"
  eq "\$label real dir survives" "\$(cat /home/p5/.agents/skills/pre-rolling-wave-planning/real.txt 2>&1)" "keep"
  s=\$(status_of /tmp/p5.out pre-rolling-wave-planning)
  case "\$s" in skipped*) ok "\$label reports skipped" ;; *) bad "\$label reports skipped" "got [\$s]" ;; esac
done

# --- P7 dry run creates nothing -------------------------------------------------------
export HOME=/home/p7
run -DryRun >/tmp/p7.out 2>&1; rc=\$?
eq "P7 exit 0" "\$rc" "0"
eq "P7 nothing created" "\$([ -e /home/p7/.agents ] || [ -e /home/p7/.claude ] && echo exists || echo absent)" "absent"
if grep -q '^would link  rolling-wave-planning  ->  ' /tmp/p7.out; then ok "P7 prints would link"; else bad "P7 prints would link" "no such line"; fi

echo "powershell: \$PASSED passed, \$FAILED failed"
[ "\$FAILED" -eq 0 ]
PWSHCASES
  PWSH_RC=${PIPESTATUS[0]}
  PWSH_SUMMARY=$(grep '^powershell: ' "$PWSH_LOG" | tail -1)
  PWSH_PASSED=$(echo "$PWSH_SUMMARY" | sed -n 's/^powershell: \([0-9][0-9]*\) passed.*/\1/p')
  PWSH_FAILED=$(echo "$PWSH_SUMMARY" | sed -n 's/.*, \([0-9][0-9]*\) failed$/\1/p')
  PWSH_PASSED=${PWSH_PASSED:-0}
  PWSH_FAILED=${PWSH_FAILED:-0}
  rm -f "$PWSH_LOG"
fi

TOTAL_PASSED=$((BASH_PASSED + PWSH_PASSED))
TOTAL_FAILED=$((BASH_FAILED + PWSH_FAILED))

echo
echo "bash cases exit: $BASH_RC    powershell cases exit: $PWSH_RC"
echo "wall time: $((SECONDS - START))s"
echo "summary: $TOTAL_PASSED passed, $PWSH_SKIPPED skipped, $TOTAL_FAILED failed"
if [ "$TOTAL_FAILED" -eq 0 ]; then echo "ALL CASES PASS"; exit 0; fi
echo "SOME CASES FAILED"; exit 1

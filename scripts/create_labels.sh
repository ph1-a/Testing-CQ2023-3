#!/usr/bin/env bash
# Creates the shared issue labels. Run once, from inside the repo folder.
# Needs the GitHub CLI (https://cli.github.com) and `gh auth login` done first.
# Re-running is safe: --force updates labels that already exist.
#
# Usage: bash scripts/create_labels.sh STUDENT_ID_1 STUDENT_ID_2 ...

set -e

label() { gh label create "$1" --color "$2" --description "$3" --force; }

# Features
for n in 01 02 03 04 05 06; do label "FR-$n" "1d76db" "Pool A"; done
for n in 07 08 09 10 11;    do label "FR-$n" "0e8a16" "Pool B"; done
for n in 12 13 14 15 16 17 18 19; do label "FR-$n" "5319e7" "Pool C"; done
label "mobile" "c5def5" "Pool D"

# Technique
label "domain" "fbca04" "Found by domain testing"
label "bva"    "f9d0c4" "Found by boundary value analysis"

# Severity
label "sev:critical" "b60205" "Security hole, data loss, or blocks the feature"
label "sev:major"    "d93f0b" "Wrong behaviour against the spec"
label "sev:minor"    "fef2c0" "Small deviation, workaround exists"
label "sev:trivial"  "ededed" "Cosmetic, wording, label"

# Spec / security
label "security" "000000" "Violates a SEC-xx requirement"

# One label per member, passed as arguments
for id in "$@"; do label "by:$id" "bfdadc" "Reported by $id"; done

echo "Labels created."

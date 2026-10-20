#!/usr/bin/env bash
# Creates your personal folder for one homework, with one subfolder per feature.
# Usage:   bash scripts/new_member.sh HW_NAME STUDENT_ID FR-xx [FR-yy ...]
# Example: bash scripts/new_member.sh HW02 22127001 FR-03 FR-07 FR-12
# Safe to re-run: existing files are never overwritten, so you can add a feature later.

set -e
if [ $# -lt 3 ]; then
  echo "Usage: bash scripts/new_member.sh HW_NAME STUDENT_ID FR-xx [FR-yy ...]"; exit 1
fi

HW="$1"; ID="$2"; shift 2
ROOT="$HW/$ID"
mkdir -p "$ROOT" "$HW/bugs/screenshots"
touch "$HW/bugs/screenshots/.gitkeep"

# write FILE only if it doesn't exist yet (content comes from stdin)
new() { if [ -e "$1" ]; then cat >/dev/null; echo "  skip (exists): $1"; else cat > "$1"; echo "  created: $1"; fi; }

TC_HEAD='| TC ID | Objective | Precondition | Input data | Steps | Expected | Actual | Verdict |
|---|---|---|---|---|---|---|---|'

# Homework-level README (assignment table), created once by whoever runs first
new "$HW/README.md" <<EOF
# $HW

## Feature assignment (no duplicates)
| Student ID | Pool A | Pool B | Pool C | Pool D (mobile) |
|---|---|---|---|---|
| | | | | |
EOF

for FR in "$@"; do
  D="$ROOT/$FR"
  mkdir -p "$D/screenshots"
  touch "$D/screenshots/.gitkeep"

  new "$D/${FR}_1_variables.md" <<EOF
# $FR – Step 1: Identify input & output variables

## Spec used

## Input variables
| ID | Variable | Condition / constraint | Type | From spec or Assumption |
|---|---|---|---|---|

## Output variables
| ID | Variable | Condition / constraint | Type | From spec or Assumption |
|---|---|---|---|---|

## Ambiguities / questions about the spec
EOF

  new "$D/${FR}_2_equivalence_classes.md" <<EOF
# $FR – Step 2: Equivalence classes

## Classes per variable
| Class ID | Variable ID | Class | Valid / Invalid | Example value |
|---|---|---|---|---|

## Changes from the AI output
EOF

  new "$D/${FR}_3_test_cases.md" <<EOF
# $FR – Step 3: Test cases (best representative of each class)

$TC_HEAD

## Class coverage
| Class ID | Covered by TC |
|---|---|

## Changes from the AI output
EOF

  new "$D/${FR}_4_bva.md" <<EOF
# $FR – Step 4: Boundary value analysis

## Boundaries
| Variable ID | Boundary | Below | On | Above |
|---|---|---|---|---|

## Test cases
$TC_HEAD

## Changes from the AI output
EOF

  new "$D/${FR}_5_execution.md" <<EOF
# $FR – Step 5: Execution results

| TC ID | Date executed | Actual | Verdict | Issue link |
|---|---|---|---|---|

## Summary
| Designed | Executed | Passed | Failed | Not executed |
|---|---|---|---|---|
| | | | | |
EOF

  new "$D/${FR}_6_ai_gap_analysis.md" <<EOF
# $FR – Step 6: AI gap analysis

| What the AI missed | How I found it | Why the AI missed it (prompt / tool limit / feature complexity) |
|---|---|---|
EOF
done

new "$ROOT/prompt_log.md" <<EOF
# Prompt log – $ID – $HW

<!-- One entry per AI interaction. Copy prompts and outputs exactly; never paraphrase. -->

## Entry 1
- **Tool:**
- **Time:** HH:MM dd/mm/yyyy
- **Feature / step:**
- **Prompt:**
\`\`\`
\`\`\`
- **Output:**
\`\`\`
\`\`\`
EOF

new "$ROOT/ai_critique.md" <<EOF
# AI Critique – $ID – $HW (200–300 words)

<!-- Where was the AI wrong, biased or incomplete? Why did it miss it?
     What principle did you learn about working with AI? -->
EOF

new "$ROOT/README.md" <<EOF
# $HW – $ID

## Self-assessment
| No. | Criteria | Grade | Self-assessed |
|---|---|---|---|
| 1 | Feature A (Domain + Boundary) | 25 | |
| 2 | Feature B (Domain + Boundary) | 25 | |
| 3 | Feature C (Domain + Boundary) | 25 | |
| 4 | Feature D (Mobile, Domain + Boundary) | 15 | |
| 5 | Agent Skills | 10 | |
| | **Total** | **100** | |

## Test summary report
| Metric | Count |
|---|---|
| Features tested | |
| Test cases designed | |
| Executed | |
| Passed | |
| Failed | |
| Not executed | |
| Bugs reported | |

## Demo videos
-

## Bugs (GitHub Issues)
-
EOF

echo
echo "Done. Next:"
echo "  git add $HW && git commit -m \"$HW: set up $ID folder\" && git push"

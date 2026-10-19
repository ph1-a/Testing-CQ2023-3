#!/usr/bin/env bash
# Creates your personal HW02 folder with one subfolder per feature.
# Usage: bash scripts/new_member.sh STUDENT_ID FR-03 FR-07 FR-12 [MOBILE]
# Example: bash scripts/new_member.sh 22127001 FR-03 FR-07 FR-12

set -e
if [ $# -lt 2 ]; then
  echo "Usage: bash scripts/new_member.sh STUDENT_ID FR-xx [FR-yy ...]"; exit 1
fi

ID="$1"; shift
mkdir -p "$ID"

for FR in "$@"; do
  D="$ID/$FR"
  mkdir -p "$D/screenshots"
  touch "$D/screenshots/.gitkeep"

  cat > "$D/01_spec_analysis.md" <<EOF
# $FR – Step 1: Spec analysis

## Spec excerpt
<!-- Paste the relevant requirement text from eshop-sut README / api_specification -->

## Input and output variables
| Variable | Type | Source (UI / API) | Constraint from spec |
|---|---|---|---|

## Ambiguities / questions about the spec
EOF

  cat > "$D/02_domain_testing.md" <<EOF
# $FR – Step 2: Domain testing

## 2.1 Variables and their domains

## 2.2 Partitions (valid / invalid equivalence classes)
| ID | Variable | Partition | Valid? | Representative value |
|---|---|---|---|---|

## 2.3 Combining partitions / domain analysis table

## 2.4 Test cases
| TC ID | Objective | Input | Steps | Expected | Actual | Verdict |
|---|---|---|---|---|---|---|

## 2.5 What I changed from the AI output
EOF

  cat > "$D/03_bva.md" <<EOF
# $FR – Step 3: Boundary value analysis

## 3.1 Boundaries identified
| Variable | Boundary | Below (off) | On | Above (off) |
|---|---|---|---|---|

## 3.2 Test cases
| TC ID | Objective | Input | Steps | Expected | Actual | Verdict |
|---|---|---|---|---|---|---|

## 3.3 What I changed from the AI output
EOF

  cat > "$D/04_execution.md" <<EOF
# $FR – Step 4: Execution results

| TC ID | Executed on (date) | Actual | Verdict | Bug / Issue link |
|---|---|---|---|---|

## Summary
- Designed:
- Executed:
- Passed:
- Failed:
- Not executed:
EOF

  cat > "$D/05_ai_gap_analysis.md" <<EOF
# $FR – Step 5: AI gap analysis

| What the AI missed | Found how | Why the AI missed it (prompt / tool limit / feature complexity) |
|---|---|---|
EOF
done

cat > "$ID/prompt_log.md" <<EOF
# Prompt log – $ID

<!-- One entry per AI interaction. Never paraphrase prompts or outputs. -->

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

cat > "$ID/ai_critique.md" <<EOF
# AI Critique – $ID (200–300 words)

<!-- Where was the AI wrong, biased or incomplete? Why did it miss it?
     What principle did you learn about working with AI? -->
EOF

cat > "$ID/README.md" <<EOF
# HW02 – Domain Testing – $ID

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

echo "Created $ID/ with: $*"
echo "Next: git add $ID && git commit -m \"$ID: set up HW02 folder\" && git push"

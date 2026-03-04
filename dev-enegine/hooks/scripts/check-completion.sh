#!/bin/bash
# Stop hook - prevents the main session from ending while features remain incomplete.
# Only blocks if there is an actively developing requirement with unfinished features.

set -euo pipefail

INPUT=$(cat)
CWD=$(echo "$INPUT" | jq -r '.cwd')
STOP_HOOK_ACTIVE=$(echo "$INPUT" | jq -r '.stop_hook_active // false')

if [ "$STOP_HOOK_ACTIVE" = "true" ]; then
  exit 0
fi

MANIFEST="$CWD/.dev-enegine/requirements/manifest.json"
if [ ! -f "$MANIFEST" ]; then
  exit 0
fi

REQ_DIR=$(jq -r '[.requirements[] | select(.status == "developing")] | last | .dir // empty' "$MANIFEST")
if [ -z "$REQ_DIR" ]; then
  exit 0
fi

FEATURE_LIST="$CWD/.dev-enegine/requirements/$REQ_DIR/feature_list.json"
if [ ! -f "$FEATURE_LIST" ]; then
  exit 0
fi

INCOMPLETE=$(jq '[.features[] | select(.passes == false)] | length' "$FEATURE_LIST" 2>/dev/null || echo "0")
TOTAL=$(jq '.features | length' "$FEATURE_LIST" 2>/dev/null || echo "0")
BLOCKED=$(jq '[.features[] | select(.blocked == true)] | length' "$FEATURE_LIST" 2>/dev/null || echo "0")

ACTIONABLE=$((INCOMPLETE - BLOCKED))

if [ "$ACTIONABLE" -gt 0 ] 2>/dev/null; then
  jq -n \
    --arg incomplete "$INCOMPLETE" \
    --arg total "$TOTAL" \
    --arg blocked "$BLOCKED" \
    --arg dir "$REQ_DIR" '{
    decision: "block",
    reason: ("Requirement \"" + $dir + "\" still has " + $incomplete + "/" + $total + " incomplete features (" + $blocked + " blocked). Continue developing the next available feature, or explicitly tell the user why you need to stop.")
  }'
  exit 0
fi

exit 0

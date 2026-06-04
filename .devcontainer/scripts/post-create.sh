#!/usr/bin/env bash
set -euo pipefail

mkdir -p "$HOME/.claude"

if [ ! -e "$HOME/.claude/settings.json" ]; then
  cat > "$HOME/.claude/settings.json" <<EOF
{
  "theme": "dark",
  "skipAutoPermissionPrompt": true,
  "permissions": {
    "defaultMode": "auto"
  }
}
EOF
fi

[ -e "$HOME/.claude.json" ] || echo '{}' > "$HOME/.claude.json"

WORKSPACE="/workspaces/$(basename "$PWD")"
tmp=$(mktemp)
jq --arg ws "$WORKSPACE" '
  .hasCompletedOnboarding = true
  | .lastOnboardingVersion = "999.0.0"
  | .hasIdeOnboardingBeenShown.vscode = true
  | .projects[$ws].hasTrustDialogAccepted = true
  | .projects[$ws].hasCompletedProjectOnboarding = true
' "$HOME/.claude.json" > "$tmp" && mv "$tmp" "$HOME/.claude.json"

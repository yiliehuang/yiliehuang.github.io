#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

BRANCH="$(git branch --show-current)"
if [[ -z "$BRANCH" ]]; then
  echo "Could not determine the current branch." >&2
  exit 1
fi

git fetch origin

UPSTREAM="$(git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null || true)"
if [[ -z "$UPSTREAM" ]]; then
  if git rev-parse --verify origin/main >/dev/null 2>&1; then
    UPSTREAM="origin/main"
  elif git rev-parse --verify origin/master >/dev/null 2>&1; then
    UPSTREAM="origin/master"
  else
    echo "Could not determine upstream online branch." >&2
    exit 1
  fi
fi

LOCAL_HEAD="$(git rev-parse HEAD)"
REMOTE_HEAD="$(git rev-parse "$UPSTREAM")"

if [[ "$LOCAL_HEAD" == "$REMOTE_HEAD" ]]; then
  echo "Online branch $UPSTREAM already matches local HEAD $LOCAL_HEAD."
  exit 0
fi

if ! git merge-base --is-ancestor "$REMOTE_HEAD" "$LOCAL_HEAD"; then
  echo "Refusing to push: $UPSTREAM is not an ancestor of local HEAD." >&2
  echo "Run git fetch origin and inspect the branch before publishing." >&2
  exit 1
fi

echo "Opening GitHub Desktop for $ROOT."
open -a "GitHub Desktop" "$ROOT"

osascript <<'APPLESCRIPT'
tell application "GitHub Desktop" to activate
delay 1
tell application "System Events"
  tell process "GitHub Desktop"
    set didPush to false
    repeat with attempt from 1 to 20
      try
        set pushItem to menu item "Push" of menu 1 of menu bar item "Repository" of menu bar 1
        if enabled of pushItem then
          click pushItem
          set didPush to true
          exit repeat
        end if
      end try
      delay 1
    end repeat
    if didPush is false then
      error "GitHub Desktop Push menu item was not enabled."
    end if
  end tell
end tell
APPLESCRIPT

echo "Waiting for origin to match local HEAD."
for attempt in {1..24}; do
  sleep 5
  git fetch origin
  if [[ "$(git rev-parse "$UPSTREAM")" == "$LOCAL_HEAD" ]]; then
    echo "Push verified: $UPSTREAM matches $LOCAL_HEAD."
    osascript -e 'tell application "GitHub Desktop" to quit' >/dev/null 2>&1 || true
    exit 0
  fi
done

echo "Push was triggered, but $UPSTREAM did not match $LOCAL_HEAD during the verification window." >&2
exit 1

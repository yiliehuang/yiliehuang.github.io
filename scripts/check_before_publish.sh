#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

echo "Current git status:"
git status --short
echo

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

echo "Online branch: $UPSTREAM"
echo

if [[ -f "$ROOT/cv/CV_Yilie_Huang.tex" ]]; then
  if git status --short -- cv files/CV_Yilie_Huang.pdf | grep -q .; then
    echo "CV files changed; compiling CV and refreshing files/CV_Yilie_Huang.pdf."
    "$ROOT/scripts/build_cv.sh"
    echo
  else
    echo "CV files unchanged; skipping CV compile."
    echo
  fi
else
  echo "No CV source found at cv/CV_Yilie_Huang.tex; skipping CV compile."
  echo
fi

if ! command -v bundle >/dev/null 2>&1; then
  echo "Bundler is not installed. Install Bundler, then run: bundle install" >&2
  exit 1
fi

if ! bundle exec jekyll -v >/dev/null 2>&1; then
  echo "Jekyll dependencies are not installed yet." >&2
  echo "Run: bundle install" >&2
  exit 1
fi

bundle exec jekyll build --config _config.yml,_config_local.yml

echo
echo "Changed files compared with $UPSTREAM:"
git diff --name-only "$UPSTREAM"
git ls-files --others --exclude-standard

echo
echo "Diff summary compared with $UPSTREAM:"
git diff --stat "$UPSTREAM"

echo
echo "Raw implementation-level diff support compared with online version:"
echo "Use this to prepare the final visible/material change report; do not paste implementation-only details as the user-facing report."
"$ROOT/scripts/report_online_diff.py" "$UPSTREAM"

echo
echo "Preview command:"
echo "  ./scripts/preview_site.sh [relevant-page-path ...]"

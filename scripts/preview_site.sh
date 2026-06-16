#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

if ! command -v bundle >/dev/null 2>&1; then
  echo "Bundler is not installed. Install Bundler, then run: bundle install" >&2
  exit 1
fi

if ! bundle exec jekyll -v >/dev/null 2>&1; then
  echo "Jekyll dependencies are not installed yet." >&2
  echo "Run: bundle install" >&2
  exit 1
fi

echo "Preview links:"
echo "  http://127.0.0.1:4000/"
if [[ "$#" -gt 0 ]]; then
  for path in "$@"; do
    path="/${path#/}"
    echo "  http://127.0.0.1:4000$path"
  done
else
  echo "  http://127.0.0.1:4000/publications/"
  echo "  http://127.0.0.1:4000/talks/"
  echo "  http://127.0.0.1:4000/service/"
  echo "  http://127.0.0.1:4000/files/CV_Yilie_Huang.pdf"
fi

exec bundle exec jekyll serve --config _config.yml,_config_local.yml --host 127.0.0.1 --port 4000 --livereload

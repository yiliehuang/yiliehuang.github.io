#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$ROOT/cv/CV_Yilie_Huang.tex"
BUILD_DIR="$ROOT/cv/build"
PUBLIC_PDF="$ROOT/files/CV_Yilie_Huang.pdf"

if [[ ! -f "$SRC" ]]; then
  echo "Missing CV source: $SRC" >&2
  echo "Place the LaTeX source at cv/CV_Yilie_Huang.tex." >&2
  exit 1
fi

mkdir -p "$BUILD_DIR" "$ROOT/files"

if command -v latexmk >/dev/null 2>&1; then
  (
    cd "$ROOT/cv"
    latexmk -pdf -interaction=nonstopmode -halt-on-error -outdir="$BUILD_DIR" "$(basename "$SRC")"
  )
elif command -v pdflatex >/dev/null 2>&1; then
  (
    cd "$ROOT/cv"
    pdflatex -interaction=nonstopmode -halt-on-error -output-directory="$BUILD_DIR" "$(basename "$SRC")"
    pdflatex -interaction=nonstopmode -halt-on-error -output-directory="$BUILD_DIR" "$(basename "$SRC")"
  )
else
  echo "Neither latexmk nor pdflatex was found." >&2
  echo "Install a LaTeX distribution before building the CV." >&2
  exit 1
fi

cp "$BUILD_DIR/CV_Yilie_Huang.pdf" "$PUBLIC_PDF"
echo "Updated public CV PDF: $PUBLIC_PDF"

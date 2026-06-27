#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC_DIR="${SRC_DIR:-$ROOT_DIR/assets/readme}"
OUT_DIR="${1:-$ROOT_DIR/tmp/readme-images}"

mkdir -p "$OUT_DIR"

render_svg() {
  local src="$1"
  local base
  local out
  base="$(basename "$src" .svg)"
  out="$OUT_DIR/$base.png"

  if command -v rsvg-convert >/dev/null 2>&1; then
    rsvg-convert "$src" -o "$out"
  elif command -v resvg >/dev/null 2>&1; then
    resvg "$src" "$out"
  elif command -v magick >/dev/null 2>&1; then
    magick "$src" "$out"
  elif command -v convert >/dev/null 2>&1; then
    convert "$src" "$out"
  elif command -v sips >/dev/null 2>&1; then
    sips -s format png "$src" --out "$out" >/dev/null
  else
    echo "error: need one renderer: rsvg-convert, resvg, magick, convert, or macOS sips" >&2
    return 1
  fi

  echo "rendered: $out"
}

found=0
for src in "$SRC_DIR"/*.svg; do
  [ -e "$src" ] || continue
  found=1
  render_svg "$src"
done

if [ "$found" -eq 0 ]; then
  echo "error: no SVG files found in $SRC_DIR" >&2
  exit 1
fi

echo ""
echo "output directory: $OUT_DIR"

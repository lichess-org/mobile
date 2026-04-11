#!/usr/bin/env bash
# sync-chessground-assets.sh
#
# Syncs board textures and piece images from the flutter-chessground pub package
# into the iOS widget's asset catalog (Chessboard group).
#
# Run from the repo root after upgrading the chessground dependency:
#   ./scripts/sync-chessground-assets.sh
#
# The script reads the locked version from pubspec.lock so it always uses the
# same version the Dart side uses. No arguments needed.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CATALOG="$REPO_ROOT/ios/LichessWidgets/Resources/Assets.xcassets/Chessboard"

# ---------------------------------------------------------------------------
# 1. Locate the chessground package in the pub cache
# ---------------------------------------------------------------------------

VERSION=$(awk '/^  chessground:/{found=1} found && /version:/{print $2; exit}' \
    "$REPO_ROOT/pubspec.lock" | tr -d '"')

if [[ -z "$VERSION" ]]; then
    echo "error: could not read chessground version from pubspec.lock" >&2
    exit 1
fi

# flutter pub cache dir is the canonical way to find the cache root.
if command -v flutter &>/dev/null; then
    PUB_CACHE=$(flutter pub cache dir 2>/dev/null || true)
fi
PUB_CACHE="${PUB_CACHE:-$HOME/.pub-cache}"

PACKAGE="$PUB_CACHE/hosted/pub.dev/chessground-$VERSION"

if [[ ! -d "$PACKAGE" ]]; then
    echo "error: chessground-$VERSION not found in pub cache ($PACKAGE)" >&2
    echo "       run 'flutter pub get' first" >&2
    exit 1
fi

echo "Using chessground $VERSION from $PACKAGE"

# ---------------------------------------------------------------------------
# 2. Wipe existing board_ and piece_ imagesets so removed assets don't linger
# ---------------------------------------------------------------------------

find "$CATALOG" -maxdepth 1 -type d \( -name "board_*.imageset" -o -name "piece_*.imageset" \) \
    -exec rm -rf {} + 2>/dev/null || true

# ---------------------------------------------------------------------------
# 3. Board textures
#
# Each line is "<dart-const-name> <source-filename>" where the dart-const-name
# matches the ChessboardColorScheme static const (= asset name used by Swift).
# macOS ships bash 3.2 which has no associative arrays, so we use a plain list.
# ---------------------------------------------------------------------------

BOARDS_SRC="$PACKAGE/assets/boards"

# "<dart name> <source file>"
BOARD_ENTRIES=(
    "blue2        blue2.jpg"
    "blue3        blue3.jpg"
    "blueMarble   blue-marble.jpg"
    "canvas       canvas2.jpg"
    "greenPlastic green-plastic.png"
    "grey         grey.jpg"
    "horsey       horsey.jpg"
    "leather      leather.jpg"
    "maple        maple.jpg"
    "maple2       maple2.jpg"
    "marble       marble.jpg"
    "metal        metal.jpg"
    "newspaper    newspaper.png"
    "olive        olive.jpg"
    "pinkPyramid  pink-pyramid.png"
    "purple       purple.png"
    "purpleDiag   purple-diag.png"
    "wood         wood.jpg"
    "wood2        wood2.jpg"
    "wood3        wood3.jpg"
    "wood4        wood4.jpg"
)

board_count=0
for entry in "${BOARD_ENTRIES[@]}"; do
    name=$(echo "$entry" | awk '{print $1}')
    src_file=$(echo "$entry" | awk '{print $2}')
    ext="${src_file##*.}"
    dest="$CATALOG/board_${name}.imageset"
    mkdir -p "$dest"
    cp "$BOARDS_SRC/$src_file" "$dest/board.$ext"
    cat > "$dest/Contents.json" <<EOF
{
  "images" : [
    { "filename" : "board.$ext", "idiom" : "universal", "scale" : "1x" },
    { "idiom" : "universal", "scale" : "2x" },
    { "idiom" : "universal", "scale" : "3x" }
  ],
  "info" : { "author" : "xcode", "version" : 1 }
}
EOF
    board_count=$((board_count + 1))
done

echo "  boards: $board_count imagesets written"

# ---------------------------------------------------------------------------
# 4. Piece images (1x / 2x / 3x)
#
# Each piece-set directory under assets/piece_sets/ contains:
#   <piece>.png       — 1x
#   2.0x/<piece>.png  — 2x
#   3.0x/<piece>.png  — 3x
# ---------------------------------------------------------------------------

PIECES_SRC="$PACKAGE/assets/piece_sets"
PIECES=(bB bK bN bP bQ bR wB wK wN wP wQ wR)

set_count=0
for set_dir in "$PIECES_SRC"/*/; do
    set_name=$(basename "$set_dir")
    # Skip piece sets that don't follow the standard <color><Kind>.png layout
    # (e.g. "mono" uses single-letter filenames without a colour prefix).
    if [[ ! -f "$set_dir/bB.png" ]]; then
        echo "  skipping '$set_name' (non-standard layout)"
        continue
    fi
    for piece in "${PIECES[@]}"; do
        dest="$CATALOG/piece_${set_name}_${piece}.imageset"
        mkdir -p "$dest"
        cp "$set_dir/${piece}.png"       "$dest/${piece}.png"
        cp "$set_dir/2.0x/${piece}.png"  "$dest/${piece}@2x.png"
        cp "$set_dir/3.0x/${piece}.png"  "$dest/${piece}@3x.png"
        cat > "$dest/Contents.json" <<EOF
{
  "images" : [
    { "filename" : "${piece}.png",    "idiom" : "universal", "scale" : "1x" },
    { "filename" : "${piece}@2x.png", "idiom" : "universal", "scale" : "2x" },
    { "filename" : "${piece}@3x.png", "idiom" : "universal", "scale" : "3x" }
  ],
  "info" : { "author" : "xcode", "version" : 1 }
}
EOF
    done
    set_count=$((set_count + 1))
done

echo "  pieces: $set_count sets × ${#PIECES[@]} pieces = $(( set_count * ${#PIECES[@]} )) imagesets written"
echo "Done."

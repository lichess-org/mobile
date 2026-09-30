#!/usr/bin/env bash
#
# Builds the app's practice engine — Stockfish 19 with the small embedded network, the
# `multistockfish_light` flavour — as a host UCI binary, for scripts/practice_engine_check.
#
# The sources come from a local checkout of the plugin rather than from the pub cache, because the
# native code is not published with the Dart package. Point MULTISTOCKFISH at it if it is not
# beside this repository:
#
#   MULTISTOCKFISH=~/dev/dart-multistockfish scripts/practice_engine_check/build_engine.sh
#
# Objects are cached under .cache/practice_engine, so a rebuild after pulling upstream Stockfish
# changes only compiles what changed. First build takes a few minutes.

set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
root="$here/../.."
multistockfish="${MULTISTOCKFISH:-}"
for candidate in "$root/../dart-multistockfish" "$HOME/dev/dart-multistockfish"; do
  [ -n "$multistockfish" ] && break
  [ -d "$candidate" ] && multistockfish="$candidate"
done
if [ ! -d "${multistockfish:-}" ]; then
  echo "dart-multistockfish not found; set MULTISTOCKFISH to its checkout" >&2
  exit 1
fi

light="$multistockfish/pkgs/multistockfish_light/ios/multistockfish_light/Sources/multistockfish_light"
if [ ! -d "$light/StockfishLight/src" ]; then
  echo "No Stockfish sources under $light" >&2
  exit 1
fi

out="$root/.cache/practice_engine"
mkdir -p "$out/obj"
CXX="${CXX:-clang++}"
# The flags the plugin builds with, minus the platform ones: -O3 because this build is measured for
# how deep it gets, and the shipped Release builds are optimised too.
flags=(-std=c++17 -O3 -DUSE_PTHREADS -DIS_64BIT -DUSE_POPCNT -DNDEBUG -Wno-writable-strings -c)

# Upstream's own main.cpp is left out: the plugin has its own entry point, and uci_bridge.cpp is
# the one here. src/universal is excluded for the same reason the shipped builds exclude it — those
# files belong to upstream's macOS universal-binary build and do not link into a normal one.
sources=("$light/sfio.cpp" "$light/stockfish_light.cpp")
while IFS= read -r file; do sources+=("$file"); done < <(
  find "$light/StockfishLight/src" -name '*.cpp' ! -name 'main.cpp' -not -path '*/universal/*'
)

built=0
for file in "${sources[@]}"; do
  object="$out/obj/$(echo "${file#"$light"/}" | tr / _).o"
  if [ ! -f "$object" ] || [ "$file" -nt "$object" ]; then
    "$CXX" "${flags[@]}" \
      -I"$light" -I"$light/StockfishLight/src" -I"$light/include/multistockfish_light" \
      -I"$light/nnue" -o "$object" "$file" &
    built=$((built + 1))
    # A few at a time: each translation unit of Stockfish is a big compile.
    if [ $((built % 8)) -eq 0 ]; then wait; fi
  fi
done
wait
echo "Compiled $built file(s)."

"$CXX" -std=c++17 -O3 -o "$out/stockfish-light" "$here/uci_bridge.cpp" "$out"/obj/*.o
echo "Built $out/stockfish-light"

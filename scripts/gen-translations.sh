#!/usr/bin/env bash
set -euo pipefail

SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

"$SCRIPTS_DIR/gen-arb.mjs"
flutter gen-l10n
node "$SCRIPTS_DIR/gen-widget-strings.mjs"

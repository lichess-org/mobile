#!/usr/bin/env node
/**
 * Generates ios/LichessWidgets/Localizable.xcstrings from the app's ARB translation files.
 *
 * Run from the repo root:
 *   node scripts/gen-widget-strings.mjs
 *
 * The output is a String Catalog (Xcode 15+) containing all widget UI strings.
 * Xcode picks it up automatically via the fileSystemSynchronizedRootGroup.
 *
 * To add a new string:
 *   1. Add the ARB key to WIDGET_KEYS below with its default English value.
 *   2. Re-run this script.
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const ROOT = path.resolve(__dirname, '..');
const L10N_DIR = path.join(ROOT, 'lib', 'l10n');
const OUT_FILE = path.join(ROOT, 'ios', 'LichessWidgets', 'Localizable.xcstrings');

// Map each widget UI string to its ARB key and English fallback.
const WIDGET_KEYS = {
  'Daily Puzzle': { arbKey: 'puzzleDailyPuzzle', fallback: 'Daily Puzzle' },
};

// ARB locale codes use '_', iOS uses '-' for subtags.
function arbToIosLocale(arb) {
  return arb.replace(/_/g, '-');
}

// Collect all ARB files (skip en_US which duplicates en).
const arbFiles = fs
  .readdirSync(L10N_DIR)
  .filter((f) => f.startsWith('app_') && f.endsWith('.arb') && f !== 'app_en_US.arb')
  .map((f) => ({ file: f, locale: arbToIosLocale(f.replace(/^app_/, '').replace(/\.arb$/, '')) }));

// Build the strings dictionary.
const strings = {};

for (const [uiString, { arbKey, fallback }] of Object.entries(WIDGET_KEYS)) {
  const localizations = {};

  for (const { file, locale } of arbFiles) {
    const arb = JSON.parse(fs.readFileSync(path.join(L10N_DIR, file), 'utf8'));
    const value = arb[arbKey];
    if (value && value !== fallback || locale === 'en') {
      localizations[locale] = {
        stringUnit: {
          state: 'translated',
          value: value ?? fallback,
        },
      };
    }
  }

  strings[uiString] = {
    extractionState: 'manual',
    localizations,
  };
}

const catalog = {
  sourceLanguage: 'en',
  strings,
  version: '1.0',
};

fs.writeFileSync(OUT_FILE, JSON.stringify(catalog, null, 2) + '\n');
console.log(`Written: ${path.relative(ROOT, OUT_FILE)}`);
console.log(`  Strings: ${Object.keys(strings).length}`);
console.log(`  Locales: ${arbFiles.length}`);

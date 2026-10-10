#!/usr/bin/env node
/**
 * Generates ios/LichessWidgets/Localizable.xcstrings from the app's ARB translation files.
 *
 * Run from the repo root:
 *   node scripts/gen-widget-strings.mjs
 *
 * The output is a String Catalog (Xcode 15+) containing all widget UI strings.
 * Xcode picks it up automatically via the fileSystemSynchronizedRootGroup. The Runner target is a
 * member too, for the Live Activity alerts and notifications sent by LiveActivityPlugin.swift.
 *
 * Only the WIDGET_KEYS entries are generated: the strings Xcode extracts from the Swift sources
 * are kept as they are, and the file is written in Xcode's format so that neither tool rewrites
 * what the other one wrote.
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
// Set `param: true` for strings with a single %@ placeholder (ARB uses {param}).
const WIDGET_KEYS = {
  'Daily Puzzle': { arbKey: 'puzzleDailyPuzzle', fallback: 'Daily Puzzle' },
  'Community': { arbKey: 'ublogCommunity', fallback: 'Community' },
  // SwiftUI Text("xBlog \(name)") looks up the key "xBlog %@" at runtime.
  'xBlog %@': { arbKey: 'ublogXBlog', fallback: "%@'s Blog", param: true },
  'Broadcasts': { arbKey: 'broadcastBroadcasts', fallback: 'Broadcasts' },
  'Your turn': { arbKey: 'yourTurn', fallback: 'Your turn' },
  'Waiting for opponent': { arbKey: 'waitingForOpponent', fallback: 'Waiting for opponent' },
  'Reconnecting': { arbKey: 'reconnecting', fallback: 'Reconnecting' },
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

// Start from the existing catalog to keep the strings extracted by Xcode.
const strings = fs.existsSync(OUT_FILE)
  ? JSON.parse(fs.readFileSync(OUT_FILE, 'utf8')).strings
  : {};

for (const [uiString, { arbKey, fallback, param = false }] of Object.entries(WIDGET_KEYS)) {
  const localizations = {};

  for (const { file, locale } of arbFiles) {
    const arb = JSON.parse(fs.readFileSync(path.join(L10N_DIR, file), 'utf8'));
    let value = arb[arbKey];
    if (value == null && locale !== 'en') continue;
    // ARB uses {param} for placeholders; xcstrings/Swift uses %@.
    if (param && value) value = value.replace(/\{param\}/g, '%@');
    const resolved = value ?? fallback;
    if (resolved !== fallback || locale === 'en') {
      localizations[locale] = {
        stringUnit: { state: 'translated', value: resolved },
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

// Xcode sorts keys case-insensitively, writes `"key" : value` and puts a blank line in `{}`.
function sortKeys(value) {
  if (Array.isArray(value)) return value.map(sortKeys);
  if (value === null || typeof value !== 'object') return value;
  return Object.fromEntries(
    Object.keys(value)
      .sort((a, b) => a.localeCompare(b, 'en', { sensitivity: 'base' }) || (a < b ? -1 : 1))
      .map((k) => [k, sortKeys(value[k])]),
  );
}

const json = JSON.stringify(sortKeys(catalog), null, 2)
  .replace(/^(\s*"(?:[^"\\]|\\.)*"):/gm, '$1 :')
  .replace(/^(\s*)(.*)\{\}/gm, '$1$2{\n\n$1}');
fs.writeFileSync(OUT_FILE, json);
console.log(`Written: ${path.relative(ROOT, OUT_FILE)}`);
console.log(`  Strings: ${Object.keys(strings).length}`);
console.log(`  Locales: ${arbFiles.length}`);

#!/usr/bin/env node
/**
 * Generates widget UI strings for both platforms from the app's ARB translation files:
 *   - ios/LichessWidgets/Localizable.xcstrings (Xcode String Catalog)
 *   - android/app/src/main/res/values/strings.xml (default/English strings)
 *   - android/app/src/main/res/values-b+<locale>/strings.xml (per-locale translations)
 *
 * Run from the repo root:
 *   node scripts/gen-widget-strings.mjs
 *
 * Xcode picks up Localizable.xcstrings automatically via the fileSystemSynchronizedRootGroup.
 * values/strings.xml is generated too — never edit it by hand, any change will be
 * overwritten the next time this script runs.
 *
 * To add a new translatable string:
 *   1. Add the ARB key to WIDGET_KEYS below with its default English value.
 *      Add `androidName: 'your_resource_name'` too if Android should use it.
 *   2. Re-run this script.
 *
 * To add an Android-only string with no translation yet:
 *   1. Add it to UNTRANSLATED_ANDROID_STRINGS below with its hardcoded English value.
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
  'Daily Puzzle': { arbKey: 'puzzleDailyPuzzle', fallback: 'Daily Puzzle', androidName: 'widget_daily_puzzle_title' },
  'Community': { arbKey: 'ublogCommunity', fallback: 'Community'},
  // SwiftUI Text("xBlog \(name)") looks up the key "xBlog %@" at runtime.
  'xBlog %@': { arbKey: 'ublogXBlog', fallback: "%@'s Blog", param: true },
  'Broadcasts': { arbKey: 'broadcastBroadcasts', fallback: 'Broadcasts', androidName: 'widget_broadcast_title' },
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


const UNTRANSLATED_ANDROID_STRINGS = {
  widget_broadcast_description: 'Shows ongoing and upcoming chess broadcasts.',
  widget_live: 'LIVE',
  widget_no_broadcasts: 'No active broadcasts',
  widget_daily_puzzle_description: 'Shows daily puzzle',
  widget_no_dailyPuzzle: 'No New Puzzles',
  widget_daily_puzzle_error: "Couldn't load puzzle",
};

const ANDROID_RES_DIR = path.join(ROOT, 'android', 'app', 'src', 'main', 'res');

function xmlEscape(s) {
  return s.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;')
    .replace(/"/g, '\\"').replace(/'/g, "\\'");
}

function arbToAndroidValue(value, param) {
  return param ? value.replace(/\{param\}/g, '%1$s') : value;
}

const androidLocaleGroups = new Map();

for (const { file } of arbFiles) {
  const arbLocale = file.replace(/^app_/, '').replace(/\.arb$/, '');
  if (arbLocale === 'en') continue;
  const qualifier = `b+${arbLocale.replace(/_/g, '+')}`;
  const arb = JSON.parse(fs.readFileSync(path.join(L10N_DIR, file), 'utf8'));

  for (const [, { arbKey, fallback, param = false, androidName }] of Object.entries(WIDGET_KEYS)) {
    if (!androidName) continue;
    const raw = arb[arbKey];
    if (raw == null || raw === fallback) continue;
    const value = arbToAndroidValue(raw, param);
    if (!androidLocaleGroups.has(qualifier)) androidLocaleGroups.set(qualifier, {});
    androidLocaleGroups.get(qualifier)[androidName] = value;
  }
}

for (const [qualifier, entries] of androidLocaleGroups) {
  const dir = path.join(ANDROID_RES_DIR, `values-${qualifier}`);
  fs.mkdirSync(dir, { recursive: true });
  const body = Object.entries(entries)
    .map(([name, value]) => `    <string name="${name}">${xmlEscape(value)}</string>`)
    .join('\n');
  fs.writeFileSync(
    path.join(dir, 'strings.xml'),
    `<?xml version="1.0" encoding="utf-8"?>\n<resources>\n${body}\n</resources>\n`
  );
}
console.log(`  Android locales: ${androidLocaleGroups.size}`);


const DEFAULT_STRINGS_FILE = path.join(ANDROID_RES_DIR, 'values', 'strings.xml');
const enArb = JSON.parse(fs.readFileSync(path.join(L10N_DIR, 'app_en.arb'), 'utf8'));
const defaultEntries = [];

for (const [, { arbKey, fallback, param = false, androidName }] of Object.entries(WIDGET_KEYS)) {
  if (!androidName) continue;
  let value = enArb[arbKey] ?? fallback;
  if (param) value = value.replace(/\{param\}/g, '%1$s');
  defaultEntries.push(`    <string name="${androidName}">${xmlEscape(value)}</string>`);
}

for (const [name, value] of Object.entries(UNTRANSLATED_ANDROID_STRINGS)) {
  defaultEntries.push(`    <string name="${name}">${xmlEscape(value)}</string>`);
}

fs.writeFileSync(
  DEFAULT_STRINGS_FILE,
  '<?xml version="1.0" encoding="utf-8"?>\n' +
  '<!-- GENERATED FILE. Do not edit by hand — run scripts/gen-widget-strings.mjs instead. -->\n' +
  '<resources>\n' +
  defaultEntries.join('\n') + '\n' +
  '</resources>\n'
);
console.log(`  Default strings: ${defaultEntries.length}`);
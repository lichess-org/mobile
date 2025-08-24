#!/usr/bin/env node

import { readFileSync, writeFileSync, existsSync } from 'fs'
import { readdir, unlink } from 'node:fs/promises';
import colors from 'colors/safe.js'
import { parseStringPromise } from 'xml2js'
import { dirname, basename, extname, join } from 'path'
import { fileURLToPath } from 'url'

const __dirname = dirname(fileURLToPath(import.meta.url))

const destDir = `${__dirname}/../lib/l10n`

const sourcePath = `${__dirname}/../translation/source`
const translationPath = `${__dirname}/../translation/dest`

// selection of translation modules to include
const modules = [
  // mobile is the only module managed by this project (of which we can edit the source)
  'mobile',
  // below are modules from lichess/lila
  'activity',
  'arena',
  'broadcast',
  'challenge',
  'contact',
  'coordinates',
  'patron',
  'perfStat',
  'preferences',
  'puzzle',
  'puzzleTheme',
  'search',
  'settings',
  'site',
  'storm',
  'streamer',
  'study',
  'timeago',
]

// list of keys (per module) to include in the ARB file
// If a module is not listed here, all keys will be included
const whiteLists = {
  'patron': ['donate', 'lichessPatron', 'becomePatron'],
  'contact': ['contact', 'contactLichess'],
  'search': ['search'],
  'streamer': ['lichessStreamers'],
}

// Order of locales with variants matters: the fallback must always be first
// eg: 'pt-PT' is before 'pt-BR'
// Note that 'en-GB' is omitted here on purpose because it is the locale used in template ARB.
const locales = [
  'af-ZA',
  'ar-SA',
  'az-AZ',
  'be-BY',
  'bg-BG',
  'bn-BD',
  'bs-BA',
  'ca-ES',
  'cs-CZ',
  'da-DK',
  'de-DE',
  'el-GR',
  'en-US',
  'eo-AA',
  'es-ES',
  'et-EE',
  'eu-ES',
  'fa-IR',
  'fi-FI',
  'fr-FR',
  'gl-ES',
  'gsw-CH',
  'he-IL',
  'hi-IN',
  'hr-HR',
  'hu-HU',
  'hy-AM',
  'id-ID',
  'it-IT',
  'ja-JP',
  'kk-KZ',
  'ko-KR',
  'lt-LT',
  'lv-LV',
  'mk-MK',
  'nb-NO',
  'nl-NL',
  'pl-PL',
  'pt-PT',
  'pt-BR',
  'ro-RO',
  'ru-RU',
  'sk-SK',
  'sl-SI',
  'sq-AL',
  'sr-SP',
  'sv-SE',
  'tr-TR',
  'uk-UA',
  'vi-VN',
  'zh-CN',
  'zh-TW',
]

async function main() {
  await generateTemplateARB()

  await generateTranslationARB()
}

main()

// --

async function generateTranslationARB() {
  // load all translations into a single object
  const translations = {}
  for (const module of modules) {
    const xml = await loadXml(locales, module)
    for (const locale in xml) {
      try {
        const trans = transformTranslations(xml[locale], locale, module)
        translations[locale] = {
          ...translations[locale],
          ...trans
        }
      } catch (e) {
        console.error(e)
      }
    }
  }

  // remove all existing translations files, because the write logic needs it
  for (const file of await readdir(destDir)) {
    if (basename(file) !== 'app_en.arb' && extname(file) === '.arb') {
      await unlink(join(destDir, file))
    }
  }

  // write translations, one file per locale
  Object.keys(translations).forEach(locale => {
    const parts = locale.split('-')
    const lang = parts[0]
    const country = parts[1]
    const file = `${destDir}/app_${lang}.arb`
    try {
      // the lang already exists, it means the locale is a variant, we'll specify the country code
      // en-US is an exception because en-GB is the template file
      if (existsSync(file) || locale === 'en-US') {
        writeTranslations(`${destDir}/app_${lang}_${country}.arb`, translations[locale])
      } else {
        writeTranslations(file, translations[locale])
      }
    } catch (e) {
      console.error(e)
      console.error(colors.red(`Could not write translations for ${colors.bold(locale)}, skipping...`))
    }
  })
}

async function generateTemplateARB() {
  // load en-GB and make ARB template file
  console.log(colors.blue('Writing template file...'))
  const template = {}
  for (const module of modules) {
    const xml = await loadXml(['en-GB'], module)
    for (const locale in xml) {
      const trans = transformTranslations(xml[locale], locale, module, true)
      template[locale] = {
        ...template[locale],
        ...trans
      }
    }
  }
  writeTranslations(`${destDir}/app_en.arb`, template['en-GB']);
  console.log(colors.green('   Template file successfully written.'))
}

function loadTranslations(module, locale) {
  if (locale === 'en-GB')
    return parseStringPromise(
      readFileSync(`${sourcePath}/${module}.xml`)
    )
  else
    return parseStringPromise(
      readFileSync(`${translationPath}/${module}/${locale}.xml`)
    )
}

// in lila strings a percent sign is escaped with a double percent sign
function unescape(str) {
  return str.replace(/\\"/g, '"').replace(/\\'/g, '\'').replace(/%%/g, '%')
}

function fixKey(str, module) {
  const fixed = str.replace(/\./g, '_')
  if (module !== 'site') {
    return module + capitalize(fixed)
  }
  return fixed
}

function capitalize(string) {
  return string.charAt(0).toUpperCase() + string.slice(1);
}

function transformTranslations(data, locale, module, makeTemplate = false) {
  if (!(data && data.resources && data.resources.string)) {
    throw `Missing translations in module ${module} and locale ${locale}`
  }

  if (whiteLists[module]) {
    const whiteList = whiteLists[module]
    const filtered = data.resources.string.filter((stringElement) => whiteList.includes(stringElement.$.name))
    data.resources.string = filtered

    const pluralFiltered = data.resources.plurals?.filter((plural) => whiteList.includes(plural.$.name))
    data.resources.plurals = pluralFiltered
  }

  const transformed = {}

  for (const stringElement of data.resources.string) {
    const string = unescape(stringElement._)
    const transKey = fixKey(stringElement.$.name, module)
    if (RegExp('%s', 'g').test(string)) {
      transformed[transKey] = string.replace(/%s/g, '{param}')
      if (makeTemplate) {
        transformed[`@${transKey}`] = {
          placeholders: {
            param: {
              type: 'String'
            }
          }
        }
      }
    } else if (/%\d\$s/.test(string)) {
      transformed[transKey] = string
      const regexp = /%(\d)\$s/g
      let result
      const params = []
      while ((result = regexp.exec(string)) !== null) {
        const param = `param${result[1]}`
        params.push(param)
        transformed[transKey] = transformed[transKey].replace(result[0], `{${param}}`)
      }
      if (makeTemplate) {
        const placeholders = {}
        for (const param of params) {
          placeholders[param] = { type: 'String' }
        }
        transformed[`@${transKey}`] = { placeholders }
      }
    } else {
      transformed[transKey] = string
    }
  }

  for (const plural of (data.resources.plurals || [])) {
    const placeholders = {
      count: { type: 'int' }
    };
    let pluralString = '{count, plural,'

    plural.item.forEach((child) => {
      const string = unescape(child._);
      let transformedString;
      if (RegExp('%s', 'g').test(string)) {
        transformedString = string.replace(/%s/g, '{count}')
      } else if (/%\d\$s/.test(string)) {
        transformedString = string.replace(/%1\$s/g, '{count}')
        const regexp = /%(\d)\$s/g
        let result
        const params = []
        while ((result = regexp.exec(string)) !== null) {
          if (result[1] == '1') continue;
          const param = `param${result[1]}`
          params.push(param)
          transformedString = transformedString.replace(result[0], `{${param}}`)
        }
        if (makeTemplate) {
          for (const param of params) {
            placeholders[param] = { type: 'String' }
          }
        }
      } else {
        transformedString = string;
      }
      const quantity = child.$.quantity === 'zero' ? '=0' :
      child.$.quantity === 'one' ? '=1' :
      child.$.quantity === 'two' ? '=2' :
      child.$.quantity
      pluralString += ` ${quantity}{${transformedString}}`
    })
    pluralString += '}'
    const transKey = fixKey(plural.$.name, module)
    transformed[transKey] = pluralString
    if (makeTemplate) {
      transformed[`@${transKey}`] = { placeholders }
    }
  }

  return transformed
}

function writeTranslations(where, data) {
  console.log(colors.blue(`Writing to ${where}`))
  writeFileSync(where, JSON.stringify(data, null, 2))
}

async function loadXml(localesToLoad, module) {
  const sectionXml = {}
  for (const locale of localesToLoad) {
    console.log(colors.blue(`Loading translations for ${colors.bold(locale)}...`))
    try {
      sectionXml[locale] = await loadTranslations(module, locale)
    } catch (_) {
      console.warn(colors.yellow(`Could not load ${module} translations for locale: ${locale}`))
    }
  }
  return sectionXml
}

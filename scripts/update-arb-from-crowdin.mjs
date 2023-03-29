#!/usr/bin/env node

import { readFileSync, createWriteStream, writeFileSync, mkdirSync, existsSync } from 'fs'
import { readdir, unlink } from 'node:fs/promises';
import { pipeline } from 'stream'
import { promisify } from 'util'
import { exec } from 'child_process'
import colors from 'colors/safe.js'
import { parseStringPromise } from 'xml2js'
import fetch from 'node-fetch'
import { request as octokitRequest } from '@octokit/request'
import { dirname, basename, extname, join } from 'path'
import { fileURLToPath } from 'url'

const __dirname = dirname(fileURLToPath(import.meta.url))

const tmpDir = `${__dirname}/tmp/translations`
const destDir = `${__dirname}/../lib/l10n`
const lilaSourcePath = `${tmpDir}/source`
const lilaTranslationsPath = `${tmpDir}/[lichess-org.lila] master/translation/dest`
const unzipMaxBufferSize = 1024 * 1024 * 10 // Set maxbuffer to 10MB to avoid errors when default 1MB used

// selection of lila translation modules to include
const modules = ['site', 'puzzle', 'puzzleTheme', 'perfStat', 'settings', 'streamer']

// Order of locales with variants matters: the fallback must always be first
// eg: 'de-DE' is before 'de-CH'
// Note that 'en-GB' is omitted here on purpose because it is the locale used in template ARB.
// This list must be consistent with the `kSupportedLocales` constant defined in `lib/constants.dart`.
const locales = ['af-ZA', 'ar-SA', 'az-AZ', 'be-BY', 'bg-BG', 'bn-BD', 'br-FR', 'bs-BA', 'ca-ES', 'cs-CZ', 'da-DK', 'de-DE', 'de-CH', 'el-GR', 'en-US', 'eo-UY', 'es-ES', 'et-EE', 'eu-ES', 'fa-IR', 'fi-FI', 'fo-FO', 'fr-FR', 'ga-IE', 'gl-ES', 'he-IL', 'hi-IN', 'hr-HR', 'hu-HU', 'hy-AM', 'id-ID', 'it-IT', 'ja-JP', 'kk-KZ', 'ko-KR', 'lb-LU', 'lt-LT', 'lv-LV', 'mk-MK', 'nb-NO', 'nl-NL', 'nn-NO', 'pl-PL', 'pt-PT', 'pt-BR', 'ro-RO', 'ru-RU', 'sk-SK', 'sl-SI', 'sq-AL', 'sr-SP', 'sv-SE', 'tr-TR', 'tt-RU', 'uk-UA', 'vi-VN', 'zh-CN', 'zh-TW']

async function main() {
  mkdirSync(`${tmpDir}`, {recursive: true})

  await generateTemplateARB()

  await generateLilaTranslationARBs()
}

main()

// --

async function generateLilaTranslationARBs() {
  // Download translations zip from crowdin
  const zipFile = createWriteStream(`${tmpDir}/out.zip`)
  await downloadTranslationsTo(zipFile)
  await unzipTranslations(`${tmpDir}/out.zip`)

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
    const file = `${destDir}/lila_${lang}.arb`
    try {
      // the lang already exists, it means the locale is a variant, we'll specify the country code
      // en-US is an exception because en-GB is the template file
      if (existsSync(file) || locale === 'en-US') {
        writeTranslations(`${destDir}/lila_${lang}_${country}.arb`, translations[locale])
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
  // Download source translations (en-GB) from lila repo
  await downloadLilaSourcesTo(tmpDir)

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

async function downloadTranslationsTo(zipFile) {
  console.log(colors.blue('Downloading translations...'))
  const streamPipeline = promisify(pipeline)
  const response = await fetch('https://crowdin.com/backend/download/project/lichess.zip')
  if (!response.ok) throw new Error(`unexpected response ${response.statusText}`)

  await streamPipeline(response.body, zipFile)
  console.log(colors.green('  Download complete.'))
}

async function unzipTranslations(zipFilePath) {
  console.log(colors.blue('Unzipping translations...'))
  return new Promise((resolve, reject) => {
      exec(`unzip -o ${zipFilePath} -d ${tmpDir}`, {maxBuffer: unzipMaxBufferSize}, (err) => {
      if (err) {
        return reject('Unzip failed.')
      }
      resolve()
    })
  })
}

async function downloadLilaSourcesTo(dir) {
  console.log(colors.blue('Downloading lila source translations...'))
  const response = await octokitRequest('GET /repos/{owner}/{repo}/contents/{path}', {
    owner: 'lichess-org',
    repo: 'lila',
    path: 'translation/source'
  })
  if (!existsSync(`${dir}/source`)) mkdirSync(`${dir}/source`)
  for (const entry of response.data) {
    const streamPipeline = promisify(pipeline)
    const response = await fetch(entry.download_url)
    if (!response.ok) throw new Error(`unexpected response ${response.statusText}`)
    await streamPipeline(response.body, createWriteStream(`${dir}/source/${entry.name}`))
  }
  console.log(colors.green('  Download complete.'))
}

function loadTranslations(dir, locale) {
  if (locale === 'en-GB')
    return parseStringPromise(
      readFileSync(`${lilaSourcePath}/${dir}.xml`)
    )
  else
    return parseStringPromise(
      readFileSync(`${lilaTranslationsPath}/${dir}/${locale}.xml`)
    )
}

function unescape(str) {
  return str.replace(/\\"/g, '"').replace(/\\'/g, '\'')
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
    let pluralString = '{count, plural,'
    plural.item.forEach((child) => {
      const childString = unescape(child._).replace(/%s/g, '{count}')
      const quantity = child.$.quantity === 'zero' ? '=0' :
        child.$.quantity === 'one' ? '=1' :
          child.$.quantity === 'two' ? '=2' :
            child.$.quantity
      pluralString += ` ${quantity}{${childString}}`
    })
    pluralString += '}'
    const transKey = fixKey(plural.$.name, module)
    transformed[transKey] = pluralString
    if (makeTemplate) {
      transformed[`@${transKey}`] = {
        placeholders: {
          count: { type: 'int' }
        }
      }
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

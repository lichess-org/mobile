#!/usr/bin/env node

import { readFileSync, createWriteStream, writeFileSync, readdirSync, mkdirSync, existsSync } from 'fs'
import { pipeline } from 'stream'
import { promisify } from 'util'
import { exec } from 'child_process'
import colors from 'colors/safe.js'
import { parseStringPromise } from 'xml2js'
import fetch from 'node-fetch'
import { request as octokitRequest } from '@octokit/request'
import { dirname } from 'path'
import { fileURLToPath } from 'url'

const __dirname = dirname(fileURLToPath(import.meta.url))

const tmpDir = `${__dirname}/tmp/translations`
const destDir = `${__dirname}/../lib/l10n`
const lilaSourcePath = `${tmpDir}/source`
const lilaTranslationsPath = `${tmpDir}/[ornicar.lila] master/translation/dest`
const unzipMaxBufferSize = 1024 * 1024 * 10 // Set maxbuffer to 10MB to avoid errors when default 1MB used

const modules = ['puzzle']

async function main() {
  mkdirSync(`${tmpDir}`, {recursive: true})

  // Download translations zip from crowdin
  // const zipFile = createWriteStream(`${tmpDir}/out.zip`)
  // await downloadTranslationsTo(zipFile)
  // await unzipTranslations(`${tmpDir}/out.zip`)

  // Download source translations (en-GB) from lila repo
  await downloadLilaSourcesTo(tmpDir)

  // load en-GB and make ARB template file
  console.log(colors.blue('Writing template file...'))
  const template = {}
  for (const module of modules) {
    const xml = await loadXml(['en-GB'], module)
    for (const locale in xml) {
      const trans = transformTranslationsForTemplate(xml[locale], locale, module)
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

function transformTranslationsForTemplate(data, locale, module) {
  console.log(colors.blue(`Transforming translations for ${colors.bold(locale)}...`))
  const transformed = {}

  if (!(data && data.resources && data.resources.string)) {
    throw `Missing translations in module ${module} and locale ${locale}`
  }

  for (const stringElement of data.resources.string) {
    const string = unescape(stringElement._)
    if (RegExp('%s', 'g').test(string)) {
      transformed[stringElement.$.name] = string.replace(/%s/g, '{param}')
      transformed[`@${stringElement.$.name}`] = {
        placeholders: {
          param: {
            type: 'String'
          }
        }
      }
    } else if (/%\d\$s/.test(string)) {
      transformed[stringElement.$.name] = string
      const regexp = /%(\d)\$s/g
      let result
      const params = []
      while ((result = regexp.exec(string)) !== null) {
        const param = `param${result[1]}`
        params.push(param)
        transformed[stringElement.$.name] = transformed[stringElement.$.name].replace(result[0], `{${param}}`)
      }
      const placeholders = {}
      for (const param of params) {
        placeholders[param] = { type: 'String' }
      }
      transformed[`@${stringElement.$.name}`] = { placeholders }
    } else {
      transformed[stringElement.$.name] = string
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
    transformed[plural.$.name] = pluralString
    transformed[`@${plural.$.name}`] = {
      placeholders: {
        count: { type: 'int' }
      }
    }
  }

  return transformed
}

function writeTranslations(where, data) {
  console.log(colors.blue(`Writing to ${where}`))
  writeFileSync(where, JSON.stringify(data, null, 2))
}

async function loadXml(locales, module) {
  const sectionXml = {}
  for (const locale of locales) {
    console.log(colors.blue(`Loading translations for ${colors.bold(locale)}...`))
    try {
      sectionXml[locale] = await loadTranslations(module, locale)
    } catch (_) {
      console.warn(colors.yellow(`Could not load ${module} translations for locale: ${locale}`))
    }
  }
  return sectionXml
}

main()

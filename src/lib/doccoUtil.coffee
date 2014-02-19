{fileUtil} = require '../lib/fileUtil'
docco = require "docco"
_ = require "lodash"
path = require 'path'
fs = require 'fs-extra'

DOCCO_STYLE = 'parallel'

languages = fs.readJsonSync(path.join('node_modules', 'docco',
  'resources', 'languages.json'))

template = _.template fs.readFileSync(path.join('node_modules', 'docco',
  'resources', DOCCO_STYLE, 'docco.jst')).toString()

sources = []

doccoFile = (fileName, fileContents, basedir, baseOutput) ->
  output = baseOutput
  css = "test.css"
  config = {languages, template, output, css, sources}
  sections = docco.parse fileName, fileContents, config
  docco.format fileName, sections, config
  docco.write fileName, sections, config

_.extend exports, {doccoFile}

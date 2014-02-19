{fileUtil} = require '../lib/fileUtil'
docco = require "docco"
_ = require "lodash"
path = require 'path'
fs = require 'fs-extra'

DOCCO_STYLE = 'parallel'

languages = fs.readJsonSync(path.join('node_modules', 'docco',
  'resources', 'languages.json'))

jstTemplate = _.template fs.readFileSync(path.join('node_modules', 'docco',
      'resources', DOCCO_STYLE, 'docco.jst')).toString()

sources = []

doccoFile = (fileName, fileContents, baseOutput) ->
  output = path.join(baseOutput, path.dirname(fileName))
  source = path.basename(fileName)
  fs.mkdirsSync output
  css = path.relative fileName, "docco.css"
  template = (templateArgs) ->
    templateArgs.css = css
    jstTemplate templateArgs

  config = {languages, template, output, css, sources}
  sections = docco.parse source, fileContents, config
  docco.format source, sections, config
  docco.write source, sections, config

_.extend exports, {doccoFile}

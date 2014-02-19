{fileUtil} = require '../lib/fileUtil'
docco = require "docco-with-write-function"
_ = require "lodash"
path = require 'path'
fs = require 'fs-extra'

DOCCO_STYLE = 'parallel'
DOCCO_MODULE =  "docco-with-write-function"
resourcesDir = path.join __dirname, "../../node_modules", DOCCO_MODULE,
  'resources'
styleDir = path.join resourcesDir, DOCCO_STYLE

languages = fs.readJsonSync(path.join(resourcesDir, 'languages.json'))
languages = docco.buildMatchers languages

jstTemplate = _.template fs.readFileSync(path.join(styleDir, 'docco.jst')).toString()

sources = []

doccoFile = (fileName, fileContents, baseOutput) ->
  output = path.join(baseOutput, path.dirname(fileName))
  source = path.basename(fileName)
  fs.mkdirsSync output
  css = path.relative(path.join(baseOutput, fileName, "../"),
    path.join(baseOutput, "docco.css"))

  template = (templateArgs) ->
    templateArgs.css = css
    jstTemplate templateArgs

  config = {languages, template, output, css, sources}
  sections = docco.parse source, fileContents, config
  docco.format source, sections, config
  docco.write source, sections, config

_.extend exports, {doccoFile, styleDir}

docco = require "docco"
_ = require "lodash"
path = require 'path'
fs = require 'fs-extra'

languages = path.join(__dirname, 'node_modules', 'docco', 'resources', 'languages.json')

doccoFile = (fileName, fileContents, baseDir) ->
  config = {}
  config.languages = languages
  docco.parse fileName, fileContents, config

_.extend exports, {doccoFile}

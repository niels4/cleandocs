{fileUtil} = require './fileUtil'

getOptions = ->
  docSuffix: ".md"
  docDirectory: "test-fixtures/fileUtil/app/docs"
  docTagStart: '#*c:'
  docTagEnd: '*'
  srcSuffix: ".coffee"
  srcDirectory: "test-fixtures/fileUtil/app/scripts"
  srcTagStart: '#*c:'
  srcTagEnd: '*'
  outputSuffix: ".md"


processAllFiles = (options) ->
  console.log "processing all #{options.docSuffix} files in directory #{options.docDirectory}"
  docFiles = fileUtil.findFilesWithSuffix options.docDirectory, options.docSuffix

main = ->
  processAllFiles getOptions()

exports.main = main

{fileUtil} = require './fileUtil'

getOptions = ->
  docSuffix: ".md"
  docDirectory: "test-fixtures/fileUtil/app/docs"
  srcDirectory: "test-fixtures/fileUtil/app/scripts"

processAllFiles = (options) ->
  console.log "processing all #{options.docSuffix} files in directory #{options.docDirectory}"
  docFiles = fileUtil.findFilesWithSuffix options.docDirectory, options.docSuffix

main = ->
  processAllFiles getOptions()

exports.main = main

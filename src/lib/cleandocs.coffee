{fileUtil} = require './fileUtil'

getOptions = ->
  docSuffix: "md"
  docDirectory: "test-fixtures/findAllDocFiles/app/docs"

processAllFiles = (options) ->
  console.log "processing all #{options.docSuffix} files in directory #{options.docDirectory}"
  docFiles = fileUtil.findFilesWithSuffix options.docDirectory, options.docSuffix

main = ->
  processAllFiles getOptions()

exports.main = main

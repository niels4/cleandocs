{fileUtil} = require './fileUtil'
{DocMerger} = require '../lib/DocMerger.js'
_ = require 'lodash'

getOptions = ->
  docSuffix: ".md"
  docDir: "test-fixtures/fileUtil/app/docs"
  docTagStart: '#*c:'
  docTagEnd: '*'
  srcSuffix: ".coffee"
  srcDir: "test-fixtures/fileUtil/app/scripts"
  srcTagStart: '#*c:'
  srcTagEnd: '*'
  outputSuffix: ".md"
  outputDir: 'out/docs'
  defaultTagOrder: ['untagged', 'description']

mergeAndWriteAllFiles = (pairedFiles, options) ->
  {docDir, docSuffix, docTagStart, docTagEnd,
    srcDir, srcSuffix, srcTagStart, srcTagEnd,
    outputDir, outputSuffix, defaultTagOrder} = options
  fileUtil.cleanDirectory outputDir
  _.each pairedFiles, (docFile, docFileName) ->
    if docFile.srcFile
      srcFileName = fileUtil.swapSuffixes docSuffix, srcSuffix, docFileName
      docLines = fileUtil.getFileLines docDir, docFileName
      srcLines = fileUtil.getFileLines srcDir, srcFileName
      mergedFile = DocMerger.mergeDocFiles
        docTagStart: docTagStart
        docTagEnd: docTagEnd
        srcTagStart: srcTagStart
        srcTagEnd: srcTagEnd
        defaultTagOrder: defaultTagOrder
        docLines: docLines
        srcLines: srcLines
      outFileName = fileUtil.swapSuffixes docSuffix, outputSuffix, docFileName
      fileUtil.saveFile outputDir, outFileName, mergedFile
    else
      fileUtil.swapSuffixAndCopy docSuffix, outputSuffix, docDir, outputDir, docFileName

processAllFiles = (options) ->
  console.log "processing all #{options.docSuffix} files in directory #{options.docDir}"
  docFiles = fileUtil.findFilesWithSuffix options.docDir, options.docSuffix
  pairedFiles = fileUtil.pairSourceFiles options.srcDir, options.srcSuffix, options.docSuffix, docFiles

main = ->
  processAllFiles getOptions()

exports.main = main
exports.mergeAndWriteAllFiles = mergeAndWriteAllFiles

{fileUtil} = require './fileUtil'
path = require "path"
{DocMerger} = require './DocMerger'
doccoUtil = require './doccoUtil'
_ = require 'lodash'

doccoCssDir = "node_modules/docco/resources/parallel"
doccoCssFile = "docco.css"
doccoPublicDir = "public"

readOptionsFile = ->
  fileUtil.readJson 'cleandocs.json'

processOptionsFile = (optionsFile) ->
  _.map optionsFile.dirs, (nextDirs) ->
    nextOptions = _.pick optionsFile, 'docSuffix', 'docTagStart', 'docTagEnd',
      'srcSuffix', 'srcTagStart', 'srcTagEnd', 'outputSuffix',
      'defaultTagOrder'
    nextOptions.docDir = nextDirs.docs
    nextOptions.srcDir = nextDirs.src
    nextOptions.outputDir = nextDirs.output
    nextOptions

getOptions = ->
  processOptionsFile readOptionsFile()

mergeAndWriteAllFiles = (pairedFiles, options) ->
  {docDir, docSuffix, docTagStart, docTagEnd, srcDir, srcSuffix, srcTagStart,
    srcTagEnd, outputDir, outputSuffix, defaultTagOrder, docco} = options


  fileUtil.cleanDirectory outputDir

  if docco
    fileUtil.copyFile doccoCssDir, doccoCssFile, options.outputDir
    fileUtil.copyFile doccoCssDir, doccoPublicDir, options.outputDir

  _.each pairedFiles, (docFile, docFileName) ->
    docLines = fileUtil.getFileLines docDir, docFileName
    outFileName = fileUtil.swapSuffixes docSuffix, outputSuffix, docFileName
    if docFile.srcFile
      srcFileName = fileUtil.swapSuffixes docSuffix, srcSuffix, docFileName
      srcLines = fileUtil.getFileLines srcDir, srcFileName
      mergedFile = DocMerger.mergeDocFiles
        docTagStart: docTagStart
        docTagEnd: docTagEnd
        srcTagStart: srcTagStart
        srcTagEnd: srcTagEnd
        defaultTagOrder: defaultTagOrder
        docLines: docLines
        srcLines: srcLines
    else
      mergedFile = docLines.join "\n"

    if docco
      doccoUtil.doccoFile outFileName, mergedFile, outputDir

    fileUtil.saveFile outputDir, outFileName, mergedFile

processAllFiles = (options) ->
  console.log "processing all #{options.docSuffix} files in directory #{options.docDir}"
  docFiles = fileUtil.findFilesWithSuffix options.docDir, options.docSuffix
  pairedFiles = fileUtil.pairSourceFiles options.srcDir, options.srcSuffix, options.docSuffix, docFiles
  mergeAndWriteAllFiles pairedFiles, options

processAllDirs = (fileOptions) ->
  _.forEach processOptionsFile(fileOptions), (nextOptions) ->
    processAllFiles nextOptions

main = ->
  processAllDirs readOptionsFile()

exports.main = main
exports.mergeAndWriteAllFiles = mergeAndWriteAllFiles
exports.processOptionsFile = processOptionsFile
exports.processAllDirs = processAllDirs

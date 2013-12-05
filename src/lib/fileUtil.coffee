path = require 'path'
Finder = require 'fs-finder'
_ = require "lodash"
fs = require 'fs'

fileUtil =
  findFilesWithSuffix: (directory, suffix) ->
    files = Finder.from(directory).findFiles "*#{suffix}"
    files.map _.partial(path.relative, directory)

  fileExists: (baseDir, relPath) ->
    try
      fs.lstatSync(path.join baseDir, relPath).isFile()
    catch e
      false
      
  pairSourceFiles: (srcDir, srcSuffix, docSuffix, docFiles) ->
    docFiles.reduce(((acc, docFile)->
      docFilePair = {}
      srcFile = fileUtil.swapSuffixes(docFile, docSuffix,  srcSuffix)
      if fileUtil.fileExists(srcDir, srcFile)
        docFilePair.srcFile = srcFile
      acc[docFile] = docFilePair
      acc
    ), {})

  swapSuffixes: (fileName, oldSuffix, newSuffix) ->
    fileName.substring(0, fileName.length - oldSuffix.length) + newSuffix

exports.fileUtil = fileUtil

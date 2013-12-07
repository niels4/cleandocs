path = require 'path'
Finder = require 'fs-finder'
_ = require "lodash"
fs = require 'fs-extra'

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
      srcFile = fileUtil.swapSuffixes(docSuffix,  srcSuffix, docFile)
      if fileUtil.fileExists(srcDir, srcFile)
        docFilePair.srcFile = srcFile
      acc[docFile] = docFilePair
      acc
    ), {})

  swapSuffixes: (oldSuffix, newSuffix, fileName) ->
    fileName.substring(0, fileName.length - oldSuffix.length) + newSuffix

  swapSuffixAndCopy: (oldSuffix, newSuffix, oldDir, newDir, fileName) ->
    newFileName = fileUtil.swapSuffixes(oldSuffix, newSuffix, fileName)
    newFilePath = path.join newDir, newFileName
    oldFilePath = path.join oldDir, fileName
    fs.copySync oldFilePath, newFilePath

  getFileLines: (baseDir, relPath) ->
    fs.readFileSync(path.join(baseDir, relPath)).toString().split('\n')

  cleanDirectory: (dir) ->
    fs.removeSync dir
    fs.mkdirs dir

  saveFile: (baseDir, relPath, contents) ->
    fs.outputFileSync path.join(baseDir, relPath), contents

  readJson: (file) ->
    fs.readJsonSync(file)

exports.fileUtil = fileUtil

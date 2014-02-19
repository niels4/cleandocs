#fileUtil

Functions that access the filesystem go here



    path = require 'path'
    Finder = require 'fs-finder'
    _ = require "lodash"
    fs = require 'fs-extra'

    fileUtil =
      findFilesWithSuffix: (directory, suffix) ->
        files = Finder.from(directory).findFiles "*#{suffix}"
        files.map _.partial(path.relative, directory)


##fileExists ->
This function will return true if a file exists at the location
Otherwise will return false


      fileExists: (baseDir, relPath) ->
        try
          fs.lstatSync(path.join baseDir, relPath).isFile()
        catch e
          false

      dirExists: (baseDir, relPath) ->
        try
          fs.lstatSync(path.join baseDir, relPath).isDirectory()
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


##swapSuffixes ->
###params:
- oldSuffix - String
- newSuffix - String
- fileName - String

` `


      
      swapSuffixes: (oldSuffix, newSuffix, fileName) ->
        fileName.substring(0, fileName.length - oldSuffix.length) + newSuffix

      swapSuffixAndCopy: (oldSuffix, newSuffix, oldDir, newDir, fileName) ->
        newFileName = fileUtil.swapSuffixes(oldSuffix, newSuffix, fileName)
        newFilePath = path.join newDir, newFileName
        oldFilePath = path.join oldDir, fileName
        fs.copySync oldFilePath, newFilePath

      copyFile: (fromBaseDir, fromFile, toBaseDir, toFile) ->
        toFile ?= fromFile
        fs.copySync(path.join(fromBaseDir, fromFile),
          path.join(toBaseDir, toFile))


      getFileLines: (baseDir, relPath) ->
        fs.readFileSync(path.join(baseDir, relPath)).toString().split('\n')

      cleanDirectory: (dir) ->
        fs.removeSync dir
        fs.mkdirsSync dir

      saveFile: (baseDir, relPath, contents) ->
        fs.outputFileSync path.join(baseDir, relPath), contents

      readJson: (file) ->
        fs.readJsonSync(file)

    exports.fileUtil = fileUtil

{fileUtil} = require '../lib/fileUtil.js'
_ = require 'lodash'
path = require 'path'
fs = require 'fs-extra'

describe 'fileUtil', ->

  docDir = 'test-fixtures/fileUtil/app/docs'
  docSuffix = '.md'
  outputSuffix = '.markdown'
  expectedDocFiles = [
    'README.md'
    'subdir1/subdir2/subdirFile3.md'
    'subdir1/subdirFile1.md'
    'subdir1/subdirFile2.md'
  ]

  srcDir = 'test-fixtures/fileUtil/app/scripts'
  srcSuffix = ".coffee"
  expectedSrcFiles = [
    'main.coffee'
    'subdir1/otherFile.coffee'
    'subdir1/subdir2/anotherFile.coffee'
    'subdir1/subdir2/subdirFile3.coffee'
    'subdir1/subdirFile1.coffee'
  ]


  describe 'findFilesWithSuffix ->', ()->
    describe 'when given a valid directory containing files with the docSuffix', ()->

      it 'should return a list of all the files in that directory (and subdirectories' +
      'that matches the docSuffix, (paths should be relative)', ()->
        actualFiles = fileUtil.findFilesWithSuffix docDir, docSuffix
        actualFiles.length.should.equal 4
        expectedDocFiles.forEach (fileName) ->
          _.contains(actualFiles, fileName).should.be.true

  describe 'fileExists ->', ->

    describe 'when the file exists', ->
      it 'should return true', ->
        fileUtil.fileExists(srcDir, expectedSrcFiles[0]).should.be.true
        fileUtil.fileExists(srcDir, expectedSrcFiles[1]).should.be.true

    describe 'when the file doesnt exist', ->
      it 'should return false', ->
        fileUtil.fileExists(srcDir, "lksjflkjsf").should.be.false

    describe 'when the path is a directory', ->
      it 'should return false', ->
        fileUtil.fileExists(srcDir, "subdir1").should.be.false

  describe 'pairSourceFiles', ->
    expectedPairing =
      'README.md': {}
      'subdir1/subdir2/subdirFile3.md':
        srcFile: 'subdir1/subdir2/subdirFile3.coffee'
      'subdir1/subdirFile1.md':
        srcFile: 'subdir1/subdirFile1.coffee'
      'subdir1/subdirFile2.md': {}

    it 'should match each docFile with its corresponding srcFile. DocFiles without' +
    'a source file should map to an empty object', ->
      fileUtil.pairSourceFiles(srcDir, srcSuffix, docSuffix, expectedDocFiles)
        .should.eql expectedPairing
      
  describe 'swapSuffixes ->', ->
    describe 'when file ends with oldSuffix', ->
      it 'should replace the old suffix with the new suffix', ->
        fileUtil.swapSuffixes(docSuffix, srcSuffix, expectedDocFiles[1])
          .should.equal expectedSrcFiles[3]

  describe 'swapSuffixAndCopy ->', ->
    outDir = "out/test-fixtures/swapSuffixAndCopy"
    expectedCopiedFiles = [
      'README.markdown'
      'subdir1/subdir2/subdirFile3.markdown'
    ]
    testFile1 = expectedDocFiles[0]
    testFile2 = expectedDocFiles[1]
    swapAndCopyFunc = _.partial fileUtil.swapSuffixAndCopy, docSuffix, outputSuffix, docDir, outDir

    before ->
      fs.removeSync outDir
      fs.mkdirs outDir

    it 'should swap the suffixes and copy the file into the new directory, preserving the subdirectory structure', ->
      swapAndCopyFunc testFile1
      swapAndCopyFunc testFile2
      fileUtil.fileExists(outDir, expectedCopiedFiles[0]).should.be.true
      fileUtil.fileExists(outDir, expectedCopiedFiles[1]).should.be.true

  describe 'getFileLines ->', ->
    expectedLines = [
      'here is the first line'
      'heres the second'
      'the 4th line will be empty'
      ''
      'and the last line isn\'t'
      ''
    ]

    it 'return an array of lines from the file', ->
      lines = fileUtil.getFileLines(docDir, expectedDocFiles[0])
      lines.should.eql expectedLines

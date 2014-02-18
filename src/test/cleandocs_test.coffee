{fileUtil} = require '../lib/fileUtil.js'
cleandocs = require '../lib/cleandocs.js'
_ = require 'lodash'

describe 'cleandocs', ->

  describe 'processOptionsFile ->', ->
    optionsFile =
      docSuffix: ".md"
      docTagStart: '#*c:'
      docTagEnd: '*'
      srcSuffix: ".coffee"
      srcTagStart: '#*c:'
      srcTagEnd: '*'
      outputSuffix: ".litcoffee"
      defaultTagOrder: ['untagged', 'description']
      dirs: [
        {
          src: "test-fixtures/fileUtil/app/scripts"
          doc: "test-fixtures/fileUtil/app/docs"
          output: 'out/test-fixtures/mergeAndWriteFiles'
        }
        {
          src: "test-fixtures2/fileUtil/app/scripts"
          doc: "test-fixtures2/fileUtil/app/docs"
          output: 'out/test-fixtures2/mergeAndWriteFiles'
        }
      ]

    it 'should produce an options object for each set of doc files', ->
      allOptions = cleandocs.processOptionsFile optionsFile
      allOptions.length.should.eql 2

  
  #*c:mergeAndWriteFiles*
  describe 'mergeAndWriteAllFiles ->', ->
    expectedDocFiles = [
      'README.litcoffee'
      'subdir1/subdir2/subdirFile3.litcoffee'
      'subdir1/subdirFile1.litcoffee'
      'subdir1/subdirFile2.litcoffee'
    ]

    pairedFiles =
      'README.md': {}
      'subdir1/subdir2/subdirFile3.md':
        srcFile: 'subdir1/subdir2/subdirFile3.coffee'
      'subdir1/subdirFile1.md':
        srcFile: 'subdir1/subdirFile1.coffee'
      'subdir1/subdirFile2.md': {}
    
    options =
      docSuffix: ".md"
      docDir: "test-fixtures/fileUtil/app/docs"
      docTagStart: '#*c:'
      docTagEnd: '*'
      srcSuffix: ".coffee"
      srcDir: "test-fixtures/fileUtil/app/scripts"
      srcTagStart: '#*c:'
      srcTagEnd: '*'
      outputSuffix: ".litcoffee"
      outputDir: 'out/test-fixtures/mergeAndWriteFiles'
      defaultTagOrder: ['untagged', 'description']

    it 'should merge all of the comment files and write them to the output directory', ->
      cleandocs.mergeAndWriteAllFiles pairedFiles, options
      _.forEach expectedDocFiles, (nextExpectFile) ->
        fileUtil.fileExists(options.outputDir, nextExpectFile).should.be.true

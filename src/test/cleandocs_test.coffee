cleandocs = require '../lib/cleandocs.js'

describe 'cleandocs', ->
  
  describe 'mergeAndWriteAllFiles ->', ->
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
      outputSuffix: ".markdown"
      outputDir: 'out/test-fixtures/mergeAndWriteFiles'
      defaultTagOrder: ['untagged', 'description']

    it 'should merge all of the comment files and write them to the output directory', ->
      cleandocs.mergeAndWriteAllFiles pairedFiles, options

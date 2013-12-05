{fileUtil} = require '../lib/fileUtil.js'
_ = require 'lodash'
path = require 'path'

describe 'findFilesWithSuffix ->', ()->
  describe 'when given a valid directory containing files with the docSuffix', ()->
    docDir = 'test-fixtures/findAllDocFiles/app/docs'
    docSuffix = 'md'
    expectedFiles =  [
      'README.md'
      'subdir1/subdir2/subdirFile3.md'
      'subdir1/subdirFile1.md'
      'subdir1/subdirFile2.md'
    ]

    it 'should return a list of all the files in that directory (and subdirectories' +
    'that matches the docSuffix', ()->
      actualFiles = fileUtil.findFilesWithSuffix docDir, docSuffix
      actualFiles.length.should.equal 4
      expectedFiles.forEach (fileName) ->
        _.contains(actualFiles, fileName).should.be.true

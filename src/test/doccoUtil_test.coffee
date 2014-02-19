{fileUtil} = require '../lib/fileUtil'
fs = require 'fs-extra'
path = require 'path'
doccoUtil = require '../lib/doccoUtil'
_ = require 'lodash'

describe 'doccoUtil', ->
  
  describe 'doccoFile ->', ->
    testBasedir = 'test-fixtures/doccoUtil'
    testOutput = 'out/test/doccoUtil/test1'
    testFileName = 'subdir/test_source.litcoffee'
    testFile = null

    before ->
      testFile = fs.readFileSync(path.join(testBasedir, testFileName))
        .toString()

    it 'should be a function', ->
      doccoUtil.doccoFile.should.be.a 'function'

    it 'parse and write the file out to html', ->
      doccoUtil.doccoFile(testFileName, testFile, testBasedir, testOutput)

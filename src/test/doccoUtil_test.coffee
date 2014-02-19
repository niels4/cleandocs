{fileUtil} = require '../lib/fileUtil'
fs = require 'fs-extra'
path = require 'path'
doccoUtil = require '../lib/doccoUtil'
_ = require 'lodash'

describe 'doccoUtil', ->
  
  describe 'doccoFile ->', ->
    testOutput = 'test-fixtures/doccoUtil'
    testFileName = 'subdir/test_source.litcoffee'
    testFile = null

    before ->
      testFile = fs.readFileSync(path.join(testOutput, testFileName))
        .toString()

    it 'should be a function', ->
      doccoUtil.doccoFile.should.be.a 'function'

    it 'should do something', ->
      console.log "testFile:", testFile
      result = doccoUtil.doccoFile(testFileName, testFile, testOutput)
      console.log "result:", result
      result.should.be.ok

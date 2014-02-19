{fileUtil} = require '../lib/fileUtil'
fs = require 'fs-extra'
doccoUtil = require '../lib/doccoUtil'
_ = require 'lodash'

describe 'doccoUtil', ->
  
  describe 'doccoFile ->', ->
    testFileName = 'test-fixtures/doccoUtil/test_source.litcoffee'
    testFile = null

    before ->
      testFile = fs.readFileSync(testFileName)
        .toString()

    it 'should be a function', ->
      doccoUtil.doccoFile.should.be.a 'function'

    it 'should do something', ->
      console.log "testFile:", testFile
      result = doccoUtil.doccoFile(testFileName, testFile)
      console.log "result:", result
      result.should.be.ok

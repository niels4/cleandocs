{fileUtil} = require '../lib/fileUtil'
doccoUtil = require '../lib/doccoUtil'
_ = require 'lodash'

describe 'doccoUtil', ->
  
  describe 'doccoFile ->', ->

    it 'should be a function', ->
      doccoUtil.doccoFile.should.be.a 'function'

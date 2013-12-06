{DocMerger} = require '../lib/DocMerger.js'
_ = require 'lodash'
path = require 'path'
fs = require 'fs-extra'

describe 'DocMerger', ->

  docPrefix = "#*c:"
  docTagEndChar = "*"

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


  describe 'parseCommentSections ->', ()->
    describe 'when given a valid file with comment tags', ()->
      expectedComments =
        "untagged": [
          'Here is some untagged text'
          ''
        ]
        "description": [
          'This is the description section'
          'Its just another tag'
          ''
        ]
        "interesting thing": [
          'this is very interesting'
          ''
        ]
        "last tag": [
          'This is the last tag of the file'
          ''
        ]


      it 'should return an object with each comment tag mapped to its content', ->
        DocMerger.parseCommentSections(docPrefix, docTagEndChar, docDir, expectedDocFiles[2])
          .should.eql expectedComments

  describe 'findTag ->', ->
    describe 'when given a line with a tag in it', ->
      testLine = "     #*c:Hello there*"
      expectedTag = 'Hello there'

      it 'should return the tag name', ->
        DocMerger.findTag(docPrefix, docTagEndChar, testLine)
          .should.equal expectedTag
    describe 'when given a line without a tag in it', ->
      testLine = "Just some text on a line"
      expectedTag = null

      it 'should return null', ->
        (DocMerger.findTag(docPrefix, docTagEndChar, testLine) is null)
          .should.be.true

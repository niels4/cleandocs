{DocMerger} = require '../lib/DocMerger.js'
_ = require 'lodash'
path = require 'path'
fs = require 'fs-extra'
{fileUtil} = require '../lib/fileUtil'

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

  expectedCommentTags1 =
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
    "won't match": [
      'this tag won\'t match any other'
      ''
    ]
    "last tag": [
      'This is the last tag of the file'
      ''
    ]

  describe 'parseCommentSections ->', ()->
    describe 'when given a valid file with comment tags', ()->

      it 'should return an object with each comment tag mapped to its content', ->
        lines = fileUtil.getFileLines(docDir, expectedDocFiles[2])
        DocMerger.parseCommentSections(docPrefix, docTagEndChar, lines)
          .should.eql expectedCommentTags1

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

  describe 'mergeCommentTags ->', ->
    expectedCommentTags = _.clone expectedCommentTags1
    expectedMergedLines = [
      '    Class SomeTestClass',
      '',
      'this is very interesting',
      '',
      '',
      '      constructor: (arg) ->',
      '        console.log "printing the arg", arg',
      '',
      '',
      'This is the last tag of the file',
      '',
      '',
      '      otherFunc: (arg) ->',
      '        console.log "heres another function", arg',
      ''
    ]
    expectedUnmatchedTags =
      "untagged": [
        'Here is some untagged text'
        ''
      ]
      "description": [
        'This is the description section'
        'Its just another tag'
        ''
      ]
      "won't match": [
        'this tag won\'t match any other'
        ''
      ]

    actualMergedLines = actualUnmatchedTags = null
    before ->
      lines = fileUtil.getFileLines(srcDir, expectedSrcFiles[4])
      {mergedLines, unmatchedTags} = DocMerger.mergeCommentTags(docPrefix, docTagEndChar, expectedCommentTags, lines)
      actualMergedLines = mergedLines
      actualUnmatchedTags = unmatchedTags

    it 'Should replace lines that contain tags in the source file with the matching section' +
    'from the commentTags. Any comments not matched are added to the top of the file.' +
    'All code should be indented 4 spaces', ->
      actualMergedLines.should.eql expectedMergedLines

    it 'it should also return a hashmap of unused comment tags', ->
      actualUnmatchedTags.should.eql expectedUnmatchedTags
      
      actualUnmatchedTags.should.eql expectedUnmatchedTags

  describe 'prependUnmatchedTags ->', ->
    mergedLines = [
      '    Class SomeTestClass',
      'this is very interesting',
      '',
      '      constructor: (arg) ->',
      '        console.log "printing the arg", arg',
      '',
      'This is the last tag of the file',
      '',
      '      otherFunc: (arg) ->',
      '        console.log "heres another function", arg',
      ''
    ]
    unmatchedTags =
    "untagged": [
      'Here is some untagged text'
      ''
    ]
    "description": [
      'This is the description section'
      'Its just another tag'
      ''
    ]
    "won't match": [
      'this tag won\'t match any other'
      ''
    ]

    expectedCompletMergedLines = [
      'This is the description section',
      'Its just another tag',
      '',
      'Here is some untagged text',
      '',
      '',
      'this tag won\'t match any other',
      '',
      '',
      '    Class SomeTestClass',
      'this is very interesting',
      '',
      '      constructor: (arg) ->',
      '        console.log "printing the arg", arg',
      '',
      'This is the last tag of the file',
      '',
      '      otherFunc: (arg) ->',
      '        console.log "heres another function", arg',
      ''
    ]

    it 'should add the lines in matchedTags to the beginning of mergedLines,' +
    'It should add the tags in defaultTagOrder first', ->
      defaultTagOrder = ['description', 'untagged']
      completeMergedLines = DocMerger.prependUnmatchedTags(defaultTagOrder, unmatchedTags, mergedLines)
      completeMergedLines.should.eql expectedCompletMergedLines

  describe 'mergeDocFiles ->', ->
    expectedMergedFile = '''
      Here is some untagged text

      This is the description section
      Its just another tag


      this tag won't match any other


          Class SomeTestClass

      this is very interesting


            constructor: (arg) ->
              console.log "printing the arg", arg


      This is the last tag of the file


            otherFunc: (arg) ->
              console.log "heres another function", arg

    '''
    it 'should create a string from merging the doc file with the source file', ->
      docLines = fileUtil.getFileLines(docDir, expectedDocFiles[2])
      srcLines = fileUtil.getFileLines(srcDir, expectedSrcFiles[4])
      mergedFile = DocMerger.mergeDocFiles
        docTagStart: docPrefix
        docTagEnd: docTagEndChar
        srcTagStart: docPrefix
        srcTagEnd: docTagEndChar
        defaultTagOrder: ['untagged', 'description']
        docLines: docLines
        srcLines: srcLines

      mergedFile.should.equal expectedMergedFile

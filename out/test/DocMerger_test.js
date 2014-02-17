(function() {
  var DocMerger, fileUtil, fs, path, _;

  DocMerger = require('../lib/DocMerger.js').DocMerger;

  _ = require('lodash');

  path = require('path');

  fs = require('fs-extra');

  fileUtil = require('../lib/fileUtil').fileUtil;

  describe('DocMerger', function() {
    var docDir, docPrefix, docSuffix, docTagEndChar, expectedCommentTags1, expectedDocFiles, expectedSrcFiles, outputSuffix, srcDir, srcSuffix;
    docPrefix = "#*c:";
    docTagEndChar = "*";
    docDir = 'test-fixtures/fileUtil/app/docs';
    docSuffix = '.md';
    outputSuffix = '.markdown';
    expectedDocFiles = ['README.md', 'subdir1/subdir2/subdirFile3.md', 'subdir1/subdirFile1.md', 'subdir1/subdirFile2.md'];
    srcDir = 'test-fixtures/fileUtil/app/scripts';
    srcSuffix = ".coffee";
    expectedSrcFiles = ['main.coffee', 'subdir1/otherFile.coffee', 'subdir1/subdir2/anotherFile.coffee', 'subdir1/subdir2/subdirFile3.coffee', 'subdir1/subdirFile1.coffee'];
    expectedCommentTags1 = {
      "untagged": ['Here is some untagged text', ''],
      "description": ['This is the description section', 'Its just another tag', ''],
      "interesting thing": ['this is very interesting', ''],
      "won't match": ['this tag won\'t match any other', ''],
      "last tag": ['This is the last tag of the file', '']
    };
    describe('parseCommentSections ->', function() {
      return describe('when given a valid file with comment tags', function() {
        return it('should return an object with each comment tag mapped to its content', function() {
          var lines;
          lines = fileUtil.getFileLines(docDir, expectedDocFiles[2]);
          return DocMerger.parseCommentSections(docPrefix, docTagEndChar, lines).should.eql(expectedCommentTags1);
        });
      });
    });
    describe('findTag ->', function() {
      describe('when given a line with a tag in it', function() {
        var expectedTag, testLine;
        testLine = "     #*c:Hello there*";
        expectedTag = 'Hello there';
        return it('should return the tag name', function() {
          return DocMerger.findTag(docPrefix, docTagEndChar, testLine).should.equal(expectedTag);
        });
      });
      return describe('when given a line without a tag in it', function() {
        var expectedTag, testLine;
        testLine = "Just some text on a line";
        expectedTag = null;
        return it('should return null', function() {
          return (DocMerger.findTag(docPrefix, docTagEndChar, testLine) === null).should.be["true"];
        });
      });
    });
    describe('mergeCommentTags ->', function() {
      var actualMergedLines, actualUnmatchedTags, expectedCommentTags, expectedMergedLines, expectedUnmatchedTags;
      expectedCommentTags = _.clone(expectedCommentTags1);
      expectedMergedLines = ['    Class SomeTestClass', '', 'this is very interesting', '', '', '      constructor: (arg) ->', '        console.log "printing the arg", arg', '', '', 'This is the last tag of the file', '', '', '      otherFunc: (arg) ->', '        console.log "heres another function", arg', ''];
      expectedUnmatchedTags = {
        "untagged": ['Here is some untagged text', ''],
        "description": ['This is the description section', 'Its just another tag', ''],
        "won't match": ['this tag won\'t match any other', '']
      };
      actualMergedLines = actualUnmatchedTags = null;
      before(function() {
        var lines, mergedLines, unmatchedTags, _ref;
        lines = fileUtil.getFileLines(srcDir, expectedSrcFiles[4]);
        _ref = DocMerger.mergeCommentTags(docPrefix, docTagEndChar, expectedCommentTags, lines), mergedLines = _ref.mergedLines, unmatchedTags = _ref.unmatchedTags;
        actualMergedLines = mergedLines;
        return actualUnmatchedTags = unmatchedTags;
      });
      it('Should replace lines that contain tags in the source file with the matching section' + 'from the commentTags. Any comments not matched are added to the top of the file.' + 'All code should be indented 4 spaces', function() {
        return actualMergedLines.should.eql(expectedMergedLines);
      });
      return it('it should also return a hashmap of unused comment tags', function() {
        actualUnmatchedTags.should.eql(expectedUnmatchedTags);
        return actualUnmatchedTags.should.eql(expectedUnmatchedTags);
      });
    });
    describe('prependUnmatchedTags ->', function() {
      var expectedCompletMergedLines, mergedLines, unmatchedTags;
      mergedLines = ['    Class SomeTestClass', 'this is very interesting', '', '      constructor: (arg) ->', '        console.log "printing the arg", arg', '', 'This is the last tag of the file', '', '      otherFunc: (arg) ->', '        console.log "heres another function", arg', ''];
      unmatchedTags = {
        "untagged": ['Here is some untagged text', ''],
        "description": ['This is the description section', 'Its just another tag', ''],
        "won't match": ['this tag won\'t match any other', '']
      };
      expectedCompletMergedLines = ['This is the description section', 'Its just another tag', '', 'Here is some untagged text', '', '', 'this tag won\'t match any other', '', '', '    Class SomeTestClass', 'this is very interesting', '', '      constructor: (arg) ->', '        console.log "printing the arg", arg', '', 'This is the last tag of the file', '', '      otherFunc: (arg) ->', '        console.log "heres another function", arg', ''];
      return it('should add the lines in matchedTags to the beginning of mergedLines,' + 'It should add the tags in defaultTagOrder first', function() {
        var completeMergedLines, defaultTagOrder;
        defaultTagOrder = ['description', 'untagged'];
        completeMergedLines = DocMerger.prependUnmatchedTags(defaultTagOrder, unmatchedTags, mergedLines);
        return completeMergedLines.should.eql(expectedCompletMergedLines);
      });
    });
    return describe('mergeDocFiles ->', function() {
      var expectedMergedFile;
      expectedMergedFile = 'Here is some untagged text\n\nThis is the description section\nIts just another tag\n\n\nthis tag won\'t match any other\n\n\n    Class SomeTestClass\n\nthis is very interesting\n\n\n      constructor: (arg) ->\n        console.log "printing the arg", arg\n\n\nThis is the last tag of the file\n\n\n      otherFunc: (arg) ->\n        console.log "heres another function", arg\n';
      return it('should create a string from merging the doc file with the source file', function() {
        var docLines, mergedFile, srcLines;
        docLines = fileUtil.getFileLines(docDir, expectedDocFiles[2]);
        srcLines = fileUtil.getFileLines(srcDir, expectedSrcFiles[4]);
        mergedFile = DocMerger.mergeDocFiles({
          docTagStart: docPrefix,
          docTagEnd: docTagEndChar,
          srcTagStart: docPrefix,
          srcTagEnd: docTagEndChar,
          defaultTagOrder: ['untagged', 'description'],
          docLines: docLines,
          srcLines: srcLines
        });
        return mergedFile.should.equal(expectedMergedFile);
      });
    });
  });

}).call(this);

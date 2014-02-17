(function() {
  var fileUtil, fs, path, _;

  fileUtil = require('../lib/fileUtil.js').fileUtil;

  _ = require('lodash');

  path = require('path');

  fs = require('fs-extra');

  describe('fileUtil', function() {
    var docDir, docSuffix, expectedDocFiles, expectedSrcFiles, outputSuffix, srcDir, srcSuffix;
    docDir = 'test-fixtures/fileUtil/app/docs';
    docSuffix = '.md';
    outputSuffix = '.markdown';
    expectedDocFiles = ['README.md', 'subdir1/subdir2/subdirFile3.md', 'subdir1/subdirFile1.md', 'subdir1/subdirFile2.md'];
    srcDir = 'test-fixtures/fileUtil/app/scripts';
    srcSuffix = ".coffee";
    expectedSrcFiles = ['main.coffee', 'subdir1/otherFile.coffee', 'subdir1/subdir2/anotherFile.coffee', 'subdir1/subdir2/subdirFile3.coffee', 'subdir1/subdirFile1.coffee'];
    describe('findFilesWithSuffix ->', function() {
      return describe('when given a valid directory containing files with the docSuffix', function() {
        return it('should return a list of all the files in that directory (and subdirectories' + 'that matches the docSuffix, (paths should be relative)', function() {
          var actualFiles;
          actualFiles = fileUtil.findFilesWithSuffix(docDir, docSuffix);
          actualFiles.length.should.equal(4);
          return expectedDocFiles.forEach(function(fileName) {
            return _.contains(actualFiles, fileName).should.be["true"];
          });
        });
      });
    });
    describe('fileExists ->', function() {
      describe('when the file exists', function() {
        return it('should return true', function() {
          fileUtil.fileExists(srcDir, expectedSrcFiles[0]).should.be["true"];
          return fileUtil.fileExists(srcDir, expectedSrcFiles[1]).should.be["true"];
        });
      });
      describe('when the file doesnt exist', function() {
        return it('should return false', function() {
          return fileUtil.fileExists(srcDir, "lksjflkjsf").should.be["false"];
        });
      });
      return describe('when the path is a directory', function() {
        return it('should return false', function() {
          return fileUtil.fileExists(srcDir, "subdir1").should.be["false"];
        });
      });
    });
    describe('pairSourceFiles', function() {
      var expectedPairing;
      expectedPairing = {
        'README.md': {},
        'subdir1/subdir2/subdirFile3.md': {
          srcFile: 'subdir1/subdir2/subdirFile3.coffee'
        },
        'subdir1/subdirFile1.md': {
          srcFile: 'subdir1/subdirFile1.coffee'
        },
        'subdir1/subdirFile2.md': {}
      };
      return it('should match each docFile with its corresponding srcFile. DocFiles without' + 'a source file should map to an empty object', function() {
        return fileUtil.pairSourceFiles(srcDir, srcSuffix, docSuffix, expectedDocFiles).should.eql(expectedPairing);
      });
    });
    describe('swapSuffixes ->', function() {
      return describe('when file ends with oldSuffix', function() {
        return it('should replace the old suffix with the new suffix', function() {
          return fileUtil.swapSuffixes(docSuffix, srcSuffix, expectedDocFiles[1]).should.equal(expectedSrcFiles[3]);
        });
      });
    });
    describe('swapSuffixAndCopy ->', function() {
      var expectedCopiedFiles, outDir, swapAndCopyFunc, testFile1, testFile2;
      outDir = "out/test-fixtures/swapSuffixAndCopy";
      expectedCopiedFiles = ['README.markdown', 'subdir1/subdir2/subdirFile3.markdown'];
      testFile1 = expectedDocFiles[0];
      testFile2 = expectedDocFiles[1];
      swapAndCopyFunc = _.partial(fileUtil.swapSuffixAndCopy, docSuffix, outputSuffix, docDir, outDir);
      before(function() {
        fs.removeSync(outDir);
        return fs.mkdirs(outDir);
      });
      return it('should swap the suffixes and copy the file into the new directory, preserving the subdirectory structure', function() {
        swapAndCopyFunc(testFile1);
        swapAndCopyFunc(testFile2);
        fileUtil.fileExists(outDir, expectedCopiedFiles[0]).should.be["true"];
        return fileUtil.fileExists(outDir, expectedCopiedFiles[1]).should.be["true"];
      });
    });
    return describe('getFileLines ->', function() {
      var expectedLines;
      expectedLines = ['here is the first line', 'heres the second', 'the 4th line will be empty', '', 'and the last line isn\'t', ''];
      return it('return an array of lines from the file', function() {
        var lines;
        lines = fileUtil.getFileLines(docDir, expectedDocFiles[0]);
        return lines.should.eql(expectedLines);
      });
    });
  });

}).call(this);

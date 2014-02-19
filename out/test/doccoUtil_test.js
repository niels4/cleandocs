(function() {
  var doccoUtil, fileUtil, fs, path, _;

  fileUtil = require('../lib/fileUtil').fileUtil;

  fs = require('fs-extra');

  path = require('path');

  doccoUtil = require('../lib/doccoUtil');

  _ = require('lodash');

  describe('doccoUtil', function() {
    return describe('doccoFile ->', function() {
      var testBasedir, testFile, testFileName, testOutput;
      testBasedir = 'test-fixtures/doccoUtil';
      testOutput = 'out/test-fixtures/doccoUtil/test1';
      testFileName = 'subdir/test_source.litcoffee';
      testFile = null;
      before(function() {
        return testFile = fs.readFileSync(path.join(testBasedir, testFileName)).toString();
      });
      it('should be a function', function() {
        return doccoUtil.doccoFile.should.be.a('function');
      });
      return it('parse and write the file out to html', function() {
        doccoUtil.doccoFile(testFileName, testFile, testOutput);
        return fileUtil.fileExists(testOutput, 'subdir/test_source.html').should.be["true"];
      });
    });
  });

}).call(this);

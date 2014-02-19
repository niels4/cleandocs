(function() {
  var doccoUtil, fileUtil, fs, path, _;

  fileUtil = require('../lib/fileUtil').fileUtil;

  fs = require('fs-extra');

  path = require('path');

  doccoUtil = require('../lib/doccoUtil');

  _ = require('lodash');

  describe('doccoUtil', function() {
    return describe('doccoFile ->', function() {
      var testFile, testFileName, testOutput;
      testOutput = 'test-fixtures/doccoUtil';
      testFileName = 'subdir/test_source.litcoffee';
      testFile = null;
      before(function() {
        return testFile = fs.readFileSync(path.join(testOutput, testFileName)).toString();
      });
      it('should be a function', function() {
        return doccoUtil.doccoFile.should.be.a('function');
      });
      return it('should do something', function() {
        var result;
        console.log("testFile:", testFile);
        result = doccoUtil.doccoFile(testFileName, testFile, testOutput);
        console.log("result:", result);
        return result.should.be.ok;
      });
    });
  });

}).call(this);

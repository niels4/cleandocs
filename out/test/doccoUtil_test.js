(function() {
  var doccoUtil, fileUtil, fs, _;

  fileUtil = require('../lib/fileUtil').fileUtil;

  fs = require('fs-extra');

  doccoUtil = require('../lib/doccoUtil');

  _ = require('lodash');

  describe('doccoUtil', function() {
    return describe('doccoFile ->', function() {
      var testFile, testFileName;
      testFileName = 'test-fixtures/doccoUtil/test_source.litcoffee';
      testFile = null;
      before(function() {
        return testFile = fs.readFileSync(testFileName).toString();
      });
      it('should be a function', function() {
        return doccoUtil.doccoFile.should.be.a('function');
      });
      return it('should do something', function() {
        var result;
        console.log("testFile:", testFile);
        result = doccoUtil.doccoFile(testFileName, testFile);
        console.log("result:", result);
        return result.should.be.ok;
      });
    });
  });

}).call(this);

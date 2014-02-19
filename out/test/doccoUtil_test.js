(function() {
  var doccoUtil, fileUtil, _;

  fileUtil = require('../lib/fileUtil').fileUtil;

  doccoUtil = require('../lib/doccoUtil');

  _ = require('lodash');

  describe('doccoUtil', function() {
    return describe('doccoFile ->', function() {
      return it('should be a function', function() {
        return doccoUtil.doccoFile.should.be.a('function');
      });
    });
  });

}).call(this);

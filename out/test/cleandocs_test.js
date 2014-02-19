(function() {
  var cleandocs, fileUtil, _;

  fileUtil = require('../lib/fileUtil.js').fileUtil;

  cleandocs = require('../lib/cleandocs.js');

  _ = require('lodash');

  describe('cleandocs', function() {
    describe('processOptionsFile ->', function() {
      var optionsFile;
      optionsFile = {
        docSuffix: ".md",
        docTagStart: '#*c:',
        docTagEnd: '*',
        srcSuffix: ".coffee",
        srcTagStart: '#*c:',
        srcTagEnd: '*',
        outputSuffix: ".litcoffee",
        defaultTagOrder: ['untagged', 'description'],
        dirs: [
          {
            src: "test-fixtures/fileUtil/app/scripts",
            doc: "test-fixtures/fileUtil/app/docs",
            output: 'out/test-fixtures/mergeAndWriteFiles'
          }, {
            src: "test-fixtures2/fileUtil/app/scripts",
            doc: "test-fixtures2/fileUtil/app/docs",
            output: 'out/test-fixtures2/mergeAndWriteFiles'
          }
        ]
      };
      return it('should produce an options object for each set of doc files', function() {
        var allOptions;
        allOptions = cleandocs.processOptionsFile(optionsFile);
        return allOptions.length.should.eql(2);
      });
    });
    return describe('mergeAndWriteAllFiles ->', function() {
      var expectedDocFiles, options, pairedFiles;
      expectedDocFiles = ['README.litcoffee', 'subdir1/subdir2/subdirFile3.litcoffee', 'subdir1/subdirFile1.litcoffee', 'subdir1/subdirFile2.litcoffee'];
      pairedFiles = {
        'README.md': {},
        'subdir1/subdir2/subdirFile3.md': {
          srcFile: 'subdir1/subdir2/subdirFile3.coffee'
        },
        'subdir1/subdirFile1.md': {
          srcFile: 'subdir1/subdirFile1.coffee'
        },
        'subdir1/subdirFile2.md': {}
      };
      options = {
        docSuffix: ".md",
        docDir: "test-fixtures/fileUtil/app/docs",
        docTagStart: '#*c:',
        docTagEnd: '*',
        srcSuffix: ".coffee",
        srcDir: "test-fixtures/fileUtil/app/scripts",
        srcTagStart: '#*c:',
        srcTagEnd: '*',
        outputSuffix: ".litcoffee",
        outputDir: 'out/test-fixtures/writeFilesWithDocco',
        defaultTagOrder: ['untagged', 'description']
      };
      describe('without docco', function() {
        before(function() {
          return cleandocs.mergeAndWriteAllFiles(pairedFiles, options);
        });
        return it('should merge all of the comment files and write them to the output directory', function() {
          return _.forEach(expectedDocFiles, function(nextExpectFile) {
            return fileUtil.fileExists(options.outputDir, nextExpectFile).should.be["true"];
          });
        });
      });
      return describe('with docco', function() {
        var expectedDoccoFiles;
        options = _.extend(_.clone(options), {
          docco: true
        });
        before(function() {
          return cleandocs.mergeAndWriteAllFiles(pairedFiles, options);
        });
        expectedDoccoFiles = ['README.html', 'subdir1/subdir2/subdirFile3.html', 'subdir1/subdirFile1.html', 'subdir1/subdirFile2.html'];
        return it('should run each merged file through docco', function() {
          return _.forEach(expectedDoccoFiles, function(nextExpectFile) {
            return fileUtil.fileExists(options.outputDir, nextExpectFile).should.be["true"];
          });
        });
      });
    });
  });

}).call(this);

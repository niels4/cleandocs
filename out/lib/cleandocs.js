(function() {
  var DocMerger, fileUtil, getOptions, main, mergeAndWriteAllFiles, processAllDirs, processAllFiles, processOptionsFile, readOptionsFile, _;

  fileUtil = require('./fileUtil').fileUtil;

  DocMerger = require('../lib/DocMerger.js').DocMerger;

  _ = require('lodash');

  readOptionsFile = function() {
    return fileUtil.readJson('cleandocs.json');
  };

  processOptionsFile = function(optionsFile) {
    return _.map(optionsFile.dirs, function(nextDirs) {
      var nextOptions;
      nextOptions = _.pick(optionsFile, 'docSuffix', 'docTagStart', 'docTagEnd', 'srcSuffix', 'srcTagStart', 'srcTagEnd', 'outputSuffix', 'defaultTagOrder');
      nextOptions.docDir = nextDirs.docs;
      nextOptions.srcDir = nextDirs.src;
      nextOptions.outputDir = nextDirs.output;
      return nextOptions;
    });
  };

  getOptions = function() {
    return processOptionsFile(readOptionsFile());
  };

  mergeAndWriteAllFiles = function(pairedFiles, options) {
    var defaultTagOrder, docDir, docSuffix, docTagEnd, docTagStart, outputDir, outputSuffix, srcDir, srcSuffix, srcTagEnd, srcTagStart;
    docDir = options.docDir, docSuffix = options.docSuffix, docTagStart = options.docTagStart, docTagEnd = options.docTagEnd, srcDir = options.srcDir, srcSuffix = options.srcSuffix, srcTagStart = options.srcTagStart, srcTagEnd = options.srcTagEnd, outputDir = options.outputDir, outputSuffix = options.outputSuffix, defaultTagOrder = options.defaultTagOrder;
    fileUtil.cleanDirectory(outputDir);
    return _.each(pairedFiles, function(docFile, docFileName) {
      var docLines, mergedFile, outFileName, srcFileName, srcLines;
      docLines = fileUtil.getFileLines(docDir, docFileName);
      outFileName = fileUtil.swapSuffixes(docSuffix, outputSuffix, docFileName);
      if (docFile.srcFile) {
        srcFileName = fileUtil.swapSuffixes(docSuffix, srcSuffix, docFileName);
        srcLines = fileUtil.getFileLines(srcDir, srcFileName);
        mergedFile = DocMerger.mergeDocFiles({
          docTagStart: docTagStart,
          docTagEnd: docTagEnd,
          srcTagStart: srcTagStart,
          srcTagEnd: srcTagEnd,
          defaultTagOrder: defaultTagOrder,
          docLines: docLines,
          srcLines: srcLines
        });
      } else {
        mergedFile = docLines;
      }
      return fileUtil.saveFile(outputDir, outFileName, mergedFile);
    });
  };

  processAllFiles = function(options) {
    var docFiles, pairedFiles;
    console.log("processing all " + options.docSuffix + " files in directory " + options.docDir);
    docFiles = fileUtil.findFilesWithSuffix(options.docDir, options.docSuffix);
    pairedFiles = fileUtil.pairSourceFiles(options.srcDir, options.srcSuffix, options.docSuffix, docFiles);
    return mergeAndWriteAllFiles(pairedFiles, options);
  };

  processAllDirs = function(fileOptions) {
    return _.forEach(processOptionsFile(fileOptions), function(nextOptions) {
      return processAllFiles(nextOptions);
    });
  };

  main = function() {
    return processAllDirs(readOptionsFile());
  };

  exports.main = main;

  exports.mergeAndWriteAllFiles = mergeAndWriteAllFiles;

  exports.processOptionsFile = processOptionsFile;

  exports.processAllDirs = processAllDirs;

}).call(this);

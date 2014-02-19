(function() {
  var Finder, fileUtil, fs, path, _;

  path = require('path');

  Finder = require('fs-finder');

  _ = require("lodash");

  fs = require('fs-extra');

  fileUtil = {
    findFilesWithSuffix: function(directory, suffix) {
      var files;
      files = Finder.from(directory).findFiles("*" + suffix);
      return files.map(_.partial(path.relative, directory));
    },
    fileExists: function(baseDir, relPath) {
      var e;
      try {
        return fs.lstatSync(path.join(baseDir, relPath)).isFile();
      } catch (_error) {
        e = _error;
        return false;
      }
    },
    dirExists: function(baseDir, relPath) {
      var e;
      try {
        return fs.lstatSync(path.join(baseDir, relPath)).isDirectory();
      } catch (_error) {
        e = _error;
        return false;
      }
    },
    pairSourceFiles: function(srcDir, srcSuffix, docSuffix, docFiles) {
      return docFiles.reduce((function(acc, docFile) {
        var docFilePair, srcFile;
        docFilePair = {};
        srcFile = fileUtil.swapSuffixes(docSuffix, srcSuffix, docFile);
        if (fileUtil.fileExists(srcDir, srcFile)) {
          docFilePair.srcFile = srcFile;
        }
        acc[docFile] = docFilePair;
        return acc;
      }), {});
    },
    swapSuffixes: function(oldSuffix, newSuffix, fileName) {
      return fileName.substring(0, fileName.length - oldSuffix.length) + newSuffix;
    },
    swapSuffixAndCopy: function(oldSuffix, newSuffix, oldDir, newDir, fileName) {
      var newFileName, newFilePath, oldFilePath;
      newFileName = fileUtil.swapSuffixes(oldSuffix, newSuffix, fileName);
      newFilePath = path.join(newDir, newFileName);
      oldFilePath = path.join(oldDir, fileName);
      return fs.copySync(oldFilePath, newFilePath);
    },
    copyFile: function(fromBaseDir, fromFile, toBaseDir, toFile) {
      if (toFile == null) {
        toFile = fromFile;
      }
      return fs.copySync(path.join(fromBaseDir, fromFile), path.join(toBaseDir, toFile));
    },
    getFileLines: function(baseDir, relPath) {
      return fs.readFileSync(path.join(baseDir, relPath)).toString().split('\n');
    },
    cleanDirectory: function(dir) {
      fs.removeSync(dir);
      return fs.mkdirsSync(dir);
    },
    saveFile: function(baseDir, relPath, contents) {
      return fs.outputFileSync(path.join(baseDir, relPath), contents);
    },
    readJson: function(file) {
      return fs.readJsonSync(file);
    }
  };

  exports.fileUtil = fileUtil;

}).call(this);

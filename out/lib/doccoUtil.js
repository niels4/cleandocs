(function() {
  var docco, doccoFile, fs, languages, path, _;

  docco = require("docco");

  _ = require("lodash");

  path = require('path');

  fs = require('fs-extra');

  languages = path.join(__dirname, 'node_modules', 'docco', 'resources', 'languages.json');

  doccoFile = function(fileName, fileContents, baseDir) {
    var config;
    config = {};
    config.languages = languages;
    return docco.parse(fileName, fileContents, config);
  };

  _.extend(exports, {
    doccoFile: doccoFile
  });

}).call(this);

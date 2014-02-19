(function() {
  var DOCCO_STYLE, docco, doccoFile, fileUtil, fs, languages, path, template, _;

  fileUtil = require('../lib/fileUtil').fileUtil;

  docco = require("docco");

  _ = require("lodash");

  path = require('path');

  fs = require('fs-extra');

  DOCCO_STYLE = 'parallel';

  languages = fs.readJsonSync(path.join('node_modules', 'docco', 'resources', 'languages.json'));

  template = _.template(fs.readFileSync(path.join('node_modules', 'docco', 'resources', DOCCO_STYLE, 'docco.jst')).toString());

  doccoFile = function(fileName, fileContents, output) {
    var config, css, sections;
    css = "test.css";
    config = {
      languages: languages,
      template: template,
      output: output,
      css: css
    };
    sections = docco.parse(fileName, fileContents, config);
    return docco.format(fileName, sections, config);
  };

  _.extend(exports, {
    doccoFile: doccoFile
  });

}).call(this);

(function() {
  var DOCCO_STYLE, docco, doccoFile, fileUtil, fs, languages, path, sources, template, _;

  fileUtil = require('../lib/fileUtil').fileUtil;

  docco = require("docco");

  _ = require("lodash");

  path = require('path');

  fs = require('fs-extra');

  DOCCO_STYLE = 'parallel';

  languages = fs.readJsonSync(path.join('node_modules', 'docco', 'resources', 'languages.json'));

  template = _.template(fs.readFileSync(path.join('node_modules', 'docco', 'resources', DOCCO_STYLE, 'docco.jst')).toString());

  sources = [];

  doccoFile = function(fileName, fileContents, baseOutput) {
    var config, css, output, sections, source;
    output = path.join(baseOutput, path.dirname(fileName));
    source = path.basename(fileName);
    fs.mkdirsSync(output);
    css = "test.css";
    config = {
      languages: languages,
      template: template,
      output: output,
      css: css,
      sources: sources
    };
    sections = docco.parse(source, fileContents, config);
    docco.format(source, sections, config);
    return docco.write(source, sections, config);
  };

  _.extend(exports, {
    doccoFile: doccoFile
  });

}).call(this);

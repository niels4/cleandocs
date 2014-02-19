(function() {
  var DOCCO_MODULE, DOCCO_STYLE, docco, doccoFile, fileUtil, fs, jstTemplate, languages, path, sources, _;

  fileUtil = require('../lib/fileUtil').fileUtil;

  docco = require("docco-with-write-function");

  _ = require("lodash");

  path = require('path');

  fs = require('fs-extra');

  DOCCO_STYLE = 'parallel';

  DOCCO_MODULE = "docco-with-write-function";

  languages = fs.readJsonSync(path.join('node_modules', DOCCO_MODULE, 'resources', 'languages.json'));

  languages = docco.buildMatchers(languages);

  jstTemplate = _.template(fs.readFileSync(path.join('node_modules', DOCCO_MODULE, 'resources', DOCCO_STYLE, 'docco.jst')).toString());

  sources = [];

  doccoFile = function(fileName, fileContents, baseOutput) {
    var config, css, output, sections, source, template;
    output = path.join(baseOutput, path.dirname(fileName));
    source = path.basename(fileName);
    fs.mkdirsSync(output);
    css = path.relative(path.join(baseOutput, fileName, "../"), path.join(baseOutput, "docco.css"));
    template = function(templateArgs) {
      templateArgs.css = css;
      return jstTemplate(templateArgs);
    };
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
    doccoFile: doccoFile,
    DOCCO_MODULE: DOCCO_MODULE
  });

}).call(this);

(function() {
  var DocMerger, _;

  _ = require('lodash');

  DocMerger = {
    mergeDocFiles: function(_arg) {
      var commentSections, completeMergedLines, defaultTagOrder, docLines, docTagEnd, docTagStart, mergedLines, srcLines, srcTagEnd, srcTagStart, unmatchedTags, _ref;
      docTagStart = _arg.docTagStart, docTagEnd = _arg.docTagEnd, srcTagStart = _arg.srcTagStart, srcTagEnd = _arg.srcTagEnd, defaultTagOrder = _arg.defaultTagOrder, docLines = _arg.docLines, srcLines = _arg.srcLines;
      commentSections = DocMerger.parseCommentSections(docTagStart, docTagEnd, docLines);
      _ref = DocMerger.mergeCommentTags(srcTagStart, srcTagEnd, commentSections, srcLines), mergedLines = _ref.mergedLines, unmatchedTags = _ref.unmatchedTags;
      completeMergedLines = DocMerger.prependUnmatchedTags(defaultTagOrder, unmatchedTags, mergedLines);
      return completeMergedLines.join('\n');
    },
    parseCommentSections: function(tagPrefix, tagEnd, lines) {
      return lines.reduce(function(_arg, line) {
        var acc, foundTag, tag;
        acc = _arg.acc, tag = _arg.tag;
        foundTag = DocMerger.findTag(tagPrefix, tagEnd, line);
        if (foundTag) {
          tag = foundTag;
          acc[tag] = [];
        } else {
          acc[tag].push(line);
        }
        return {
          acc: acc,
          tag: tag
        };
      }, {
        acc: {
          untagged: []
        },
        tag: "untagged"
      }).acc;
    },
    mergeCommentTags: function(tagPrefix, tagEnd, commentTags, lines) {
      return lines.reduce(function(_arg, line) {
        var foundTag, mergedLines, unmatchedTags;
        mergedLines = _arg.mergedLines, unmatchedTags = _arg.unmatchedTags;
        foundTag = DocMerger.findTag(tagPrefix, tagEnd, line);
        if (foundTag) {
          mergedLines.push('');
          mergedLines = mergedLines.concat(commentTags[foundTag]);
          mergedLines.push('');
          delete commentTags[foundTag];
        } else if (line.length) {
          mergedLines.push('    ' + line);
        } else {
          mergedLines.push('');
        }
        return {
          mergedLines: mergedLines,
          unmatchedTags: unmatchedTags
        };
      }, {
        mergedLines: [],
        unmatchedTags: commentTags
      });
    },
    prependUnmatchedTags: function(defaultTagOrder, unmatchedTags, lines) {
      var firstDocLines, remainingDocLines;
      firstDocLines = defaultTagOrder.reduce(function(unmatchedDocLines, tagName) {
        var tagLines;
        tagLines = unmatchedTags[tagName];
        delete unmatchedTags[tagName];
        return unmatchedDocLines.concat(tagLines);
      }, []);
      firstDocLines.push('');
      remainingDocLines = _.reduce(unmatchedTags, function(remainingDocLines, tagLines, tagName) {
        return remainingDocLines.concat(tagLines);
      }, []);
      remainingDocLines.push('');
      return firstDocLines.concat(remainingDocLines.concat(lines));
    },
    findTag: function(prefix, endChar, line) {
      var match, regex;
      regex = DocMerger.createTagRegex(prefix, endChar);
      match = regex.exec(line);
      if (match && match[1]) {
        return match[1];
      } else {
        return null;
      }
    },
    createTagRegex: _.memoize(function(prefix, endChar) {
      prefix = DocMerger.escapeRegExp(prefix);
      endChar = DocMerger.escapeRegExp(endChar);
      return new RegExp("" + prefix + "([^" + endChar + "]+)" + endChar);
    }),
    escapeRegExp: function(string) {
      return string.replace(/([.*+?^=!:${}()|\[\]\/\\])/g, "\\$1");
    }
  };

  exports.DocMerger = DocMerger;

}).call(this);

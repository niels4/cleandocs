{fileUtil} = require './fileUtil'
_ = require 'lodash'

docTagPrefix = "#*c:"
docTagEndChar = "*"

DocMerger =
  parseCommentSections: (tagPrefix, tagEnd, baseDir, relPath) ->
    lines = fileUtil.getFileLines(baseDir, relPath)
    lines.reduce(
      ({acc, tag}, line) ->
        foundTag = DocMerger.findTag tagPrefix, tagEnd, line
        if foundTag
          tag = foundTag
          acc[tag] = []
        else
          acc[tag].push line
        {acc: acc, tag: tag}
      {acc: {untagged: []}, tag: "untagged"}
    ).acc

  findTag: (prefix, endChar, line) ->
    regex = DocMerger.createTagRegex prefix, endChar
    match = regex.exec(line)
    if match && match[1] then match[1] else null

  createTagRegex: _.memoize (prefix, endChar) ->
    prefix = DocMerger.escapeRegExp prefix
    endChar = DocMerger.escapeRegExp endChar
    new RegExp "#{prefix}([^#{endChar}]+)#{endChar}"

  escapeRegExp: (string) ->
    string.replace(/([.*+?^=!:${}()|\[\]\/\\])/g, "\\$1")
    
exports.DocMerger = DocMerger

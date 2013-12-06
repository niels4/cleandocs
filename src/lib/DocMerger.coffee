{fileUtil} = require './fileUtil'
_ = require 'lodash'

DocMerger =
  parseCommentSections: (tagPrefix, tagEnd, lines) ->
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

  #WARNING: Mutates commentTags!
  mergeCommentTags: (tagPrefix, tagEnd, commentTags, lines) ->
    lines.reduce(
      ({mergedLines, unmatchedTags}, line) ->
        foundTag = DocMerger.findTag tagPrefix, tagEnd, line
        if foundTag
          mergedLines = mergedLines.concat commentTags[foundTag]
          delete commentTags[foundTag]
        else if line.length
          mergedLines.push '    ' + line
        else
          mergedLines.push ''
        {mergedLines: mergedLines, unmatchedTags: unmatchedTags}

      {mergedLines: [], unmatchedTags: commentTags}
    )

  prependUnmatchedTags: (unmatchedTags, lines) ->
    _.each unmatchedTags, (tagLines, tagName) ->
      console.log tagName

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

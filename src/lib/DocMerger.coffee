_ = require 'lodash'

DocMerger =
  mergeDocFiles: ({docTagStart, docTagEnd, srcTagStart, srcTagEnd, defaultTagOrder, docLines, srcLines}) ->
    commentSections = DocMerger.parseCommentSections docTagStart, docTagEnd, docLines
    {mergedLines, unmatchedTags} = DocMerger.mergeCommentTags srcTagStart, srcTagEnd, commentSections, srcLines
    completeMergedLines = DocMerger.prependUnmatchedTags(defaultTagOrder, unmatchedTags, mergedLines)
    completeMergedLines.join '\n'

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
          mergedLines.push ''
          mergedLines = mergedLines.concat commentTags[foundTag]
          mergedLines.push ''
          delete commentTags[foundTag]
        else if line.length
          mergedLines.push '    ' + line
        else
          mergedLines.push ''
        {mergedLines: mergedLines, unmatchedTags: unmatchedTags}

      {mergedLines: [], unmatchedTags: commentTags}
    )

  #WARNING: Mutates unmatchedTags!
  prependUnmatchedTags: (defaultTagOrder, unmatchedTags, lines) ->
    firstDocLines = defaultTagOrder.reduce(
      (unmatchedDocLines, tagName) ->
        tagLines = unmatchedTags[tagName]
        delete unmatchedTags[tagName]
        unmatchedDocLines.concat tagLines

      []
    )
    firstDocLines.push ''

    remainingDocLines = _.reduce(unmatchedTags,
      (remainingDocLines, tagLines, tagName) ->
        remainingDocLines.concat tagLines

      []
    )

    remainingDocLines.push ''

    firstDocLines.concat remainingDocLines.concat lines

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

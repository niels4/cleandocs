path = require 'path'
Finder = require 'fs-finder'
_ = require "lodash"

fileUtil =
  findFilesWithSuffix: (directory, suffix) ->
    files = Finder.from(directory).findFiles "*.#{suffix}"
    files.map _.partial(path.relative, directory)

exports.fileUtil = fileUtil

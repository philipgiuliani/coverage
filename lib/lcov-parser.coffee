parse = require "lcov-parse"

module.exports =
class LcovParser
  constructor: (path) ->
    @lcovData = null

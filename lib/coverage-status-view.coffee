{$$, View} = require 'atom'
path = require 'path'

module.exports =
class CoverageStatusView extends View
  @content: ->
    @div class: 'inline-block', =>
      @span outlet: 'coverageStatus', class: 'coverage-status icon icon-pulse'

  initialize: ->

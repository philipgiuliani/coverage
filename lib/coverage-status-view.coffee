{$$, View} = require 'atom'
path = require 'path'

module.exports =
class CoverageStatusView extends View
  @content: ->
    @div class: 'inline-block', =>
      @span outlet: 'coverageStatus', class: 'coverage-status icon icon-pulse'

  initialize: (panelView) ->
    this.on "click", =>
      panelView.toggle()

  update: (coverage) ->
    color = @coverageColor(coverage)
    @coverageStatus.removeClass("green orange red").addClass(color)

  coverageColor: (coverage) ->
    switch
      when coverage >= 90 then "green"
      when coverage >= 80 then "orange"
      else "red"

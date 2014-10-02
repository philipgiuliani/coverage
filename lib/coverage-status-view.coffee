path = require 'path'

module.exports =
class CoverageStatusView extends HTMLElement
  @content: ->
    @div class: 'coverage-status inline-block', =>
      @span outlet: 'coverageStatusIcon', class: 'icon icon-pulse'
      @span outlet: 'coverageStatusText', class: 'percentage'

  initialize: (panelView) ->
    this.on "click", -> panelView.toggle()
    this.setTooltip title: "Test Coverage"

  notfound: ->
    @coverageStatusIcon.removeClass("green orange red")
    @coverageStatusText.text "not found"

  update: (coverage) ->
    color = @coverageColor(coverage)
    @coverageStatusIcon.removeClass("green orange red").addClass(color)
    @coverageStatusText.text "#{coverage}%"

  coverageColor: (coverage) ->
    switch
      when coverage >= 90 then "green"
      when coverage >= 80 then "orange"
      else "red"

  destroy: ->
    @detach()

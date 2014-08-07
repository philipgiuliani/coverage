CoverageView = require './coverage-view'

module.exports =
  coverageView: null

  activate: (state) ->
    @coverageView = new CoverageView(state.coverageViewState)

  deactivate: ->
    @coverageView.destroy()

  serialize: ->
    coverageViewState: @coverageView.serialize()

fs = require 'fs'
path = require 'path'

CoverageView = require './coverage-view'

module.exports =
  coverageView: null

  activate: (state) ->
    @coverageView = new CoverageView(state.coverageViewState)

    atom.workspaceView.command "coverage:toggle", => @coverageView.toggle()
    atom.workspaceView.command "coverage:refresh", => @refreshReport()

    @update()

  update: ->
    coverageFile = path.resolve(atom.project.path, "coverage/coverage.json") if atom.project.path

    if coverageFile && fs.existsSync(coverageFile)
      fs.readFile coverageFile, "utf8", ((error, data) ->
        return if error

        data = JSON.parse(data)

        @updateView data.metrics, data.files
      ).bind(this)
    else
      console.info "TODO: Coverage file not found"

  updateView: (project, files) ->
    @coverageView.update(project, files)

  deactivate: ->
    @coverageView.destroy()

  serialize: ->
    coverageViewState: @coverageView.serialize()

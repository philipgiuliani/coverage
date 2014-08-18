fs = require 'fs'
path = require 'path'

CoveragePanelView = require './coverage-panel-view'

module.exports =
  coveragePanelView: null

  activate: (state) ->
    @coveragePanelView = new CoveragePanelView(state.coveragePanelViewState)

    atom.workspaceView.command "coverage:toggle", => @coveragePanelView.toggle()
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
    @coveragePanelView.update(project, files)

  deactivate: ->
    @coveragePanelView.destroy()

  serialize: ->
    coveragePanelViewState: @coveragePanelView.serialize()

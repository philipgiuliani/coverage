fs = require 'fs-plus'
path = require 'path'

CoveragePanelView = require './coverage-panel-view'
CoverageStatusView = require './coverage-status-view'

module.exports =
  coveragePanelView: null
  coverageStatusView: null
  coverageFile: null
  pathWatcher: null
  configDefaults:
    refreshOnFileChange: true

  activate: (state) ->
    @coverageFile = path.resolve(atom.project.path, "coverage/coverage.json") if atom.project.path
    @coveragePanelView = new CoveragePanelView

    if @coverageFile and atom.config.get("coverage.refreshOnFileChange") and fs.existsSync(@coverageFile)
      @pathWatcher = fs.watch(@coverageFile, @update)

    atom.packages.once "activated", =>
      if atom.workspaceView.statusBar
        @coverageStatusView = new CoverageStatusView(@coveragePanelView)
        atom.workspaceView.statusBar.appendLeft @coverageStatusView
        @update()

    atom.workspaceView.command "coverage:toggle", => @coveragePanelView?.toggle()
    atom.workspaceView.command "coverage:refresh", => @update()

    @update()

  update: ->
    if @coverageFile and fs.existsSync(@coverageFile)
      fs.readFile @coverageFile, "utf8", ((error, data) ->
        return if error

        data = JSON.parse(data)

        @updateView data.metrics, data.files
        @updateStatusBar data.metrics
      ).bind(this)
    else
      @coverageStatusView?.notfound()

  updateView: (project, files) ->
    @coveragePanelView?.update project, files

  updateStatusBar: (project) ->
    @coverageStatusView?.update Number(project.covered_percent.toFixed(2))

  deactivate: ->
    @coveragePanelView?.destroy()
    @coveragePanelView = null

    @coverageStatusView?.destroy()
    @coverageStatusView = null

    @coverageFile = null

    @pathWatcher?.close()

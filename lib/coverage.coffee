fs = require 'fs-plus'
path = require 'path'

CoveragePanelView = require './coverage-panel-view'
CoverageStatusView = require './coverage-status-view'

module.exports =
  configDefaults:
    coverageFilePath: "coverage/coverage.json"
    refreshOnFileChange: true

  coveragePanelView: null
  coverageStatusView: null
  coverageFile: null
  pathWatcher: null

  activate: ->
    @coverageFile = path.resolve(atom.project.path, atom.config.get("coverage.coverageFilePath")) if atom.project.path
    @coveragePanelView = new CoveragePanelView

    # initialize the pathwatcher if its enabled in the options and the coverage file exists
    if @coverageFile and atom.config.get("coverage.refreshOnFileChange") and fs.existsSync(@coverageFile)
      @pathWatcher = fs.watch @coverageFile, @update.bind(this)

    # add the status bar and refresh the coverage after all packages are loaded
    if atom.workspaceView.statusBar
      @initializeStatusBarView()
    else
      atom.packages.once "activated", =>
        @initializeStatusBarView() if atom.workspaceView.statusBar

    # commands
    atom.workspaceView.command "coverage:toggle", => @coveragePanelView.toggle()
    atom.workspaceView.command "coverage:refresh", => @update()

    # update coverage
    @update()

  initializeStatusBarView: ->
    @coverageStatusView = new CoverageStatusView(@coveragePanelView)
    atom.workspaceView.statusBar.appendLeft @coverageStatusView

    @update()

  update: ->
    if @coverageFile and fs.existsSync(@coverageFile)
      fs.readFile @coverageFile, "utf8", (error, data) =>
        return if error

        data = JSON.parse(data)

        @updatePanelView data.metrics, data.files
        @updateStatusBar data.metrics
    else
      @coverageStatusView?.notfound()

  updatePanelView: (project, files) ->
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

fs = require 'fs-plus'
path = require 'path'

PanelView = require './panel-view'
StatusView = require './status-view'

module.exports =
  config:
    coverageFilePath:
      type: "string"
      default: "coverage/coverage.json"
    refreshOnFileChange:
      type: "boolean"
      default: true

  refreshOnFileChangeSubscription: null
  panelView: null
  statusView: null
  coverageFile: null
  pathWatcher: null

  activate: (state) ->
    @coverageFile = atom.project.resolve(atom.config.get("coverage.coverageFilePath")) if atom.project.path
    @panelView = new PanelView
    @panelView.initialize()

    # initialize the pathwatcher if its enabled in the options and the coverage file exists
    if @coverageFile and atom.config.get("coverage.refreshOnFileChange") and fs.existsSync(@coverageFile)
      @pathWatcher = fs.watch @coverageFile, @update.bind(@)

    # listen for changes on the refreshOnFileChange setting, and initialize the pathwatcher if needed
    @refreshOnFileChangeSubscription = atom.config.observe "coverage.refreshOnFileChange", (refreshOnFileChange) =>
      if refreshOnFileChange
        if @pathWatcher is null and @coverageFile and fs.existsSync(@coverageFile)
          @pathWatcher = fs.watch @coverageFile, @update.bind(@)
      else
        @pathWatcher?.close()
        @pathWatcher = null

    # add the status bar and refresh the coverage after all packages are loaded
    if atom.workspaceView.statusBar
      @initializeStatusBarView()
    else
      atom.packages.once "activated", =>
        @initializeStatusBarView() if atom.workspaceView.statusBar

    # commands
    atom.workspaceView.command "coverage:toggle", => @panelView.toggle()
    atom.workspaceView.command "coverage:refresh", => @update()

    # update coverage
    @update()

  initializeStatusBarView: ->
    @statusView = new StatusView
    @statusView.initialize(@panelView)
    atom.workspaceView.statusBar.appendLeft(@statusView)

    @update()

  update: ->
    if @coverageFile and fs.existsSync(@coverageFile)
      fs.readFile @coverageFile, "utf8", (error, data) =>
        return if error

        data = JSON.parse(data)

        @updatePanelView data.metrics, data.files
        @updateStatusBar data.metrics
    else
      @statusView?.notfound()

  updatePanelView: (project, files) ->
    @panelView.update project, files

  updateStatusBar: (project) ->
    @statusView?.update Number(project.covered_percent.toFixed(2))

  serialize: ->

  deactivate: ->
    @panelView?.destroy()
    @panelView = null

    @statusView?.destroy()
    @statusView = null

    @coverageFile = null

    @pathWatcher?.close()
    @pathWatcher = null

    @refreshOnFileChangeSubscription?.off()

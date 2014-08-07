{View} = require 'atom'
fs = require 'fs'
path = require 'path'

module.exports =
class CoverageView extends View
  @content: ->
    @div class: "coverage tool-panel panel-bottom padded", =>
      @div class: "panel-heading", "Coverage report"
      @div class: "panel-body padded", "Content"

  initialize: (serializeState) ->
    atom.workspaceView.command "coverage:toggle", => @toggle()
    atom.workspaceView.command "coverage:refresh", => @updateReport()

  updateReport: ->
    coverageFile = path.resolve(atom.project.path + "/coverage/coverage.json")

    if atom.project.path && fs.existsSync(coverageFile)
      fs.readFile coverageFile, "utf8", ((error, data) ->
        return if error

        data = JSON.parse(data)
        @updateReportFiles data.files
        @updateReportMetrics data.metrics
      ).bind @
    else
      console.info "Coverage file not found"

  updateReportMetrics: (metrics) ->
    console.log "OK"

  updateReportFiles: (files) ->
    console.log files

  serialize: ->

  destroy: ->
    @detach()

  toggle: ->
    if @hasParent()
      @detach()
    else
      atom.workspaceView.prependToBottom(this)
      @updateReport()

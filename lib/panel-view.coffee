CoverageTableRow = require './coverage-table-row'

class PanelView extends HTMLElement
  # @content: ->
  #   @div class: "coverage-panel tool-panel panel-bottom", =>
  #     @div class: "panel-heading clearfix", =>
  #       @div class: "col-title", =>
  #         @b "Test Coverage"
  #       @div class: "col-progress", "Coverage"
  #       @div class: "col-percent", "Percent"
  #       @div class: "col-lines", "Lines"
  #       @div class: "col-strengh", "Strength"
  #     @div outlet: "coverageContent", class: "panel-body"

  initialize: ->
    @classList.add("coverage-panel", "tool-panel", "panel-bottom")

    panelBody = document.createElement("div")
    panelBody.classList.add("panel-body")
    @appendChild(panelBody)

    table = document.createElement("table")
    @tableBody = document.createElement("tbody")
    table.appendChild(@tableBody)

    panelBody.appendChild(table)

  update: (project, files) ->
    for file in files
      tableRow = new CoverageTableRow
      tableRow.initialize(file)
      @tableBody.appendChild(tableRow)

    #@coverageContent.html @table

    # @coverageContent.html $$ ->
    #   @table =>
    #     if project
    #       @tr =>
    #         @td class: "col-title", =>
    #           @span class: "icon icon-file-directory", "Project"
    #         @td class: "col-progress", =>
    #           @progress class: self.coverageColor(project.covered_percent), max: 100, value: project.covered_percent
    #         @td class: "col-percent", "#{Number(project.covered_percent.toFixed(2))}%"
    #         @td class: "col-lines", "#{project.covered_lines} / #{project.total_lines}"
    #         @td class: "col-strengh", Number(project.covered_strength.toFixed(2))

  serialize: ->

  destroy: ->
    #@detach()

  toggle: ->
    #if @hasParent()
      #@detach()
    #else
      atom.workspaceView.prependToBottom(this)

module.exports = document.registerElement('coverage-panel-view', prototype: PanelView.prototype, extends: 'div')

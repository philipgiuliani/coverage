CoverageTableRow = require './coverage-table-row'

class PanelView extends HTMLElement
  initialize: ->
    @classList.add("coverage-panel", "tool-panel", "panel-bottom")

    # panel body
    panelBody = document.createElement("div")
    panelBody.classList.add("panel-body")
    @appendChild(panelBody)

    # table
    table = document.createElement("table")
    panelBody.appendChild(table)

    # table head
    tableHead = document.createElement("thead")
    tableHead.classList.add("panel-heading")
    table.appendChild(tableHead)

    rowHead = document.createElement("tr")
    tableHead.appendChild(rowHead)

    colTitle = @createColumn("Test Coverage")
    rowHead.appendChild(colTitle)

    colProgress = @createColumn("Coverage")
    rowHead.appendChild(colProgress)

    colPercentage = @createColumn("Percent")
    rowHead.appendChild(colPercentage)

    colLines = @createColumn("Lines")
    rowHead.appendChild(colLines)

    colStrengh = @createColumn("Strength")
    rowHead.appendChild(colStrengh)


    # table body
    @tableBody = document.createElement("tbody")
    table.appendChild(@tableBody)

  createColumn: (content = null) ->
    col = document.createElement("th")
    col.innerHTML = content
    return col

  update: (project, files) ->
    @tableBody.innerHTML = ""

    # add all files
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

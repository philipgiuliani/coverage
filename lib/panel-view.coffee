TableRow = require './table-row'

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

    headerColumns = []
    headerColumns.push @createColumn("Test Coverage")
    headerColumns.push @createColumn("Coverage")
    headerColumns.push @createColumn("Percent")
    headerColumns.push @createColumn("Lines")
    headerColumns.push @createColumn("Strength")
    rowHead.appendChild(column) for column in headerColumns

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
      tableRow = new TableRow
      tableRow.initialize(file)
      @tableBody.appendChild(tableRow)

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
    this.parentNode.removeChild(this)

  toggle: ->
    if this.parentNode
      this.parentNode.removeChild(this)
    else
      atom.workspaceView.prependToBottom(this)

module.exports = document.registerElement('coverage-panel-view', prototype: PanelView.prototype, extends: 'div')

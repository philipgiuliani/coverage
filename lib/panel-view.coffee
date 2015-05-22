TableRow = require './table-row'
Tablesort = require 'tablesort'

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

    rowHead.appendChild @createColumn("Test Coverage")
    rowHead.appendChild @createColumn("Coverage")
    rowHead.appendChild @createColumn("Percent")
    rowHead.appendChild @createColumn("Lines", { sort: false })
    rowHead.appendChild @createColumn("Strength")

    # table body
    @tableBody = document.createElement("tbody")
    table.appendChild(@tableBody)

    @tablesort = new Tablesort(table)

  createColumn: (title, data={}) ->
    col = document.createElement("th")
    col.innerHTML = title
    col.classList.add("no-sort") if data.hasOwnProperty("sort") && data.sort == false
    return col

  update: (project, files) ->
    @tableBody.innerHTML = ""

    if project
      projectRow = new TableRow
      projectRow.initialize("directory", project)
      projectRow.classList.add("no-sort")
      @tableBody.appendChild(projectRow)

    # add all files
    for file in files
      tableRow = new TableRow
      tableRow.initialize("file", file)
      @tableBody.appendChild(tableRow)

    @tablesort.refresh()

  destroy: ->
    @remove() if @parentNode

  toggle: ->
    if @parentNode
      @remove()
    else
      atom.workspace.addBottomPanel(item: this)

module.exports = document.registerElement('coverage-panel-view', prototype: PanelView.prototype, extends: 'div')

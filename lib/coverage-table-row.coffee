path = require 'path'

class CoverageTableRow extends HTMLElement
  initialize: (file) ->
    # title column
    colTitle = @createColumn()
    colTitleIcon = document.createElement("span")
    colTitleIcon.classList.add("icon", "icon-file-text")
    colTitleIcon.dataset.name = path.basename(file.filename)
    colTitleIcon.textContent = atom.project.relativize(file.filename)
    colTitle.appendChild(colTitleIcon)
    @appendChild(colTitle)

    # progress column
    colProgress = @createColumn()
    progressBar = document.createElement("progress")
    progressBar.max = 100
    progressBar.value = file.covered_percent
    progressBar.classList.add @coverageColor(file.covered_percent)
    colProgress.appendChild(progressBar)
    @appendChild(colProgress)

    # percentage column
    colPercentage = @createColumn("#{Number(file.covered_percent.toFixed(2))}%")
    @appendChild(colPercentage)

    # lines column
    colLines = @createColumn("#{file.covered_lines} / #{file.lines_of_code}")
    @appendChild(colLines)

    # strengh column
    colStrengh = @createColumn(Number(file.covered_strength.toFixed(2)))
    @appendChild(colStrengh)

  createColumn: (content = null) ->
    column = document.createElement("td")
    column.innerHTML = content
    return column

  coverageColor: (coverage) ->
    switch
      when coverage >= 90 then "green"
      when coverage >= 80 then "orange"
      else "red"

module.exports = document.registerElement('coverage-table-row', prototype: CoverageTableRow.prototype, extends: 'tr')

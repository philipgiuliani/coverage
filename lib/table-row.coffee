class TableRow extends HTMLElement
  initialize: (type, file) ->
    columns = []

    # title column
    colTitle = @createColumn()
    colTitleIcon = document.createElement("span")
    if type is "directory"
      colTitleIcon.classList.add("icon", "icon-file-directory")
      colTitleIcon.textContent = "Project"
    else
      filePath = atom.project.relativize(file.filename)

      colTitleIcon.classList.add("icon", "icon-file-text")
      colTitleIcon.dataset.name = filePath
      colTitleIcon.textContent = filePath
      colTitleIcon.addEventListener "click", @openFile.bind(this, filePath)

    colTitle.appendChild(colTitleIcon)
    columns.push colTitle

    # progress column
    colProgress = @createColumn()
    colProgress.dataset.sort = file.covered_percent
    progressBar = document.createElement("progress")
    progressBar.max = 100
    progressBar.value = file.covered_percent
    progressBar.classList.add @coverageColor(file.covered_percent)
    colProgress.appendChild(progressBar)
    columns.push colProgress

    # percentage column
    columns.push @createColumn("#{Number(file.covered_percent.toFixed(2))}%")

    # lines column
    totalLines = if type is "directory" then file.total_lines else file.lines_of_code
    columns.push @createColumn("#{file.covered_lines} / #{totalLines}")

    # strengh column
    columns.push @createColumn(Number(file.covered_strength.toFixed(2)))

    @appendChild(column) for column in columns

  createColumn: (content = null) ->
    col = document.createElement("td")
    col.innerHTML = content
    return col

  coverageColor: (coverage) ->
    switch
      when coverage >= 90 then "green"
      when coverage >= 80 then "orange"
      else "red"

  openFile: (filePath) ->
    atom.workspaceView.open(filePath, true)

module.exports = document.registerElement('coverage-table-row', prototype: TableRow.prototype, extends: 'tr')

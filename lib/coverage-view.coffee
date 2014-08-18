{$$, View} = require 'atom'
path = require 'path'

module.exports =
class CoverageView extends View
  @content: ->
    @div class: "coverage tool-panel panel-bottom", =>
      @div class: "panel-heading clearfix", =>
        @div class: "col-title", =>
          @b "Test Coverage"
        @div class: "col-progress", "Coverage"
        @div class: "col-percent", "Percent"
        @div class: "col-lines", "Lines"
        @div class: "col-strengh", "Strength"
      @div outlet: "coverageContent", class: "panel-body"

  initialize: (serializeState) ->

  update: (project, files) ->
    self = this

    @coverageContent.html $$ ->
      @table =>
        if project
          @tr =>
            @td class: "col-title", =>
              @span class: "icon icon-file-directory", "Project"
            @td class: "col-progress", =>
              @progress class: self.progressColor(project.covered_percent), max: 100, value: project.covered_percent
            @td class: "col-percent", "#{Number(project.covered_percent.toFixed(2))}%"
            @td class: "col-lines", "#{project.covered_lines} / #{project.total_lines}"
            @td class: "col-strengh", Number(project.covered_strength.toFixed(2))

        for file in files
          fileName = path.basename(file.filename)
          filePath = atom.project.relativize(file.filename)

          @tr =>
            @td class: "col-title", =>
              @span class: "icon icon-file-text", "data-name": fileName, filePath
            @td class: "col-progress", =>
              @progress class: self.progressColor(file.covered_percent), max: 100, value: file.covered_percent
            @td class: "col-percent", "#{Number(file.covered_percent.toFixed(2))}%"
            @td class: "col-lines", "#{file.covered_lines} / #{file.lines_of_code}"
            @td class: "col-strengh", Number(file.covered_strength.toFixed(2))

  progressColor: (coverage) ->
    switch
      when coverage >= 90 then "green"
      when coverage >= 80 then "orange"
      else "red"

  serialize: ->

  destroy: ->
    @detach()

  toggle: ->
    if @hasParent()
      @detach()
    else
      atom.workspaceView.prependToBottom(this)

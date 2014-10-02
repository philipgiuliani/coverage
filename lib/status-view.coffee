class StatusView extends HTMLElement
  initialize: (panelView) ->
    @classList.add("coverage-status", "inline-block")

    @statusIcon = document.createElement("span")
    @statusIcon.classList.add("icon", "icon-pulse")
    @appendChild(@statusIcon)

    @statusText = document.createElement("span")
    @statusText.classList.add("percentage")
    @appendChild(@statusText)

    @addEventListener "click", -> panelView.toggle()

  notfound: ->
    @statusIcon.classList.remove("green", "orange", "red")
    @statusText.textContent = "not found"

  update: (coverage) ->
    color = @coverageColor(coverage)

    @statusIcon.classList.remove("green", "orange", "red")
    @statusIcon.classList.add(color)
    @statusText.textContent = "#{coverage}%"

  coverageColor: (coverage) ->
    switch
      when coverage >= 90 then "green"
      when coverage >= 80 then "orange"
      else "red"

  destroy: ->
    @remove()

module.exports = document.registerElement('coverage-status-view', prototype: StatusView.prototype, extends: 'div')

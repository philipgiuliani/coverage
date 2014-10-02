class CoverageTableRow extends HTMLElement
  initialize: ->

module.exports = document.registerElement('coverage-table-row', prototype: CoverageTableRow.prototype, extends: 'tr')

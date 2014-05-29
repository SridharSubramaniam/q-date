monthNames = [ "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" ]

describe "q-calendar", ->
  element = null
  scope = null
  $compile = null

  beforeEach angular.mock.module('q-date')
  beforeEach(inject((_$compile_, $rootScope) ->
    scope = $rootScope
    $compile = _$compile_
    return
  ))

  describe 'a basic calendar with no model', ->
    beforeEach ->
      element = $compile("<div data-q-calendar></div>")(scope)
      scope.$digest()

    it 'defaults to the current month', ->
      expect($(element).find('.q-calendar-month-name').text()).toEqual(monthNames[(new Date()).getMonth()])

    it 'has a header row of day abbreviations', ->
      expect($(element).find("table thead tr th:nth-child(1)").text()).toEqual("S")
      expect($(element).find("table thead tr th:nth-child(2)").text()).toEqual("M")

    it "adds a special class to today's date", ->
      expect($(element).find("table td.q-calendar-today").length).toEqual(1)

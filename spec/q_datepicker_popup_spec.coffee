describe "q-datepicker-popup", ->
  element = null
  scope = null
  $compile = null
  datepicker = null

  beforeEach angular.mock.module('q-date')
  beforeEach(inject((_$compile_, $rootScope) ->
    scope = $rootScope
    $compile = _$compile_
    return
  ))

  describe 'a datepicker with no model set', ->
    it 'raises an error', ->
      expect(
        ->
          element = $compile("<div data-q-datepicker-popup></div>")(scope)
          scope.$digest()
      ).toThrow()

  describe 'a basic datepicker attached to a button', ->
    beforeEach ->
      scope.myDate = null
      element = $compile("<button data-q-datepicker-popup ng-model='myDate'>Choose a Date</button>")(scope)
      scope.$digest()
      datepicker = new window.QDatepickerPopupInterface(element)

    describe 'with the model left as null', ->
      it 'defaults to the current month', ->
        expect(datepicker.cal.getTitle().length).toBeGreaterThan(0)
        expect(datepicker.cal.getTitle()).toEqual("#{window.monthNames[(new Date()).getMonth()]} #{(new Date()).getFullYear()}")

      it 'does not add the selected class to any date', ->
        expect($(@element).find('q-calendar-selected').length).toEqual(0)

    describe 'with the model set to April 1, 2014', ->
      beforeEach ->
        scope.myDate = new Date(2014, 3, 1) # 0 index months
        scope.$digest()

      it 'hides the popup by default', ->
        expect(datepicker.popupOpen()).toBeFalsy()

      it 'applies the selected class to the selected date model cell', ->
        expect(datepicker.cal.getDateCell(0, 2).hasClass('q-calendar-selected')).toBeTruthy()

      # Can't get clicking to trigger the popup in the test
      xdescribe 'and the button is clicked', ->
        beforeEach -> datepicker.clickElement()
        it 'shows the popup', ->
          expect(datepicker.popupOpen()).toBeTruthy()

window.monthNames = [ "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" ]
describe "q-calendar", ->
  element = null
  scope = null
  $compile = null
  cal = null

  beforeEach angular.mock.module('q-date')
  beforeEach(inject((_$compile_, $rootScope) ->
    scope = $rootScope
    $compile = _$compile_
    return
  ))

  describe 'a calendar with no model set', ->
    it 'raises an error', ->
      expect(
        ->
          element = $compile("<div data-q-calendar></div>")(scope)
          scope.$digest()
      ).toThrow()

  describe 'a basic calendar', ->
    beforeEach ->
      scope.myDate = null
      element = $compile("<div data-q-calendar ng-model='myDate'></div>")(scope)
      scope.$digest()
      cal = new window.QCalendarInterface(element)

    describe 'with the model left as null', ->
      it 'defaults to the current month', ->
        expect(cal.getTitle().length).toBeGreaterThan(0)
        expect(cal.getTitle()).toEqual("#{window.monthNames[(new Date()).getMonth()]} #{(new Date()).getFullYear()}")

      it 'has a header row of day abbreviations', ->
        expect($(element).find("table thead tr th:nth-child(1)").text()).toEqual("Su")
        expect($(element).find("table thead tr th:nth-child(2)").text()).toEqual("M")

      it "adds a special class to today's date", ->
        expect($(element).find("table td.q-calendar-today").length).toEqual(1)

      it 'does not add the selected class to any date', ->
        expect($(@element).find('q-calendar-selected').length).toEqual(0)

    describe 'with the model set to April 1, 2014', ->
      beforeEach ->
        scope.myDate = new Date(2014, 3, 1) # 0 index months
        scope.$digest()

      it 'shows sets the calendar month to April', ->
        expect(cal.getTitle()).toEqual("April 2014")

      it 'Shows the 1st on the tuesday of the first week', ->
        expect(cal.getDateCell(0, 2).text()).toEqual("1")

      it "Adds 'other' classes to the first day since they are part of March", ->
        $sun = cal.getDateCell(0, 0)
        $mon = cal.getDateCell(0, 1)
        $tue = cal.getDateCell(0, 2)
        expect($sun.text()).toEqual('30')
        cls = "q-calendar-other-month"
        expect($sun.hasClass(cls) && $mon.hasClass(cls)).toBeTruthy()
        expect($tue.hasClass(cls)).toBeFalsy()

      it "Adds 'other' classes to the last 3 days since they are part of May", ->
        $wed = cal.getDateCell("last", 3)
        $thu = cal.getDateCell("last", 4)
        $fri = cal.getDateCell("last", 5)
        $sat = cal.getDateCell("last", 6)
        expect($wed.text()).toEqual('30')
        expect($thu.text()).toEqual('1')
        cls = "q-calendar-other-month"
        expect($wed.hasClass(cls)).toBeFalsy()
        for day in [$thu, $fri, $sat]
          expect(day.hasClass(cls)).toBeTruthy()

      it 'applies the selected class to the selected date model cell', ->
        expect(cal.getDateCell(0, 2).hasClass('q-calendar-selected')).toBeTruthy()

      describe 'And I click the Next month button', ->
        beforeEach ->
          cal.clickNextMonth()

        it 'updates the month name to May', ->
          expect(cal.getTitle()).toEqual("May 2014")

      describe 'And I click the Prev month button', ->
        beforeEach ->
          cal.clickPrevMonth()

        it 'updates the month name to March', ->
          expect(cal.getTitle()).toEqual("March 2014")

      describe 'And I click the next year button', ->
        beforeEach ->
          cal.clickNextYear()

        it 'updates the year in the title to 2015', ->
          expect(cal.getTitle()).toEqual("April 2015")

      describe 'And I click the prev year button', ->
        beforeEach ->
          cal.clickPrevYear()

        it 'updates the year in the title to 2013', ->
          expect(cal.getTitle()).toEqual("April 2013")

      describe 'And I click on April 15', ->
        beforeEach ->
          cal.clickCalendarCell(2, 2)

        it 'updates the selected date model to April 15', ->
          expect(scope.myDate.getMonth()).toEqual(3)
          expect(scope.myDate.getDate()).toEqual(15)

        it 'applies the selected class to the cell and no other cells', ->
          expect(cal.getDateCell(2, 2).hasClass('q-calendar-selected')).toBeTruthy()
          expect($(element).find('.q-calendar-selected').length).toEqual(1)

      describe 'And I click on March 30', ->
        beforeEach ->
          cal.clickCalendarCell(0, 0)

        it 'updates the selected date model to March 30', ->
          expect(scope.myDate.getMonth()).toEqual(2)
          expect(scope.myDate.getDate()).toEqual(30)

        it 'switches the month to March', ->
          expect(cal.getTitle()).toEqual("March 2014")

        it 'updates the date model on the scope', ->
          expect(scope.myDate.getMonth()).toEqual(2) # 0-indexed months

      describe 'And the selected date is changed to July 1 outside the directive', ->
        beforeEach ->
          scope.myDate = new Date(2014, 6, 1)
          scope.$apply()

        it 'switches the calendar to July', ->
          expect(cal.getTitle()).toEqual("July 2014")

      describe 'And the selected date is changed to null outside the directive', ->
        beforeEach ->
          scope.myDate = null
          scope.$apply()

        it 'removes the selected class from the cell', ->
          expect($(element).find('.q-calendar-selected').length).toEqual(0)

        it 'does not change the month shown', ->
          expect(cal.getTitle()).toEqual("April 2014")

    describe 'a calendar whose model is set to May 15, 2014', ->
      beforeEach ->
        scope.myDate = new Date(2014, 4, 15)
        scope.$digest()

      it 'shows the 1st on the first thursday', ->
        expect(cal.getDateCell(0, 4).text()).toEqual("1")

  describe 'a calendar that has a date filter that disables weekends', ->
    beforeEach ->
      scope.myDate = new Date(2014, 4, 1)
      scope.noWeekends = (d) -> d.getDay() > 0 && d.getDay() < 6
      element = $compile("<div data-q-calendar ng-model='myDate' date-filter='noWeekends'></div>")(scope)
      scope.$digest()
      cal = new QCalendarInterface(element)

    it 'adds a disabled class to all weekend table cells', ->
      thur1 = cal.getDateCell(0, 4)
      sat1 = cal.getDateCell(0, 6)
      sun1 = cal.getDateCell(1, 0)
      mon1 = cal.getDateCell(1, 1)
      sat2 = cal.getDateCell(1, 6)

      for td in [sat1, sun1, sat2]
        expect($(td).hasClass('q-calendar-disabled')).toBeTruthy()
      for td in [thur1, mon1]
        expect($(td).hasClass('q-calendar-disabled')).toBeFalsy()

    describe 'and a weekend cell is clicked', ->
      beforeEach ->
        cal.clickCalendarCell(0, 6)

      it 'does not update the model', ->
        expect(scope.myDate.getDay()).not.toEqual(6)
        expect(scope.myDate.getMonth()).toEqual(4)
        expect(scope.myDate.getDate()).toEqual(1)

      it 'maintains the same selected cell', ->
        expect(cal.getDateCell(0, 6).hasClass('q-calendar-selected')).toBeFalsy()
        expect(cal.getDateCell(0, 4).hasClass('q-calendar-selected')).toBeTruthy()

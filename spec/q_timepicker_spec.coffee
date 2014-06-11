class QTimepickerInterface
  constructor: (element) ->
    @element = $(element)
    @scope = element.scope()
  hourSelect: => $(@element).find(".q-timepicker-hour")
  minuteSelect: => $(@element).find(".q-timepicker-minute")
  amPmSelect: => $(@element).find(".q-timepicker-ampm")

  getHour: =>
    $(@element).find(".q-timepicker-hour option:selected").text()


  getMinute: =>
    $(@element).find(".q-timepicker-minute option:selected").text()

  getAmPm: =>
    if $(@element).find(".q-timepicker-ampm").length
      $(@element).find(".q-timepicker-ampm option:selected").text()
    else
      null

  setHourSelect: (hour) =>
    $(@element).find(".q-timepicker-hour option").each((i, opt) =>
      if $(opt).text() == "#{hour}"
        @hourSelect().val($(opt).val())
        @hourSelect().trigger('change')
        return false
    )

  setMinuteSelect: (min) =>
    $(@element).find(".q-timepicker-minute option").each((i, opt) =>
      if $(opt).text() == "#{min}"
        @minuteSelect().val($(opt).val())
        @minuteSelect().trigger('change')
        return false
    )

  setAmPmSelect: (val) =>
    $(@element).find(".q-timepicker-ampm").val(val.toLowerCase())
    @minuteSelect().trigger('change')
    return

  getTimeShown: =>
    t = "#{@getHour()}:#{@getMinute()}"
    ampm =  @getAmPm()
    t = if ampm then "#{t} #{ampm}" else t
    if t?
      t = t.trim()
      if t == ":"
        t = ""
    t

describe "q-timepicker", ->
  element = null
  scope = null
  $compile = null
  picker = null

  beforeEach angular.mock.module('q-date')
  beforeEach(inject((_$compile_, $rootScope) ->
    scope = $rootScope
    $compile = _$compile_
    return
  ))

  describe 'a timepicker with no model set', ->
    it 'raises an error', ->
      expect(
        ->
          element = $compile("<div data-q-timepicker></div>")(scope)
          scope.$digest()
      ).toThrow()

  describe 'a timepicker no use-am-pm value set', ->
    beforeEach ->
      scope.myDate = null
      element = $compile("<div data-q-timepicker ng-model='myDate'></div>")(scope)
      scope.$apply()
      picker = new QTimepickerInterface(element)
      return

    it 'defaults to showing the AM/PM select', ->
      expect($(element).find(".q-timepicker-ampm").length).toEqual(1)
      expect($(element).find(".q-timepicker-ampm").attr('class')).not.toMatch("ng-hide")


  describe 'a basic timepicker with am-pm set to true', ->
    beforeEach ->
      scope.myDate = null
      element = $compile("<div data-q-timepicker ng-model='myDate'></div>")(scope)
      scope.$apply()
      picker = new QTimepickerInterface(element)
      return

    it 'defaults to showing the AM/PM select', ->
      expect($(element).find(".q-timepicker-ampm").length).toEqual(1)

    describe 'with the model set to null', ->
      it 'defaults to blank values', ->
        expect(picker.getTimeShown()).toEqual("")

      describe 'and the hour is set to 5', ->
        beforeEach -> picker.setHourSelect(5)
        it 'sets the time to 5:00 AM', ->
          expect(picker.getTimeShown()).toEqual("5:00 AM")

        describe 'and the minute is set to 28', ->
          beforeEach -> picker.setMinuteSelect(28)
          it 'sets the time to 5:28 AM', ->
            expect(picker.getTimeShown()).toEqual("5:28 AM")

          describe 'and it is set to PM', ->
            beforeEach -> picker.setAmPmSelect('pm')
            it 'sets the time to 5:28 PM', ->
              expect(picker.getTimeShown()).toEqual("5:28 PM")

    describe 'with the model set to a date at 12:05 AM', ->
      beforeEach ->
        scope.myDate = new Date(2014, 5, 5, 0, 5)
        scope.$apply()

      it 'shows the proper time in 12-hour format', ->
        expect(picker.getTimeShown()).toEqual("12:05 AM")
        scope.myDate = new Date(2014, 5, 5, 23, 59)
        scope.$apply()
        expect(picker.getTimeShown()).toEqual("11:59 PM")
        scope.myDate = new Date(2014, 5, 5, 0, 0)
        scope.$apply()
        expect(picker.getTimeShown()).toEqual("12:00 AM")

      describe 'and the date object is incremented by 5 minutes from the outside', ->
        beforeEach ->
          scope.myDate = new Date(scope.myDate.setMinutes(10))
          scope.$digest()

        it 'is reflected in the select boxes', ->
          expect(picker.getTimeShown()).toEqual("12:10 AM")

      describe 'and the hour select is set to 9', ->
        beforeEach -> picker.setHourSelect(9)
        it 'changes the displayed time to 9:05', ->
          expect(picker.getTimeShown()).toEqual('9:05 AM')
        it 'changes the model time to 9:05', ->
          scope.$apply()
          expect(scope.myDate.getHours()).toEqual(9)
          expect(scope.myDate.getMinutes()).toEqual(5)

  describe 'a timepicker with am-pm set to false', ->
    beforeEach ->
      scope.myDate = new Date(2014, 5, 5, 0, 5)
      element = $compile("<div data-q-timepicker ng-model='myDate' use-am-pm='false'></div>")(scope)
      scope.$apply()
      picker = new QTimepickerInterface(element)
      return

    it 'does not show the am-pm select', ->
      expect($(element).find(".q-timepicker-ampm").attr('class')).toMatch("ng-hide")

    it 'shows the proper time in 24-hour format', ->
      expect(picker.getTimeShown()).toEqual("0:05")
      scope.myDate = new Date(2014, 5, 5, 23, 59)
      scope.$apply()
      expect(picker.getTimeShown()).toEqual("23:59")
      scope.myDate = new Date(2014, 5, 5, 0, 0)
      scope.$apply()
      expect(picker.getTimeShown()).toEqual("0:00")

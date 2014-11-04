angular.module("q-date").directive "qTimepicker", (qDateDefaults, qDateUtil, $filter) ->
  {
    restrict: "EA"
    replace: true
    require: '^ngModel'
    scope: {}
    link: (scope, elem, attrs, modelCtrl) ->
      init = ->
        setSelectOptions()
        setupParsers()
        setupWatches()

      setSelectOptions = ->
        scope.useAmPm = if attrs.useAmPm? then (attrs.useAmPm == true || attrs.useAmPm == 'true') else true
        scope.hourOptions = if scope.useAmPm then [1..12] else [0..23]
        scope.minuteOptions = [0..59]

      modelCtrl.$render = ->
        if modelCtrl.$modelValue?
          setDateTimeFromDateObject(modelCtrl.$modelValue)

      setDateTimeFromDateObject = (val) ->
        if val && qDateUtil.isDateObject(val)
          hoursMinutes = qDateUtil.getHoursMinutes(val, scope.useAmPm)
          scope.hour = hoursMinutes[0]
          scope.minute = hoursMinutes[1]
          scope.ampm = hoursMinutes[2] if scope.useAmPm
        else
          scope.hour = null
          scope.minute = null
          scope.ampm = null

      setupParsers = ->
        modelCtrl.$parsers.unshift((viewVal) ->
          if qDateUtil.isDateObject(viewVal)
            viewVal
          else
            d = new Date(viewVal)
            if isNaN(viewVal) then d else null
        )
        modelCtrl.$formatters.unshift((viewVal) ->
          setDateTimeFromDateObject(viewVal)
        )

      setDateFromSelects = ->
        if modelCtrl.$modelValue? && qDateUtil.isDateObject(modelCtrl.$modelValue)
          d = new Date(modelCtrl.$modelValue)
        else
          d = qDateUtil.todayStart()
        if scope.hour?
          if (scope.useAmPm && scope.ampm == "pm") && (scope.hour < 12)
            d.setHours(parseInt(scope.hour + 12))
          else if scope.hour == 12 && scope.ampm == 'am'
            d.setHours(0)
          else
            d.setHours(parseInt(scope.hour))
        else
          scope.hour = 0
        if scope.minute?
          d.setMinutes(parseInt(scope.minute))
        else
          scope.minute = 0
        if scope.useAmPm && !scope.ampm?
          scope.ampm = "am"
        modelCtrl.$setViewValue(d)

      setupWatches = ->
        scope.$watch('hour', (newVal, oldVal) ->
          return unless newVal? && newVal != oldVal
          setDateFromSelects()
        )
        scope.$watch('minute', (newVal, oldVal) ->
          return unless newVal? && newVal != oldVal
          setDateFromSelects()
        )
        if scope.useAmPm
          scope.$watch('ampm', (newVal, oldVal) ->
            return unless newVal? && newVal != oldVal
            setDateFromSelects()
          )

      init()

    template: """
                <div class='q-timepicker'>
                  <select class='q-timepicker-hour' ng-model='hour' ng-options='hour as hour for hour in hourOptions'>
                  </select>
                  <select class='q-timepicker-minute' ng-model='minute' ng-options="min as ((min < 10) ? ('0' + min) : min) for min in minuteOptions">
                  </select>
                  <select class='q-timepicker-ampm' ng-model='ampm' ng-show='useAmPm' >
                    <option value='am'>AM</option>
                    <option value='pm'>PM</option>
                  </select>
                </div>
              """
  }

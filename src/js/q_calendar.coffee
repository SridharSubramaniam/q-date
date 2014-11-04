angular.module("q-date").directive "qCalendar", ($sce, qDateDefaults, qDateUtil) ->
  {
    restrict: "EA"
    replace: true
    require: '^ngModel'
    scope: {
      dateFilter: '=?'
    }
    link: (scope, elem, attrs, modelCtrl) ->

      init = ->
        setupParsers()
        setupViewActions()
        scope.translations = qDateDefaults.translations
        for key, value of scope.translations
          if typeof value == "string"
            scope.translations[key] = $sce.trustAsHtml(value)

      refreshView = ->
        setupCalendarTable()

      modelCtrl.$render = ->
        setMonthDate() unless scope.monthDate && !modelCtrl.$viewValue
        refreshView()

      setMonthDate = (calledFrom=null) ->
        scope.monthDate = if modelCtrl && modelCtrl.$viewValue then new Date(modelCtrl.$viewValue) else new Date()
        scope.monthDate.setDate(1)

      # This parses the model value that comes in from the view
      setupParsers = ->
        modelCtrl.$parsers.push((viewVal) ->
          if qDateUtil.isDateObject(viewVal)
            viewVal
          else
            d = new Date(viewVal)
            if isNaN(viewVal) then d else null
        )

      setupViewActions = ->
        scope.nextMonth = ->
          scope.monthDate = qDateUtil.incrementMonth(scope.monthDate, 1)
          refreshView()
        scope.prevMonth = ->
          scope.monthDate = qDateUtil.incrementMonth(scope.monthDate, -1)
          refreshView()
        scope.nextYear = ->
          scope.monthDate.setFullYear(scope.monthDate.getFullYear() + 1)
          refreshView()
        scope.prevYear = ->
          scope.monthDate.setFullYear(scope.monthDate.getFullYear() - 1)
          refreshView()
        scope.setDate = (d) ->
          return if (typeof(scope.dateFilter) == 'function') && !scope.dateFilter(d)
          modelCtrl.$setViewValue(d)
          if modelCtrl.$viewValue && !qDateUtil.datesAreEqualToMonth(modelCtrl.$viewValue, scope.monthDate)
            setMonthDate()
          refreshView()

      setupCalendarTable = ->
        offset = scope.monthDate.getDay()
        daysInMonth = qDateUtil.getDaysInMonth(scope.monthDate.getFullYear(), scope.monthDate.getMonth())
        numRows = Math.ceil((offset + daysInMonth) / 7)
        weeks = []
        iDate = new Date(scope.monthDate)
        iDate.setDate(iDate.getDate() + (offset * -1))
        for row in [0..(numRows-1)]
          weeks.push([])
          for day in [0..6]
            d = new Date(iDate)
            selected = modelCtrl.$modelValue && d && qDateUtil.datesAreEqualToDay(d, modelCtrl.$modelValue)
            today = qDateUtil.datesAreEqualToDay(d, new Date())
            weeks[row].push({
              date: d
              isSelected: selected
              isDisabled: if (typeof(scope.dateFilter) == 'function') then !scope.dateFilter(d) else false
              isOtherMonth: d.getMonth() != scope.monthDate.getMonth()
              isToday: today
            })
            iDate.setDate(iDate.getDate() + 1)
        scope.weeks = weeks

      init()

    template: """
                <div class='q-calendar'>
                  <table class='q-calendar-month'>
                    <caption>
                      <span title='Previous Year' class='q-calendar-prev-year' data-ng-click='prevYear()'></span>
                      <span title='Previous Month' class='q-calendar-prev-month' data-ng-click='prevMonth()'></span>
                      <span class='q-calendar-title' ng-bind="monthDate | date:'MMMM yyyy'"></span>
                      <span title='Next Year' class='q-calendar-next-year' data-ng-click='nextYear()'></span>
                      <span title='Next Month' class='q-calendar-next-month' data-ng-click='nextMonth()'></span>
                    </caption>
                    <thead>
                      <tr>
                        <th data-ng-repeat='abbr in translations.dayAbbreviations'><span data-ng-bind='abbr'></span></th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr ng-repeat='week in weeks'>
                        <td ng-repeat='day in week' ng-class="{'q-calendar-today': day.isToday, 'q-calendar-other-month': day.isOtherMonth, 'q-calendar-selected': day.isSelected, 'q-calendar-disabled': day.isDisabled}" ng-click='setDate(day.date)'><span ng-bind="day.date | date:'d'"></span></td>
                      </tr>
                    </tbody>
                  </table>
                </div>
              """
  }

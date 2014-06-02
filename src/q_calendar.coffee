angular.module("q-date").directive "qCalendar", ['$sce', 'qDateDefaults', 'qDateUtil', ($sce, qDateDefaults, qDateUtil) ->
  {
    restrict: "EA"
    replace: true
    require: '^ngModel'
    link: (scope, elem, attrs, modelCtrl) ->

      init = ->
        setupParsers()
        setupViewActions()
        scope.translations = qDateDefaults.translations
        scope.$watch(attrs.ngModel, ->
          setMonthDate()
          refreshView()
        )
        for key, value of scope.translations
          if typeof value == "string"
            scope.translations[key] = $sce.trustAsHtml(value)

      refreshView = ->
        setupCalendarTable()

      modelCtrl.$render = ->
        setMonthDate()
        refreshView()

      setMonthDate = ->
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

      # setupFormatters = ->
      #   modelCtrl.$formatters.push((val) ->
      #     console.log "FORMATTER", val
      #     val
      #   )

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
          modelCtrl.$setViewValue(d)
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
              isDisabled: false
              # disabled: if (typeof(scope.dateFilter) == 'function') then !scope.dateFilter(d) else false
              isOtherMonth: d.getMonth() != scope.monthDate.getMonth()
              isToday: today
            })
            iDate.setDate(iDate.getDate() + 1)
        scope.weeks = weeks
        # days: [{date: new Date(), isToday: true}]

      init()

    template: """
                <div class='q-calendar'>
                  <table class='q-calendar-month'>
                    <caption>
                      <span class='q-calendar-prev-year' data-ng-click='prevYear()' data-ng-bind-html='translations.prevYear'></span>
                      <span class='q-calendar-prev-month' data-ng-click='prevMonth()' data-ng-bind-html='translations.prevMonth'></span>
                      <span class='q-calendar-title' ng-bind="monthDate | date:'MMMM yyyy'"></span>
                      <span class='q-calendar-next-year' data-ng-click='nextYear()' data-ng-bind-html='translations.nextYear'></span>
                      <span class='q-calendar-next-month' data-ng-click='nextMonth()' data-ng-bind-html='translations.nextMonth'></span>
                    </caption>
                    <thead>
                      <tr>
                        <th data-ng-repeat='abbr in translations.dayAbbreviations' data-ng-bind='abbr'></th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr ng-repeat='week in weeks'>
                        <td ng-repeat='day in week' ng-bind="day.date | date:'d'" ng-class="{'q-calendar-today': day.isToday, 'q-calendar-other-month': day.isOtherMonth, 'q-calendar-selected': day.isSelected}" ng-click='setDate(day.date)'></td>
                      </tr>
                    </tbody>
                  </table>
                </div>
              """
  }
]

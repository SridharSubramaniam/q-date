app = angular.module("q-date", [])

app.directive "qCalendar", ->
  {
    restrict: "EA"
    replace: true
    require: '?ngModel'
    scope: {

    }
    link: (scope, elem, attrs, modelCtrl) ->
      scope.monthDate = if modelCtrl && modelCtrl.$modelValue then new Date(modelCtrl.$modelValue) else new Date()
      scope.selectedDate = if modelCtrl && modelCtrl.$modelValue then modelCtrl.$modelValue else new Date()

    controller: ['$scope', ($scope) ->
      setupMonthArray = ->
        $scope.weeks = [
          {
            days: [{date: new Date(), isToday: true}]
          }
        ]

      refreshView = ->
        setupMonthArray()

      refreshView()
    ]

    template: """
                <div class='q-calendar'>
                  <table class='q-calendar-month'>
                    <caption>
                      <span class='q-calendar-month-name' ng-bind="monthDate | date:'MMMM'"></span>
                    </caption>
                    <thead>
                      <tr>
                        <th>S</th>
                        <th>M</th>
                        <th>T</th>
                        <th>W</th>
                        <th>R</th>
                        <th>F</th>
                        <th>S</th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr ng-repeat='week in weeks'>
                        <td ng-repeat='day in week.days' ng-bind="day.date | date:'dd'" ng-class="{'q-calendar-today': day.isToday}"></td>
                      </tr>
                    </tbody>
                  </table>
                </div>
              """
  }

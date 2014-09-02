pickerDirective = ($compile, qDateDefaults, qDateUtil) ->
  {
    restrict: "A"
    require: "^ngModel",
    scope: {
      ngModel: '='
      isOpen: '=?'
    }
    link: (scope, elem, attrs, ngModelCtrl) ->
      scope.isOpen = false unless scope.isOpen
      elem.wrap("<div class='q-datepicker-input-wrapper'></div>")

      # Popup View Actions
      scope.togglePopup = ->
        scope.isOpen = !scope.isOpen
        
      scope.closePopup = ->
        scope.isOpen = false

      scope.openPopup = ->
        scope.isOpen = true


      # Append the popup
      console.log "ATTRS:", attrs
      tmpl = if attrs.qDateTimePicker?
          """
            <div class='q-datepicker-popup' data-ng-show='isOpen'>
              <div data-foo='{{isOpen}}' class='q-datepicker-popup-close' ng-click='closePopup()'></div>
              <div data-q-calendar data-ng-model='ngModel'></div>
              <div data-q-timepicker data-ng-model='ngModel'></div>
            </div>
          """
      else
          """
            <div class='q-datepicker-popup' data-ng-show='isOpen'>
              <div data-foo='{{isOpen}}' class='q-datepicker-popup-close' ng-click='closePopup()'></div>
              <div data-q-calendar data-ng-model='ngModel'></div>
            </div>
          """
      popupDiv = angular.element(tmpl)
      $popup = $compile(popupDiv)(scope)
      angular.element(elem).after($popup)

      # Show popup on input focus or click, depending on type of element
      if elem[0].tagName == "INPUT"
        elem.on "focus", (e) ->
          scope.$apply -> scope.openPopup()
      else
        elem.on "click", (e) ->
          scope.$apply -> scope.togglePopup()

      # Close on window click except when the popup is clicked
      datepickerClicked = false
      elem.parent().on "click", (e) ->
        datepickerClicked = true
      window.document.addEventListener "click", (e) ->
        if !datepickerClicked
          scope.$apply -> scope.closePopup()
        datepickerClicked = false

  }


angular.module("q-date").directive "qDatePicker", pickerDirective
angular.module("q-date").directive "qDateTimePicker", pickerDirective

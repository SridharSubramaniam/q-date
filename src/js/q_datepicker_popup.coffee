pickerDirective = ["$compile", "qDateDefaults", "qDateUtil", ($compile, qDateDefaults, qDateUtil) ->
  {
    restrict: "A"
    require: "^ngModel",
    scope: {
      ngModel: '='
      isOpen: '=?'
    }
    link: (scope, elem, attrs, ngModelCtrl) ->
      init = ->
        scope.isOpen = false unless scope.isOpen
        setupViewActions()
        setupTemplate()
        setupPopupClosing()

      setupViewActions = ->
        # Popup View Actions
        scope.togglePopup = ->
          scope.isOpen = !scope.isOpen
          
        scope.closePopup = ->
          scope.isOpen = false

        scope.openPopup = ->
          scope.isOpen = true

        # Setup Events
        if elem[0].tagName == "INPUT"
          elem.on 'focus', (e) ->
            e.preventDefault()
            scope.openPopup()
        else
          elem.on 'click', (e) ->
            e.preventDefault()
            scope.togglePopup()

      setupTemplate = ->
        elem.wrap("<div class='q-datepicker-popup-input-wrapper'></div>")

        topOffset = if qDateDefaults.popupTopOffset then qDateDefaults.popupTopOffset else elem[0].offsetHeight + 5
        leftOffset = if qDateDefaults.popupTopOffset then qDateDefaults.popupTopOffset else 0
        style = "top: #{topOffset}px; left: #{leftOffset}px;"

        # Append the popup
        tmpl = """
                 <div class='q-datepicker-popup' data-ng-show='isOpen' style='#{style}'>
                   <div class='q-datepicker-popup-close' data-ng-click='closePopup()'></div>
                   <div data-q-calendar data-ng-model='ngModel'></div>
               """
        if attrs.qDatetimepickerPopup?
          tmpl += "<div data-q-timepicker data-ng-model='ngModel'></div>"
        tmpl += "</div>"

        popupDiv = angular.element(tmpl)
        $popup = $compile(popupDiv)(scope)
        angular.element(elem).after($popup)

      setupPopupClosing = ->
        # Close on window click except when the popup is clicked
        datepickerClicked = false
        elem.parent().on "click", (e) ->
          datepickerClicked = true
        window.document.addEventListener "click", (e) ->
          if !datepickerClicked
            scope.$apply -> scope.closePopup()
          datepickerClicked = false

      init()
  }
]

angular.module("q-date").directive "qDatepickerPopup", pickerDirective
angular.module("q-date").directive "qDatetimepickerPopup", pickerDirective

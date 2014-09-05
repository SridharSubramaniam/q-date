class QDatepickerPopupInterface
  constructor: (element) ->
    @$attachedTo = $(element)
    @$popup = $(element).next()
    @cal = new window.QCalendarInterface($(element).next().find(".q-calendar"))
    @timepicker = new window.QTimepickerInterface($(element).next().find(".q-timepikcer"))
    @scope = element.scope()

  popupOpen: =>
    !@$popup.hasClass("ng-hide")

  clickElement: =>
    @$attachedTo.click()

window.QDatepickerPopupInterface = QDatepickerPopupInterface

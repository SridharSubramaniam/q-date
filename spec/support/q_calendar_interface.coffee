class QCalendarInterface
  constructor: (element) ->
    @element = $(element)
    @scope = element.scope()

  getTitle: =>
    $(@element).find(".q-calendar-title").text()

  getTodayCell: =>
    $(@element).find("table tbody .q-calendar-today")

  getDateCell: (w, d) =>
    weekSelector = if typeof w == "string" then w else "nth-child(#{w + 1})"
    daySelector = if typeof d == "string" then d else "nth-child(#{d + 1})"
    $(@element).find("table tbody tr:#{weekSelector} td:#{daySelector}")

  clickNextMonth: =>
    $(@element).find(".q-calendar-next-month").click()

  clickPrevMonth: =>
    $(@element).find(".q-calendar-prev-month").click()

  clickNextYear: =>
    $(@element).find(".q-calendar-next-year").click()

  clickPrevYear: =>
    $(@element).find(".q-calendar-prev-year").click()

  clickCalendarCell: (w, d) =>
    $td = @getDateCell(w, d)
    $td.click()

window.QCalendarInterface = QCalendarInterface

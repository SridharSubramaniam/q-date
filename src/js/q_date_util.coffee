angular.module("q-date").factory "qDateUtil", ->
  getDaysInMonth: (year, month) ->
    [31, (if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0) then 29 else 28), 31, 30, 31, 30, 31, 31, 30, 31, 30, 31][month]

  datesAreEqualToMonth: (d1, d2) ->
    d1 && d2 && (d1.getYear() == d2.getYear()) && (d1.getMonth() == d2.getMonth())

  datesAreEqualToDay: (d1, d2) ->
    d1 && d2 && (d1.getYear() == d2.getYear()) && (d1.getMonth() == d2.getMonth()) && (d1.getDate() == d2.getDate())

  datesAreEqualToMinute: (d1, d2) ->
    return false unless d1 && d2
    parseInt(d1.getTime() / 60000) == parseInt(d2.getTime() / 60000)

  isDateObject: (d) ->
    d instanceof Date

  todayStart: ->
    d = new Date()
    d.setHours(0)
    d.setMinutes(0)
    d.setSeconds(0)
    d.setMilliseconds(0)
    d

  incrementMonth: (d, delta) ->
    nd = new Date(d)
    m = nd.getMonth()
    nd.setMonth(m + delta)
    nd

  getHoursMinutes: (d, useAmPm) ->
    unless @isDateObject(d)
      throw 'Not a date object' 
    h = d.getHours()
    m = d.getMinutes()
    if useAmPm
      ampm = if h < 12 then 'am' else 'pm'
      h = (h % 12) || 12
      [h, m, ampm]
    else
      [h, m]

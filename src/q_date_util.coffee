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

  incrementMonth: (d, delta) ->
    nd = new Date(d)
    m = nd.getMonth()
    nd.setMonth(m + delta)
    nd

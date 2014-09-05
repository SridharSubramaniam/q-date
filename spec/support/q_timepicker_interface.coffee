class QTimepickerInterface
  constructor: (element) ->
    @element = $(element)
    @scope = element.scope()
  hourSelect: => $(@element).find(".q-timepicker-hour")
  minuteSelect: => $(@element).find(".q-timepicker-minute")
  amPmSelect: => $(@element).find(".q-timepicker-ampm")

  getHour: =>
    $(@element).find(".q-timepicker-hour option:selected").text()


  getMinute: =>
    $(@element).find(".q-timepicker-minute option:selected").text()

  getAmPm: =>
    if $(@element).find(".q-timepicker-ampm").length
      $(@element).find(".q-timepicker-ampm option:selected").text()
    else
      null

  setHourSelect: (hour) =>
    $(@element).find(".q-timepicker-hour option").each((i, opt) =>
      if $(opt).text() == "#{hour}"
        @hourSelect().val($(opt).val())
        @hourSelect().trigger('change')
        return false
    )

  setMinuteSelect: (min) =>
    $(@element).find(".q-timepicker-minute option").each((i, opt) =>
      if $(opt).text() == "#{min}"
        @minuteSelect().val($(opt).val())
        @minuteSelect().trigger('change')
        return false
    )

  setAmPmSelect: (val) =>
    $(@element).find(".q-timepicker-ampm").val(val.toLowerCase())
    @minuteSelect().trigger('change')
    return

  getTimeShown: =>
    t = "#{@getHour()}:#{@getMinute()}"
    ampm =  @getAmPm()
    t = if ampm then "#{t} #{ampm}" else t
    if t?
      t = t.trim()
      if t == ":"
        t = ""
    t

window.QTimepickerInterface = QTimepickerInterface

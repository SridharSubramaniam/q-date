app = angular.module("q-date", [])

app.provider "qDateDefaults", ->
  {
    options: {
      translations: {
        dayAbbreviations: ["Su", "M", "Tu", "W", "Th", "F", "Sa"],
        nextMonth: "&rsaquo;"
        prevMonth: "&lsaquo;"
        nextYear: "&raquo;"
        prevYear: "&laquo;"
      }
    }
      # dateFormat: 'M/d/yyyy'
      # timeFormat: 'h:mm a'
      # labelFormat: null
      # placeholder: 'Click to Set Date'
      # hoverText: null
      # buttonIconHtml: null
      # closeButtonHtml: '&times;'
      # nextLinkHtml: 'Next &rarr;'
      # prevLinkHtml: '&larr; Prev'
      # disableTimepicker: false
      # disableClearButton: false
      # defaultTime: null
      # dayAbbreviations: ["Su", "M", "Tu", "W", "Th", "F", "Sa"],
      # dateFilter: null
      # parseDateFunction: (str) ->
      #   seconds = Date.parse(str)
      #   if isNaN(seconds)
      #     return null
      #   else
      #     new Date(seconds)
    # }
    $get: ->
      @options

    set: (keyOrHash, value) ->
      if typeof(keyOrHash) == 'object'
        for k, v of keyOrHash
          @options[k] = v
      else
        @options[keyOrHash] = value
  }



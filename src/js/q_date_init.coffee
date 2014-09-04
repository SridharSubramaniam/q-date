app = angular.module("q-date", [])

app.provider "qDateDefaults", ->
  {
    options: {
      popupTopOffset: null,
      popupLeftOffset: 0
      translations: {
        dayAbbreviations: ["Su", "M", "Tu", "W", "Th", "F", "Sa"]
      }
    }

    $get: ->
      @options

    set: (keyOrHash, value) ->
      if typeof(keyOrHash) == 'object'
        for k, v of keyOrHash
          @options[k] = v
      else
        @options[keyOrHash] = value
  }



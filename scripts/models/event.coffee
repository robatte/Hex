class SystemEvent

  @subscriptions = {}

  @addSubscribtion: (type, callback) ->
    @subscriptions[type] = [] unless @subscriptions[type]?
    @subscriptions[type].push callback

  constructor: (@type, @data = {}) ->

  dispatch: ->
    return unless SystemEvent.subscriptions[@type]?
    for subscription_fnc in SystemEvent.subscriptions[@type]
      subscription_fnc(this)
class Mouse

  @instance = null

  constructor: ->
    unless Mouse.instance?
      jQuery('body').on 'DOMMouseScroll mousewheel', (e) =>
        @processMousWheelEvent(e)

      Mouse.instance = this


  processMousWheelEvent: (event) ->
    delta = ((if event.wheelDelta then event.wheelDelta / 120 else event.originalEvent.detail)) / 2
    new SystemEvent('mouse.mousewheel', {delta: delta}).dispatch()
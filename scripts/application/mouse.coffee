class Mouse

  @mouseButtons =
    RIGHT: 3
    MIDDLE: 2
    LEFT: 1

  @instance = null

  @scrollBase =
    x: 0
    y: 0


  constructor: ->
    unless Mouse.instance?
      jQuery('body').on 'DOMMouseScroll mousewheel', (e) =>
        @processMousWheelEvent(e)

      Mouse.instance = this


  processMousWheelEvent: (event) ->
    delta = ((if event.originalEvent.wheelDelta then event.originalEvent.wheelDelta / 120 else -event.originalEvent.detail)) / 2
    new SystemEvent('mouse.mousewheel', {delta: delta}).dispatch()


  initScrolling: (scroll_fcn) ->

    jQuery('body').on "mousedown", (e) ->
      if e.which == Mouse.mouseButtons.RIGHT
        e.preventDefault()

        jQuery("body").css {"cursor" : "move"}

        Mouse.scrollBase =
          x: e.clientX
          y: e.clientY


        jQuery('body').on "mousemove", scroll_fcn

        jQuery('body').on "mouseup", (e) ->
          if e.which == Mouse.mouseButtons.RIGHT
            jQuery('body').off "mousemove"
            jQuery("body").css {"cursor": "auto"}
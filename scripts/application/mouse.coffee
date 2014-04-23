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

    jQuery('body').on "mousedown", '.Tile', (e) ->
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

  processBackgroundClicks: (event) ->
    #bind leftclick to background for tile-unselection
    jQuery("body").on 'click', '#cr-stage', (event)->
      if event.which == 1
        event.preventDefault()
        Game.get().state.resetSelection()
        Game.get().state.changeState GameState.states.select_own_position

  # disableDragDrop: (event) ->
  #   jQuery('img').on "dragstart", (e) =>
  #     false
  #   jQuery('img').on "drop", (e) =>
  #     false
  #   # jQuery('body').on "blur", (e) =>
  #   #   alert "lost"
    

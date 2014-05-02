class Viewport
  # implements sigelton pattern by http://coffeescriptcookbook.com/chapters/design_patterns/singleton

  instance = null

  @get: () ->
    instance ?= new ViewportPrivate()

  class ViewportPrivate

    constructor: ->
      jQuery(window).resize (e) => @updateContainerSize()
      @updateContainerSize()

    getPosition: ->
      values = Game.get().scroller.scroller.getValues()
      {x: values.left, y:  values.top, zoom: values.zoom}

    setPosition: (position) ->
      Game.get().scroller.scroller.scrollTo(position.x, position.y)
      Game.get().scroller.scroller.zoomTo(position.zoom)

    updateContainerSize: ->
      View.container.parent().height jQuery(window).height()




class View

  @drawQueue = []
  @container = null


  constructor: ( containerElement ) ->
    View.container = containerElement


    # redraw on ganme state changes
    SystemEvent.addSubscribtion 'state.change', (event) =>
      @draw()

    # redraw if units are build
    SystemEvent.addSubscribtion 'state.build-units', (event) =>
      @draw()

    # redraw if units are de-/selected 
    SystemEvent.addSubscribtion 'state.toggle-unit-selection', (event)=>
      @draw()

    # redraw if army is selected
    SystemEvent.addSubscribtion 'state.army-selected', (event)=>
      @draw()

    # zoome and redraw if mousewheel is used
    # SystemEvent.addSubscribtion 'mouse.mousewheel', (event) =>
    #   if event.data.delta > 0 then zoomVal = 0.05 else zoomVal = -0.05
    #   Crafty.viewport.zoom( zoomVal, 300)
    #   @draw()

    SystemEvent.addSubscribtion 'game.game-state.moves.units', (event) => 
      UnitView.moveUnitIconsTo( event.data.activePosition, event.data.targetPosition)

  ###
  # add jQuery-object or DOM-element and redraw will wait for it to finish its animation
  ###
  @addToDrawQueue: ( jQueryObj) =>
    View.drawQueue.push jQueryObj
    # jQueryObj.promise()


  createMap: ->
    @tiles = []

    for position in Game.get().map_grid.positions
      @tiles.push new Tile(position)

    bounds = @getBound()

    View.container.css 
      width: "#{bounds.maxX - bounds.minX + 2 * Settings.contentPadding}px"
      height: "#{bounds.maxY - bounds.minY + 2 * Settings.contentPadding}px"


    # translate tiles
    tile.setPosition( tile.x- bounds.minX, tile.y - bounds.minY) for tile in @tiles



  getBound: ->
    bound =
      maxX: @tiles.map( (tile) -> tile.x + tile.width).reduce( (a,b) -> Math.max(a,b))
      minX: @tiles.map( (tile) -> tile.x).reduce( (a,b) -> Math.min(a,b))
      maxY: @tiles.map( (tile) -> tile.y + tile.height).reduce( (a,b) -> Math.max(a,b))
      minY: @tiles.map( (tile) -> tile.y).reduce( (a,b) -> Math.min(a,b))

  draw: =>
    #get first promised jQuery-Obj from drawQueue
    jQueryObj = View.drawQueue.shift()
    # if drawQueue is empty just draw...
    if not jQueryObj? and not @isWaitingForAnimation
      # draw tiles
      for tile in @tiles
        tile.update()

      MainMenuDialog.get().update()

    # else call draw again if animation is done
    else
      # drop all incoming draw-calls
      @isWaitingForAnimation = true
      jQuery.when jQuery(jQueryObj).promise().done =>
        @isWaitingForAnimation = false
        @draw()


  getCenter: ->
    center_x = 0;
    center_y = 0;

    tiles = Crafty("Tile").get()

    for tile in tiles
      center_x += tile.x
      center_y += tile.y

    {x: center_x / tiles.length, y: center_y / tiles.length}




  createTile: ->


  message: (msg) ->
    alert msg


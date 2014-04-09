class View

  constructor: (game) ->
    Tile.createCraftyTileComponent()
    @createInteractionBox(game)

    # redraw on ganme state changes
    SystemEvent.addSubscribtion 'state.change', (event) =>
      @draw()

    # redraw if units are build
    SystemEvent.addSubscribtion 'state.build-units', (event) =>
      @draw()

    # zoome and redraw if mousewheel is used
    SystemEvent.addSubscribtion 'mouse.mousewheel', (event) =>
      if event.data.delta > 0 then zoomVal = 0.05 else zoomVal = -0.05
      Crafty.viewport.zoom( zoomVal, 300)
      @draw()


  createInteractionBox: (game) ->
    @interactionBox = new InteractionBox(game)


  createMap: (game) ->
    @tiles = []

    for position in game.map_grid.positions
      @tiles.push new Tile(position)


  draw: ->
    # draw tiles
    for tile in @tiles
      tile.update()

    @interactionBox.draw()


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


class View

  constructor: (game) ->
    @createCraftyTile()
    @createCraftyMap()
    @createInteractionBox(game)

    # redraw on ganme state changes
    SystemEvent.addSubscribtion 'state.change', (event) =>
      @draw()

    # redraw if units are build
    SystemEvent.addSubscribtion 'state.build-units', (event) =>
      @draw()


  createInteractionBox: (game) ->
    @interactionBox = new InteractionBox(game)

  createCraftyMap: ->
    Crafty.c 'Map',
        map: (game) ->

            for position in game.map_grid.positions
              Crafty.e('Tile').tile(position, game)

            this

  draw: ->
    # draw tiles
    for tile in Crafty("Tile").get()
      tile.update()

    #initial zoom
    Crafty.viewport.zoom( 0, 0)

    @interactionBox.draw()


  getCenter: ->
    center_x = 0;
    center_y = 0;

    tiles = Crafty("Tile").get()

    for tile in tiles
      center_x += tile.x
      center_y += tile.y

    {x: center_x / tiles.length, y: center_y / tiles.length}




  createCraftyTile: ->
    Crafty.c 'Tile',
        soldiers: 0
        type: 0 #default-map-type
        value: 50 #Gold increase
        owner: 0 #player Nr.


        tile: (tile_position, game) ->
            @requires('2D, DOM, Image, Mouse')

            @width = 512
            @height = 450
            @size = @width / 2
            @type = tile_position.type


            @attr
                q: tile_position.q
                r: tile_position.r
                x: Math.round(@size * 3 / 2 * tile_position.q)
                y: Math.round(@size * Math.sqrt(3) * (tile_position.r + tile_position.q / 2))
                mapPosition: tile_position
                game: game
                w: @width
                h: @height

            @mapPosition.setTile( this)

            # set tile text
            @message = Crafty.e('2D, DOM, Text')
            .unselectable()
            .textColor( "#FFFFFF", 1)
            .textFont({"size":"30px"})
            .css({"text-align": "center"})

            @update()
            @bindEvents()

            this

        update: ->

          # get informations from assined MapPosition object
          @owner = @mapPosition.owner
          @units = @mapPosition.units

          # update text element
          @message.attr({x: @x + 1, y: @y + 200, w: @w}).text( @q + " / " + @r + "<br/>Einheiten: " + (if @units? then @units.length else '0'))

          # set css styles and classes to tile
          @updateCSS()

          # set tile image
          @image 'assets/tile_base_'+(if @type > 0 then @type else 'black')+'.png', "repeat"



        bindEvents: ->
          @bind 'Click', () ->
            new SystemEvent('view.tile.click', {mapPosition: @mapPosition}).dispatch()


        updateCSS: ->
          #remove all classes
          jQuery(@._element).removeClass "tile-active tile-inactive tile-move-target"
          if @owner?
            jQuery(@._element).addClass "tile-player"+@owner.id

          # set individual classes
          jQuery( @_element).addClass("tile-active") if @mapPosition.isActivePosition(@game)
          jQuery( @_element).addClass("tile-inactive") if @game.state.is(GameState.states.select_move_position) && !@mapPosition.isInteractionPosition(@game)
          jQuery( @_element).addClass("tile-move-target") if @game.state.is(GameState.states.select_move_position) && @mapPosition.isInteractionPosition(@game)


  message: (msg) ->
    alert msg
    
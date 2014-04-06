class View

  constructor: ->
    @createCraftyTile()
    @createCraftyMap()

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

            @width = 128
            @height = @width
            @size = @width / 2

            @attr
                q: tile_position.q
                r: tile_position.r
                x: @size * 3 / 2 * tile_position.q
                y: @size * Math.sqrt(3) * (tile_position.r + tile_position.q / 2)
                mapPosition: tile_position
                game: game

            @mapPosition.setTile( this)

            # set tile text
            @message = Crafty.e('2D, DOM, Text').attr({w: 128})

            @update()
            @bindEvents()

            this

        update: ->

          # get informations from assined MapPosition object
          @owner = @mapPosition.owner
          @units = @mapPosition.units

          # update text element
          @message.attr({x: @x + 40, y: @y + 40}).text( @q + " / " + @r + "<br/>Einheiten: " + (if @units? then @units.length else '0'))

          # set css styles and classes to tile
          @updateCSS()

          # set tile image
          @image 'assets/cell_player'+ (if @owner? then @owner.id  else '0')+'.png'



        bindEvents: ->
          @bind 'Click', () ->
            @game.state.selectActivePosition @mapPosition, @game.map_grid
            @game.view.draw()


        updateCSS: ->

          #remove all classes
          jQuery(@._element).removeClass "tile-active tile-active-target"

          # set individual classes
          jQuery( @_element).addClass("tile-active") if @mapPosition.isActivePosition(@game)
          jQuery( @_element).addClass("tile-active-target") if @mapPosition.isInteractionPosition(@game)


    

    
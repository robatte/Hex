Crafty.c 'Map',
    map: (game) ->
        #@requires 'Tile'

        for tile_position in game.map_grid.positions
          Crafty.e('Tile').tile( tile_position).dbg()

        @

    getCenter: ->
      center_x = 0;
      center_y = 0;

      tiles = Crafty("Tile").get()

      for tile in tiles
        center_x += tile.x
        center_y += tile.y

      {x: center_x / tiles.length, y: center_y / tiles.length}




        
Crafty.c 'Tile',
    soldiers: 0
    type: 0 #default-map-type
    value: 50 #Gold increase
    owner: 0 #player Nr.


    tile: (tile_position) ->
        @requires('2D, DOM, Image')
       
        @width = 128
        @height = @width
        @size = @width / 2

        @attr
            q: tile_position.q
            r: tile_position.r
            x: @size * 3 / 2 * tile_position.q
            y: @size * Math.sqrt(3) * (tile_position.r + tile_position.q / 2)


        @owner = tile_position.owner
        @units = tile_position.units

        @image 'assets/cell_player'+ (if @owner? then @owner.id  else '0')+'.png'

    dbg: ->
        dbgMsg = Crafty.e('2D, DOM, Text')
        .attr
            x: @x + 40
            y: @y + 40
            w: 128  
        .text( @q + " / " + @r + "<br/>Einheiten: " + (if @units? then @units.length else '0'))
        
        #@attach dbgMsg


    

    
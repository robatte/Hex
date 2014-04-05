Crafty.c 'Map',
    map: (game) ->
        @requires 'Cell'

        game.map_grid.generateMap()
        game.map_grid.setStartPositions(game.players, game.initial_units)

        for tile_position in game.map_grid.positions
          Crafty.e('Cell').cell( tile_position, game.map_grid.tile.size).dbg()


        
Crafty.c 'Cell',
    soldiers: 0
    type: 0 #default-map-type
    value: 50 #Gold increase
    owner: 0 #player Nr.

    cell: (tile, size) ->
        @requires('2D, DOM, Image')
        @attr
            q: tile.q
            r: tile.r
            x: size * 3 / 2 * tile.q
            y: size * Math.sqrt(3) * (tile.r + tile.q / 2)
        @owner = tile.owner
        @units = tile.units

        @image 'assets/cell_player'+ (if @owner? then @owner.id  else '0')+'.png'

    dbg: ->
        dbgMsg = Crafty.e('2D, DOM, Text')
        .attr
            x: @x + 40
            y: @y + 40
            w: 128  
        .text( @q + " / " + @r + "<br/>Einheiten: " + (if @units? then @units.length else '0'))
        
        #@attach dbgMsg


    

    
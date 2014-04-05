Crafty.c 'Map',
    map: (game) ->
        @requires 'Cell'

        game.map_grid.generateMap()
        game.map_grid.setStartPositions(game.players, game.initial_units)

        for tile_position in game.map_grid.positions
          Crafty.e('Cell').cell(tile_position.q, tile_position.r).pos(tile_position.q, tile_position.r, game.map_grid.tile.size)


Crafty.c 'Cell',
    soldiers: 0
    type: 0 #default-map-type
    value: 50 #Gold increase
    owner: 0 #player Nr.

    cell: (q,r) ->
        @requires('2D, DOM, Grid, Image').image 'assets/cell_player'+@owner+'.png'

        dbgMsg = Crafty.e('2D, DOM, Text')
        .attr
            x: 40
            y: 40
            w: 128  
        .text( q + " / " + r + "<br/>Einheiten: " + @soldiers)
        

        @attach dbgMsg


    

    
Crafty.c 'Map',
    map: (game) ->
        @requires 'Cell'

        game.map_grid.generateMap()
        game.map_grid.setStartPositions(game.players, game.initial_units)

        for tile_position in game.map_grid.positions
          Crafty.e('Cell').cell(tile_position.q, tile_position.r).pos(tile_position.q, tile_position.r, game.map_grid.tile.size)

                


Crafty.c 'Cell',
    cell: (q,r) ->
        @requires('2D, DOM, Grid, Image').image 'assets/cell_default.png'

        dbgMsg = Crafty.e('2D, DOM, Text')
        .attr
            x: 40
            y: 40
            w: 128  
        .text( q + " / " + r)
        

        @attach dbgMsg


    

    
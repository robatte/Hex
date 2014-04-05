Crafty.c 'Map',
    map: (game) ->
        @requires 'Cell'

        for q in [-game.map_grid.radius_q ... game.map_grid.radius_q+1]
            for r in [-game.map_grid.radius_r ... game.map_grid.radius_r+1]
                if q + r <= game.map_grid.radius_q && q + r >= -game.map_grid.radius_q
                    Crafty.e('Cell').cell(q, r).pos(q, r, game.map_grid.tile.size)

                


Crafty.c 'Cell',
    cell: (q,r) ->
        @requires '2D, DOM, Grid, Image'
        .image 'assets/cell_default.png'

        dbgMsg = Crafty.e('2D, DOM, Text')
        .attr
            x: 40
            y: 40
            w: 128  
        .text( q + " / " + r)
        

        @attach dbgMsg


    

    
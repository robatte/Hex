Crafty.c 'Map',
    map: (game) ->
        @requires 'Cell'

        tile_positions = game.map_generator.generate()

        for tile_position in tile_positions
          Crafty.e('Cell').cell(tile_position.q, tile_position.r).pos(tile_position.q, tile_position.r, game.map_grid.tile.size)

         #Center Viewport
        # Crafty.viewport.x += game.width / 2
        # Crafty.viewport.y += game.height / 2
        # Crafty.viewport.scroll 'x', game.width /2
        # Crafty.viewport.scroll 'y', game.height /2  

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


    

    
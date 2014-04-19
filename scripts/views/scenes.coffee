
# Starts a level
Crafty.scene 'Level', (game)->

    Mouse.instance.initScrolling (e) ->

      dx = Mouse.scrollBase.x - e.clientX
      dy = Mouse.scrollBase.y - e.clientY

      Mouse.scrollBase =
        x: e.clientX
        y: e.clientY

      Crafty.viewport.x -= dx
      Crafty.viewport.y -= dy



    game.view.createMap(game)
    game.view.draw()

    center_tile = window.current_game.map_grid.getPositionByCoordinates(0,0).tile.craftyTile
    Crafty.viewport.centerOn(center_tile, 0)
    # Set default-zoom
    Crafty.viewport.zoom( 0, 0)



# Menu-Scene
Crafty.scene 'Menu', (game)-> 
    Crafty.e('2D, DOM, Text')
        .attr
            x: 0
            y: game.height / 2 - 24
            w: game.width  
        .text("Loading ...")
        .textFont
            'weight': 'bold'
            'size': '50px'
        .css
            'text-align': 'center'
            'color': '#333'

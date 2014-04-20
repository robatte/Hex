
# Starts a level
Crafty.scene 'Level', ()->

    Mouse.instance.initScrolling (e) ->

      dx = Mouse.scrollBase.x - e.clientX
      dy = Mouse.scrollBase.y - e.clientY

      Mouse.scrollBase =
        x: e.clientX
        y: e.clientY

      Crafty.viewport.x -= dx / Crafty.viewport.zoomCurrent
      Crafty.viewport.y -= dy / Crafty.viewport.zoomCurrent



    Game.get().view.createMap()
    Game.get().view.draw()

    center_tile = window.current_game.map_grid.getPositionByCoordinates(0,0).tile.craftyTile
    Crafty.viewport.centerOn(center_tile, 0)
    # Set default-zoom
    Crafty.viewport.zoom( 0, 0)


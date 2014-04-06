
# Starts a level
Crafty.scene 'Level', (game)->

    Crafty.addEvent this, Crafty.stage.elem, "mousedown", (e) ->
        if e.mouseButton == Crafty.mouseButtons.RIGHT
            scroll = (e) ->
                dx = @base.x - e.clientX
                dy = @base.y - e.clientY
                @base =
                    x: e.clientX
                    y: e.clientY

                Crafty.viewport.x -= dx
                Crafty.viewport.y -= dy
                return
            @base =
                x: e.clientX
                y: e.clientY

            Crafty.addEvent this, Crafty.stage.elem, "mousemove", scroll
            Crafty.addEvent this, Crafty.stage.elem, "mouseup", ->
                if e.mouseButton == Crafty.mouseButtons.RIGHT
                    Crafty.removeEvent this, Crafty.stage.elem, "mousemove", scroll
                    return
        return



    Crafty.e('Map').map game
    game.view.draw()

    center = game.view.getCenter()
    Crafty.viewport.x = - center.x + window.innerWidth / 2
    Crafty.viewport.y = - center.y + window.innerHeight / 2


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

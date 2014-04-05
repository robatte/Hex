
# Starts a level
Crafty.scene 'Level', (game)->
    Crafty.viewport.mouselook true

    Crafty.e('Map').map game 




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

#     #Start Level on Keypress
#     @restart_level = @bind 'KeyDown', ->
#         Crafty.scene 'Level', game
# , ->
#     @unbind 'KeyDown', @restart_level

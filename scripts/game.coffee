
class Tile
    constructor: (@width)->
        @width = width
        @height = width
        # @size = Math.sqrt(4/3) * width / 2
        @size = width / 2

class MapGrid 
    constructor: ( tile_width, radius)->
        @radius_q = radius
        @radius_r = radius
        @tile = new Tile tile_width
        @width = (@radius_q * 2 + 1) * @tile.width
        @height = (@radius_r * 2 + 1) * @tile.width

class Game
    constructor: (tile_width, radius)->
        @map_grid = new MapGrid tile_width, radius
        @width = @map_grid.width
        @height = @map_grid.height

    start: ->  
        # init Canvas etc.
        Crafty.init @width, @height
        Crafty.background 'rgb(249, 223, 125)'
       

        # preload sprites
        Crafty.load [
            'assets/cell_default.png'
        ], ->
            #


        # starts the level-scene
        Crafty.scene 'Menu', @

# STAAAT
init_hex = ->
    game = new Game 128, 9
    game.start()
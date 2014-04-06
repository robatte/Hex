
class Game
    constructor: (radius, min_dense, threshold)->
        @map_grid = new MapGrid radius, min_dense, threshold

        # init player
        @players = [new Player("Player 1"), new Player("Player 2")]
        @initial_units = UnitFatory.build Unit.TYPE_SOLDIER, 10

        #map generation
        @map_grid.generateMap()
        @map_grid.setStartPositions(@players, @initial_units)


    start: ->

        # init Canvas etc.
        Crafty.init window.width, window.height
        Crafty.background 'rgb(249, 223, 125)'
       

        # preload sprites
        Crafty.load [
            'assets/cell_player0.png',
            'assets/cell_player1.png',
            'assets/cell_player2.png'
        ], =>
            Crafty.scene 'Level', @
        
class Settings
    @tileBoundary: 3
    @minTileDense: 0.2
    @mapGenRandom: 0.3


window.onload = ->
    game = new Game Settings.tileBoundary, Settings.minTileDense, Settings.mapGenRandom
    window.current_game = game
    game.start()
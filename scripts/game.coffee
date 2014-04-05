class UnitFatory
  @build: (type, count) ->
    units = []
    for i in [0..count]
      units.push new Unit type
    units

class Unit
  @TYPE_SOLDIER = "Soldat"

  constructor: (@type) ->

class Player
  @player_count = 0

  constructor: (@name) ->
    Player.player_count += 1
    @id = Player.player_count

class Tile
    constructor: (@width)->
        @width = width
        @height = width
        # @size = Math.sqrt(4/3) * width / 2
        @size = width / 2

class MapGrid
    constructor: (tile_width, radius, min_dense, threshold)->
        @radius_q = radius
        @radius_r = radius
        @tile = new Tile tile_width
        @width = (@radius_q * 2 + 1) * @tile.width
        @height = (@radius_r * 2 + 1) * @tile.width
        @map_generator = new MapGenerator @radius_q, @radius_r, min_dense, threshold

    generateMap: ->
      @map_generator.generate()
      @positions = @map_generator.positions

    setStartPositions: (players, initial_units) ->
      sums = @positions.map (pos) -> pos.r + pos.q
      max_ix = sums.indexOf Math.max.apply(null, sums)
      min_ix = sums.indexOf Math.min.apply(null, sums)
      @positions[max_ix].setOwner(players[0], initial_units)
      @positions[min_ix].setOwner(players[1], initial_units)

class Game
    constructor: (tile_width, radius, min_dense, threshold)->
        @map_grid = new MapGrid tile_width, radius, min_dense, threshold
        @width = @map_grid.width
        @height = @map_grid.height

        # init player
        @players = [new Player("Player 1"), new Player("Player 2")]
        @initial_units = UnitFatory.build Unit.TYPE_SOLDIER, 10

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
    @tileWidthPx: 128
    @tileBoundary: 3
    @minTileDense: 0.2
    @mapGenRandom: 0.3


window.onload = ->
    game = new Game Settings.tileWidthPx, Settings.tileBoundary, Settings.minTileDense, Settings.mapGenRandom
    window.current_game = game
    game.start()
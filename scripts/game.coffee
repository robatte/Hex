class Game

# implements sigelton pattern by http://coffeescriptcookbook.com/chapters/design_patterns/singleton

  instance = null

  @get: () ->
    instance ?= new GamePrivate()


  class GamePrivate

    init: (radius, min_dense, threshold)->
      @map_grid = new MapGrid radius, min_dense, threshold

      # init player
      @players = [new Player("Paul"), new Player("Susanne")]
      @initial_units = { "farmer": 3 }

      #map generation
      @map_grid.generateMap()
      @map_grid.setStartPositions(@players, @initial_units)

      #set inital game state
      @state = new GameState(@players[0])

      #main-menu
      MainMenuDialog.get()

      this


    start: ->

      # init Canvas etc.
      Crafty.init window.width, window.height
      Crafty.background 'rgb(249, 223, 125) url(assets/backgrounds/pattern_2.jpg) repeat'

      # initialize view
      @view = new View()

      # initalize mouse event handling
      new Mouse()
     
      Mouse.instance.processBackgroundClicks()
      Mouse.instance.disableDragDrop()

      # preload sprites
      Crafty.load [
          'assets/cell_player0.png',
          'assets/cell_player1.png',
          'assets/cell_player2.png',
          'assets/tile_base_1.png',
          'assets/tile_base_2.png',
          'assets/tile_base_white.png',
          'assets/tile_base_black.png',
          'assets/tile_overlay_selected.png',
          'assets/tile_overlay_blue.png',
          'assets/tile_overlay_green.png',
          'assets/tile_overlay_red.png',
          'assets/tile_overlay_yellow.png',
      ], =>
        Crafty.scene 'Level'

    nextRound: ->
      # get tax from own MapPositions
      @state.player.collectTax()

      # change player
      @state.player.storeViewPosition()
      next_player = if @state.player.id == @players[0].id then @players[1] else @players[0]
      next_player.restoreViewPosition()
      next_player

    buildUnits: (units) ->
      army = UnitFactory.get().build( units, @state.player, @state.activePosition.freeUnitSlots() )

      # remove move point for new units
      unit.currentMove = 0 for unit in army.units

      if army.building_costs() > @state.player.money_units
        @view.message "Sie haben nicht genug Geld"

      else
        @state.player.money_units -= army.building_costs()
        @state.activePosition.addArmy( army )


    canBuildUnit: ( unitType, position)->
      @state.player.money_units >= Unit.attributesByIdentifier( unitType).building_costs and position.freeUnitSlots() > 0

        
class Settings
    @tileBoundary: 3
    @minTileDense: 0.2
    @mapGenRandom: 0.3
    @minZoom: 0.3
    @maxZoom: 1
    @default_zoom: 0.5


window.onload = ->
  game = Game.get().init Settings.tileBoundary, Settings.minTileDense, Settings.mapGenRandom
  window.current_game = game
  game.start()

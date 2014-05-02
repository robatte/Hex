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
      @startPositions = @map_grid.setStartPositions(@players, @initial_units)

      #set inital game state
      @state = new GameState(@players[0])

      #main-menu
      MainMenuDialog.get()

      this


    start: ->

      # initialize view
      @view = new View( jQuery("#container > #content").first())

      # initalize mouse event handling
      new Mouse()
     
      Mouse.instance.processBackgroundClicks()

      Game.get().view.createMap()
      Game.get().view.draw()
      
      @scroller = new EasyScroller jQuery("#container > #content").get()[0], 
        scrollingX: true 
        scrollingY: true
        animating: true
        animationDuration: 10
        zooming: true
        locking: false
        paging: false
        bouncing: false
        snapping: false
        minZoom: Settings.minZoom
        maxZoom: Settings.maxZoom

      # set start positions
      @players[0].setViewPosition @startPositions[1].tile.x, @startPositions[1].tile.y, Settings.default_zoom
      @players[1].setViewPosition @startPositions[1].tile.x, @startPositions[1].tile.y, Settings.default_zoom
      @players[0].restoreViewPosition()

    nextRound: ->

      # change player
      @state.player.storeViewPosition()
      next_player = if @state.player.id == @players[0].id then @players[1] else @players[0]
      # get tax from own MapPositions
      next_player.collectTax()

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
    @contentPadding: 300
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

class GameState

  @states =
    select_own_position: 'select_own_position'
    own_position_selected: 'own_position_selected'
    select_move_position: 'select_move_position'

  constructor: (@game, @player) ->

    @currentState = GameState.states.select_own_position

    @resetSelection()

    # register events
    SystemEvent.addSubscribtion 'view.tile.click', (event) =>
      @clickMapPosition event.data.mapPosition


    SystemEvent.addSubscribtion 'view.interaction_box.round-next', (event) =>
      @nextRound()

    SystemEvent.addSubscribtion 'view.interaction_box.build-units', (event) =>
      @buildUnits()

  changeState: (state) ->
    @currentState = state
    new SystemEvent('state.change', {}).dispatch()

  is: (state) ->
    @currentState == state


  resetSelection: ->
    @activePosition = []
    @interactionPositions = []


  clickMapPosition: (position) ->

    if @isInteractionPosition(position)

      if position.owner? && position.owner.id != @player.id
        BattleViewDialog.get().open @activePosition.army.movableUnits(), position.army.units, =>
          new Fight(@activePosition.army, position.army)
          @moveUnits(position)

      else
        @moveUnits(position)


    else if position.owner == @player
      @selectActivePosition position
      @changeState GameState.states.own_position_selected

    else
      @resetSelection()
      @changeState GameState.states.select_own_position


  selectActivePosition: (position) ->
    @activePosition = position
    @selectMovePosition() if position.army.movableUnits().length > 0

  isInteractionPosition: (position) ->
    @interactionPositions.filter( (ip) -> ip.equals(position) ).length > 0

  nextRound: ->
    @player = @game.nextRound()
    @resetSelection()
    Unit.resetMove()
    @changeState GameState.states.select_own_position

  selectMovePosition: ->
    @interactionPositions = @game.map_grid.getNeighbors(@activePosition)

  buildUnits: ->
    BuildUnitsDialog.get().open @player.money_units, UnitFactory.get().units, (units) =>
      @game.buildUnits(units)
      new SystemEvent('state.build-units', {}).dispatch()

  moveUnits: (position) ->
    if @activePosition.army.movableUnits().length > 0
      MoveUnitsDialog.get().open @activePosition.army, (units) =>
        @activePosition.moveUnitsTo(position, units, @game)
        @interactionPositions = []
        @changeState GameState.states.own_position_selected
    else
      @interactionPositions = []
      @changeState GameState.states.own_position_selected

 

class Game

    @instance = null

    constructor: (radius, min_dense, threshold)->
        unless Game.instance?
          @map_grid = new MapGrid radius, min_dense, threshold

          # init player
          @players = [new Player("Player 1"), new Player("Player 2")]
          @initial_units = { "soldier": 10 }

          #map generation
          @map_grid.generateMap()
          @map_grid.setStartPositions(@players, @initial_units)

          #set inital game state
          @state = new GameState(this, @players[0])

          Game.instance = this


    start: ->

        # init Canvas etc.
        Crafty.init window.width, window.height
        Crafty.background 'rgb(249, 223, 125) url(assets/backgrounds/pattern_2.jpg) repeat'

        # initialize view
        @view = new View(this)

        # initalize mouse event handling
        new Mouse()
       

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
            Crafty.scene 'Level', @

    nextRound: ->
      # get tax from own MapPositions
      @state.player.money_units += @map_grid.getPositionsByOwner(@state.player).map((p) -> p.taxRate()).reduce( (x, y) -> x + y)

      # change player
      next_player = if @state.player.id == @players[0].id then @players[1] else @players[0]
      next_player

    buildUnits: (units) ->
      army = UnitFactory.get().build( units, @state.player )

      if army.building_costs() > @state.player.money_units
        @view.message "Sie haben nicht genug Geld"

      else
        @state.player.money_units -= army.building_costs()
        @state.activePosition.addArmy( army )


        
class Settings
    @tileBoundary: 3
    @minTileDense: 0.2
    @mapGenRandom: 0.3
    @minZoom: 0.3
    @maxZoom: 1
    @default_zoom: 0.5


window.onload = ->
    game = new Game Settings.tileBoundary, Settings.minTileDense, Settings.mapGenRandom
    window.current_game = game
    game.start()
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

    SystemEvent.addSubscribtion 'view.interaction_box.move-units', (event) =>
      @selectMovePosition()

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
      count = parseInt(prompt("Move how many units?","0"))
      @activePosition.moveUnitsTo(position, count) unless isNaN(count)
      @interactionPositions = []
      @changeState GameState.states.own_position_selected

    else if position.owner == @player
      @selectActivePosition position
      @changeState GameState.states.own_position_selected

    else
      @resetSelection()
      @changeState GameState.states.select_own_position


  selectActivePosition: (position) ->
    @activePosition = position

  isInteractionPosition: (position) ->
    @interactionPositions.filter( (ip) -> ip.equals(position) ).length > 0

  nextRound: ->
    @player = @game.nextRound()
    @resetSelection()
    @changeState GameState.states.select_own_position

  selectMovePosition: ->
    @interactionPositions = @game.map_grid.getNeighbors(@activePosition)
    @changeState GameState.states.select_move_position

  buildUnits: ->
    count = parseInt(prompt("Move how many units?","0"))
    if !isNaN(count) && count > 1
      @game.buildUnits(count)
      new SystemEvent('state.build-units', {}).dispatch()

 

class Game

    @instance = null

    constructor: (radius, min_dense, threshold)->
        unless Game.instance?
          @map_grid = new MapGrid radius, min_dense, threshold

          # init player
          @players = [new Player("Player 1"), new Player("Player 2")]
          @initial_units = UnitFatory.build Unit.TYPE_SOLDIER, 10

          #map generation
          @map_grid.generateMap()
          @map_grid.setStartPositions(@players, @initial_units)

          #set inital game state
          @state = new GameState(this, @players[0])

          Game.instance = this


    start: ->

        # init Canvas etc.
        Crafty.init window.width, window.height
        Crafty.background 'rgb(249, 223, 125) url(assets/backgrounds/clouds_1.jpg) repeat'

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
        ], =>
            Crafty.scene 'Level', @

    nextRound: ->
      # get tax from own MapPositions
      @state.player.money_units += @map_grid.getPositionsByOwner(@state.player).map((p) -> p.taxRate()).reduce( (x, y) -> x + y)

      # change player
      next_player = if @state.player.id == @players[0].id then @players[1] else @players[0]
      next_player

    buildUnits: (count) ->
      price = count * 25

      if price > @state.player.money_units
        @view.message "Sie ahben nicht genug Geld"

      else
        @state.player.money_units -= price
        @state.activePosition.addUnits( UnitFatory.build( Unit.TYPE_SOLDIER, count ) )


        
class Settings
    @tileBoundary: 3
    @minTileDense: 0.2
    @mapGenRandom: 0.3
    @minZoom: 0.3
    @maxZoom: 1
    @default_zoom: .4


window.onload = ->
    game = new Game Settings.tileBoundary, Settings.minTileDense, Settings.mapGenRandom
    window.current_game = game
    game.start()
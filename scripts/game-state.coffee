class GameState

  @states =
    select_own_position: 'select_own_position'
    own_position_selected: 'own_position_selected'
    start_unit_moving: 'start_unit_moving'

  constructor: (@player) ->

    @currentState = GameState.states.select_own_position

    @resetSelection()

    # register events
    SystemEvent.addSubscribtion 'view.tile.click', (event) =>
      @clickMapPosition event.data.mapPosition


    SystemEvent.addSubscribtion 'view.main-menu.round-next', (event) =>
      @nextRound()

    SystemEvent.addSubscribtion 'view.main-menu.build-units', (event) =>
      @buildUnits( event.data )

    SystemEvent.addSubscribtion 'view.main-menu.unit-clicked', (event) =>
      @toggleUnitSelection( event.data )

    SystemEvent.addSubscribtion 'view.main-menu.all-units-clicked', (event) =>
      @selectArmy()

  changeState: (state) ->
    @currentState = state
    new SystemEvent('state.change', {}).dispatch()

  is: (state) ->
    @currentState == state


  resetSelection: ->
    @activePosition = null
    @deselectMovePosition()


  clickMapPosition: (position) ->

    if @isInteractionPosition(position)

      if position.owner? && position.owner.id != @player.id
        BattleViewDialog.get().open @activePosition.army.getActiveUnits(), position.army.units, =>
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
    # deselect move positions
    @deselectMovePosition()

    # select new active position and clear unit selection
    @activePosition = position
    @activePosition.army.deselectActiveUnits()

  isInteractionPosition: (position) ->
    @interactionPositions.filter( (ip) -> ip.equals(position) ).length > 0

  nextRound: ->
    @player = Game.get().nextRound()
    @resetSelection()
    Unit.resetMove()
    @changeState GameState.states.select_own_position

  selectMovePosition: ->
    @interactionPositions = Game.get().map_grid.getNeighbors(@activePosition)

  deselectMovePosition: ->
    @interactionPositions = []


  toggleUnitSelection: (units) ->
    for unit in units
      unit.isActive = (not unit.isActive or units.length > 1) and unit.currentMove > 0

    if @activePosition.army.hasActiveUnits()
      @selectMovePosition()
    else
      @deselectMovePosition()
    new SystemEvent('state.toggle-unit-selection', {}).dispatch()


  buildUnits: (units)->
    # BuildUnitsDialog.get().open @player.money_units, @activePosition.terrain.unitsToBuild(), (units) =>
    Game.get().buildUnits(units)
    new SystemEvent('state.build-units', {}).dispatch()

  moveUnits: (position) ->

    if @activePosition.army.getActiveUnits().length > 0 and (@activePosition.army.getActiveUnits().length < @activePosition.army.units.length or confirm("Willst Du alle Einheiten bewegen und die Position aufgeben?"))
      @activePosition.moveUnitsTo(position, @activePosition.army.getActiveUnits())

    if @activePosition.army.units.length <= 0
      @activePosition.owner = null
      if position.owner.id == @player.id
        @selectActivePosition(position)
      else
        @resetSelection()


    @deselectMovePosition()
    @changeState GameState.states.own_position_selected

  selectArmy: ->
    if @activePosition?
      @activePosition.army.selectAllUnits()
      if @activePosition.army.hasActiveUnits()
        @selectMovePosition()
      else
        @deselectMovePosition()
      new SystemEvent('state.army-selected', {}).dispatch()
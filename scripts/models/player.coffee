class Player
  @player_count = 0
  viewportPosition: null

  constructor: (@name) ->
    @id = Player.player_count
    Player.player_count += 1
    @id = Player.player_count
    @money_units = 0
    @money_per_round = 0

  storeViewPosition: ->
    @viewportPosition = Viewport.get().getPosition()

  restoreViewPosition: ->
    Viewport.get().setPosition @viewportPosition if @viewportPosition?

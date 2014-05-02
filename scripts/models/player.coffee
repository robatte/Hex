class Player
  @player_count = 0
  viewportPosition: null

  constructor: (@name) ->
    @id = Player.player_count
    Player.player_count += 1
    @id = Player.player_count
    @money_units = 0

  collectTax: ->
    @money_units += @moneyPerRound()

  moneyPerRound: ->
    Game.get().map_grid.getPositionsByOwner( this).map((p) -> p.taxRate()).reduce( (x, y) -> x + y)

  storeViewPosition: ->
    @viewportPosition = Viewport.get().getPosition()

  restoreViewPosition: ->
    Viewport.get().setPosition @viewportPosition if @viewportPosition?

  setViewPosition: (x, y, zoom) ->
    @viewportPosition = {x: x, y:  y, zoom: zoom}

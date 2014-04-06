class Player
  @player_count = 0

  constructor: (@name) ->
    @id = Player.player_count
    Player.player_count += 1
    @id = Player.player_count
    @money_units = 100
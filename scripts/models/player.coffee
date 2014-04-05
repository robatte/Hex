class Player
  @player_count = 0

  constructor: (@name) ->
    Player.player_count += 1
    @id = Player.player_count
class MapPosition

  constructor: (@q, @r) ->
    @owner = null
    @units = []

  isActivePosition: (game) ->
    this == game.state.activePosition

  isInteractionPosition: (game) ->
    game.state.isInteractionPosition(this)

  setOwner: (player, units) ->
    @owner = player
    @units = units

  getNeighbors: ->
    neighbors = []
    neighbors_offsets = [
      [+1,  0], [+1, -1], [ 0, -1],
      [-1,  0], [-1, +1], [ 0, +1]
    ]

    for neighbor_offset in neighbors_offsets
      neighbor = new MapPosition @q + neighbor_offset[0], @r + neighbor_offset[1]
      neighbors.push neighbor

    neighbors

  equals: (other) ->
    other.q == @q && other.r == @r

  setTile: (@tile) ->

  moveUnitsTo: (other, count) ->
    return if count < 1 || @units.length <= 1
    count = @units.length - 1 if count > @units.length - 1
    for i in [0..count - 1]
      other.units.push( @units.pop() )
    other.owner = @owner

  taxRate: ->
    25

class MapGrid
  constructor: (radius, min_dense, threshold)->
    @radius_q = radius
    @radius_r = radius
    @map_generator = new MapGenerator @radius_q, @radius_r, min_dense, threshold

  generateMap: ->
    @map_generator.generate()
    @positions = @map_generator.positions

    @positionsByIndex = {}

    for position in @positions
      @positionsByIndex[position.q] = {} unless @positionsByIndex[position.q]?
      @positionsByIndex[position.q][position.r] = position

  getPositionByCoordinates: (q, r) ->
    return null unless @positionsByIndex[q]?
    @positionsByIndex[q][r]

  setStartPositions: (players, initial_units) ->
    sums = @positions.map (pos) -> pos.r + pos.q
    max_ix = sums.indexOf Math.max.apply(null, sums)
    min_ix = sums.indexOf Math.min.apply(null, sums)
    @positions[min_ix].setOwner(players[0], Helper.clone(initial_units))
    @positions[max_ix].setOwner(players[1], Helper.clone(initial_units))

  getNeighbors: (position) ->
    neighbors = []
    for candidate in position.getNeighbors()
      neighbors.push(@getPositionByCoordinates(candidate.q, candidate.r)) if @getPositionByCoordinates(candidate.q, candidate.r)?
    neighbors

  getPositionsByOwner: (owner) ->
    @positions.filter (position) -> if position.owner? then position.owner.id == owner.id else false

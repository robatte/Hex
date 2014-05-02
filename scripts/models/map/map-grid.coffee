class MapGrid

  typeDistribution:
    1: 0.6
    2: 0.3
    3: 0.1

  startPositionTypeId: 3

  constructor: (radius, min_dense, threshold)->
    @radius_q = radius
    @radius_r = radius
    @map_generator = new MapGenerator @radius_q, @radius_r, min_dense, threshold

  generateMap: ->
    @map_generator.generate @typeDistribution
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
    @positions[min_ix].setOwner(players[0], UnitFactory.get().build( initial_units, players[0] )).setTerrain(@startPositionTypeId)
    @positions[max_ix].setOwner(players[1], UnitFactory.get().build( initial_units, players[1] )).setTerrain(@startPositionTypeId)
    [@positions[min_ix], @positions[max_ix]]

  getNeighbors: (position) ->
    neighbors = []
    for candidate in position.getNeighbors()
      neighbors.push(@getPositionByCoordinates(candidate.q, candidate.r)) if @getPositionByCoordinates(candidate.q, candidate.r)?
    neighbors

  getPositionsByOwner: (owner) ->
    @positions.filter (position) -> if position.owner? then position.owner.id == owner.id else false

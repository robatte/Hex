class MapPosition

  constructor: (@q, @r, @terrain = null) ->
    @owner = null
    @army = new Army(null)

  isActivePosition: ->
    this == Game.get().state.activePosition

  isInteractionPosition: ->
    Game.get().state.isInteractionPosition(this)

  setOwner: (player, army) ->
    @owner = player
    @army = army
    this

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
    this

  moveUnitsTo: (other, units) ->
    @army.moveTo other, units
    other.owner = @owner if other.army.units.length > 0 and other.army.units[0].owner.id == @army.owner.id

    if @army.units.length <= 0
      @owner = null
      Game.get().state.selectActivePosition(other)

    this

  taxRate: ->
    @terrain.taxRate()

  addArmy: (new_army) ->
    @army.addArmy new_army
    this

  setTerrain: (type_id) ->
    @terrain = TerrainFactory.get().build(type_id)
    this


class MapGrid

  typeDistribution:
    1: 0.6
    2: 0.3
    3: 0.1

  startPositionTypeId: 2

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

  getNeighbors: (position) ->
    neighbors = []
    for candidate in position.getNeighbors()
      neighbors.push(@getPositionByCoordinates(candidate.q, candidate.r)) if @getPositionByCoordinates(candidate.q, candidate.r)?
    neighbors

  getPositionsByOwner: (owner) ->
    @positions.filter (position) -> if position.owner? then position.owner.id == owner.id else false

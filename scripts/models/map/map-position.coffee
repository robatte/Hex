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
    @army.moveTo other.army, units, other.freeUnitSlots()
    other.owner = @owner if other.army.units.length > 0 and other.army.units[0].owner.id == @army.owner.id
    this

  taxRate: ->
    @terrain.taxRate()

  addArmy: (new_army) ->
    @army.addArmy new_army
    this

  setTerrain: (type_id) ->
    @terrain = TerrainFactory.get().build(type_id)
    this

  freeUnitSlots: ->
    @terrain.maxUnits() - @army.units.length
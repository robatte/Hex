class MapPosition

  constructor: (@q, @r) ->
    @owner = null
    @units = null

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

class MapGrid
  constructor: (tile_width, radius, min_dense, threshold)->
    @radius_q = radius
    @radius_r = radius
    @tile = new Tile tile_width
    @width = (@radius_q * 2 + 1) * @tile.width
    @height = (@radius_r * 2 + 1) * @tile.width
    @map_generator = new MapGenerator @radius_q, @radius_r, min_dense, threshold

  generateMap: ->
    @map_generator.generate()
    @positions = @map_generator.positions

  setStartPositions: (players, initial_units) ->
    sums = @positions.map (pos) -> pos.r + pos.q
    max_ix = sums.indexOf Math.max.apply(null, sums)
    min_ix = sums.indexOf Math.min.apply(null, sums)
    @positions[max_ix].setOwner(players[0], initial_units)
    @positions[min_ix].setOwner(players[1], initial_units)
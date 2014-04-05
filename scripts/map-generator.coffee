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






class MapGenerator

  constructor: (@radius_q, @radius_r, @min_dense, @threshold) ->
    @min_amount = Math.floor((2 * @radius_q + 1) * (2 * @radius_r + 1) * @min_dense)

  generate: ->
    @positions = []
    process = []
    process.push @getInitalPosition()

    while process.length > 0
      position = process.pop()

      for neighbor in Helper.shuffle_array position.getNeighbors()
        if @isValidPosition(neighbor)
          if Math.random() < @threshold || (process.length == 0 && @positions.length < @min_amount)
            process.push(neighbor) unless @positionInArray(neighbor, process.concat(@positions))

      @positions.push(position)

  positionInArray: (position, positions) ->
    matches = positions.filter (pos) -> pos.equals(position)
    matches.length > 0


  getInitalPosition: ->
    loop
      q = @randomIntInRange -@radius_q, @radius_q
      r = @randomIntInRange -@radius_r, @radius_r
      p = new MapPosition q, r
      break if @isValidPosition(p)
    p

  randomIntInRange: (min, max) ->
    Math.floor(Math.random() * (max - min + 1)) + min

  isValidPosition: (position) ->
    Math.abs(position.q) <= @radius_q && Math.abs(position.r) <= @radius_r

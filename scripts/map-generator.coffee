class MapPosition

  constructor: (@q, @r) ->

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

  constructor: (@radius_q, @radius_r, @dense, @threshold) ->
    @point_amount = Math.floor((2 * @radius_q + 1) * (2 * @radius_r + 1) * @dense)

  generate: ->
    positions = []
    process = []
    process.push @getInitalPosition()

    while process.length > 0 && positions.length < @point_amount
      position = process.shift()

      for neighbor in Helper.shuffle_array position.getNeighbors()
        if @isValidPosition(neighbor)
          if Math.random() < @threshold || process.length == 0
            process.push(neighbor) unless @positionInArray(neighbor, process.concat(positions))

      positions.push(position)

    positions

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
    Math.abs(position.q) <= @radius_q && Math.abs(position.r) <= @radius_r #&&
    #position.q + position.r <= @radius_q && position.q + position.r >= -@radius_q

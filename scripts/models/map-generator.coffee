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
      q = 0#@randomIntInRange -@radius_q, @radius_q
      r = 0#@randomIntInRange -@radius_r, @radius_r
      type = Math.floor( Math.random() * 2) + 1
      p = new MapPosition q, r, type
      break if @isValidPosition(p)
    p

  randomIntInRange: (min, max) ->
    Math.floor(Math.random() * (max - min + 1)) + min

  isValidPosition: (position) ->
    Math.abs(position.q) <= @radius_q && Math.abs(position.r) <= @radius_r

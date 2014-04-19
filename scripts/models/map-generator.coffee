class MapGenerator

  constructor: (@radius_q, @radius_r, @min_dense, @threshold) ->
    @min_amount = Math.floor((2 * @radius_q + 1) * (2 * @radius_r + 1) * @min_dense)

  generate: (typeDistribution) ->
    @typeDistribution = typeDistribution
    @positions = []
    process = [ new MapPosition(0, 0) ]

    while process.length > 0
      position = process.pop()

      for neighbor in Helper.shuffle_array position.getNeighbors()
        if @isValidPosition(neighbor)
          if Math.random() < @threshold || (process.length == 0 && @positions.length < @min_amount)
            process.push(neighbor) unless @positionInArray(neighbor, process.concat(@positions))

      @positions.push(position)

    @setTypes()

  positionInArray: (position, positions) ->
    matches = positions.filter (pos) -> pos.equals(position)
    matches.length > 0


  randomIntInRange: (min, max) ->
    Math.floor(Math.random() * (max - min + 1)) + min

  isValidPosition: (position) ->
    Math.abs(position.q) <= @radius_q && Math.abs(position.r) <= @radius_r


  setTypes: () ->
    pos_amount = @positions.length
    partition = []

    # generate types array
    for type, propability of @typeDistribution
      amount = Math.floor propability * pos_amount
      for i in [0...amount]
        partition.push type

    # fill to target size
    for i in [0...(pos_amount - partition.length)]
      partition.push "1"

    # shuffle array
    partition = Helper.shuffle_array partition

    #set types
    for i in [0...pos_amount]
      @positions[i].setTerrain parseInt( partition[i] )
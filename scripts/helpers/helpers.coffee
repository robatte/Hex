class Helper

  @shuffle_array: (a) ->
    for i in [a.length-1..1]
        j = Math.floor Math.random() * (i + 1)
        [a[i], a[j]] = [a[j], a[i]]
    a

  # thanks to https://stackoverflow.com/questions/728360/most-elegant-way-to-clone-a-javascript-object
  @clone = (obj) ->

    # Handle the 3 simple types, and null or undefined
    return obj  if null is obj or "object" isnt typeof obj

    # Handle Date
    if obj instanceof Date
      copy = new Date()
      copy.setTime obj.getTime()
      return copy

    # Handle Array
    if obj instanceof Array
      copy = []
      i = 0
      len = obj.length

      while i < len
        copy[i] = @clone(obj[i])
        i++
      return copy

    # Handle Object
    if obj instanceof Object
      copy = {}
      for attr of obj
        copy[attr] = @clone(obj[attr])  if obj.hasOwnProperty(attr)
      return copy

    throw new Error("Unable to copy obj! Its type isn't supported.")

  Array::where = (query) ->
    return [] if typeof query isnt "object"
    hit = Object.keys(query).length
    @filter (item) ->
        match = 0
        for key, val of query
            match += 1 if item[key] is val
        if match is hit then true else false



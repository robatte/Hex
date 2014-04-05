class Helper

  @shuffle_array: (a) ->
    for i in [a.length-1..1]
      j = Math.floor Math.random() * (i + 1)
      [a[i], a[j]] = [a[j], a[i]]
    a
class UnitFatory
  @build: (type, count) ->
    units = []
    for i in [1..count]
      units.push new Unit type
    units

class Unit
  @TYPE_SOLDIER = "Soldat"

  constructor: (@type) ->
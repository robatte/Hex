class Army

  constructor: (@owner)->
    @units = []

  add: (unit) ->
    @units.push unit

  addArmy: (other) ->
    @units = @units.concat other.units

  building_costs: ->
    @units.reduce ( (total, unit) -> total + unit.building_costs ), 0

  amountOfUnits: ->
    @units.length

  getUnitsByType: (units = @units) ->
    result = {}
    for unit in units
      result[unit.type_identifier] = [] unless result[unit.type_identifier]?
      result[unit.type_identifier].push unit

    result

  movableUnits: ->
    @units.filter (u) -> u.currentMove > 0

  notMovableUnits: ->
    @units.filter (u) -> u.currentMove == 0


  moveTo: (other, units, max_moves) ->
    keep = []
    for i in [1..@units.length]
      unit = @units.pop()

      # check if current unit is in array with units to move
      is_in_array = units.filter( (u) -> u.id == unit.id).length > 0

      if is_in_array and unit.currentMove > 0 and i <= max_moves
        unit.currentMove -= 1
        unit.isActive = false
        other.units.push unit
      else
        keep.push unit

    other.owner = @owner if other.units.length > 0
    @units = keep

  hasActiveUnits: ->
    @getActiveUnits().length > 0

  getActiveUnits: ->
    @units.filter( (unit) -> unit.isActive )

  getNotActiveUnits: ->
    @units.filter( (unit) -> not unit.isActive )

  selectAllUnits: ->
    unit.isActive = true for unit in @movableUnits()

  deselectActiveUnits: ->
    unit.isActive = false for unit in @units
class Unit

  constructor: (attributes) ->
    @name = attributes.name
    @type_identifier = attributes.type_identifier
    @building_costs = attributes.building_costs



class FarmerUnit extends Unit

  @attributes =
    name: "Bauer"
    type_identifier: "farmer"
    building_costs: 10

  constructor: ->
    super(FarmerUnit.attributes)


class SoldierUnit extends Unit

  @attributes =
    name: "Soldat"
    type_identifier: "soldier"
    building_costs: 25

  constructor: ->
    super(SoldierUnit.attributes)


class Army

  constructor: ->
    @units = []

  add: (unit) ->
    @units.push unit

  addArmy: (other) ->
    @units = @units.concat other.units

  building_costs: ->
    @units.reduce ( (total, unit) -> total + unit.building_costs ), 0

  amountOfUnits: ->
    @units.length

  getUnitsByType: ->
    result = {}
    for unit in @units
      result[unit.type_identifier] = [] unless result[unit.type_identifier]?
      result[unit.type_identifier].push unit

    result

  moveTo: (other, units) ->
    keep = []
    for i in [1..@units.length]
      unit = @units.pop()

      if units[unit.type_identifier]? and units[unit.type_identifier] > 0
        other.army.units.push unit
        units[unit.type_identifier] -= 1
      else
        keep.push unit

    @units = keep





class UnitFactory

  # implements sigelton pattern by http://coffeescriptcookbook.com/chapters/design_patterns/singleton

  instance = null

  @get: () ->
    instance ?= new UnitFactoryPrivate()

  class UnitFactoryPrivate

    units:
      farmer:
        FarmerUnit.attributes
      soldier:
        SoldierUnit.attributes

    build: (unitSet) ->
      army = new Army()

      for type_identifier, amount of unitSet
        for i in [1..amount]
          switch type_identifier
            when SoldierUnit.attributes.type_identifier then army.add new SoldierUnit()
            when FarmerUnit.attributes.type_identifier then army.add new FarmerUnit()

      army
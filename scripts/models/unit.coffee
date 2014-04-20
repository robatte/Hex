class Unit

  constructor: (attributes) ->
    @setAbilities()
    @setAttributes(attributes)

  setAttributes: (attributes) ->
    @name = attributes.name
    @type_identifier = attributes.type_identifier
    @building_costs = attributes.building_costs
    @currentHealth =  Math.floor( @health * Math.random() )


  setAbilities: ->
    @attack  = 100
    @damage  = 10
    @defense = 100
    @health = 100



class FarmerUnit extends Unit


  @attributes =
    name: "Bauer"
    type_identifier: "farmer"
    building_costs: 10

  constructor: (@owner)->
    super(FarmerUnit.attributes)


class SoldierUnit extends Unit

  @attributes =
    name: "Soldat"
    type_identifier: "soldier"
    building_costs: 25

  constructor: (@owner)->
    super(SoldierUnit.attributes)


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

    build: (unitSet, owner) ->
      army = new Army( owner )

      for type_identifier, amount of unitSet
        if amount > 0
          for i in [0...amount]
            switch type_identifier
              when SoldierUnit.attributes.type_identifier then army.add new SoldierUnit( owner )
              when FarmerUnit.attributes.type_identifier then army.add new FarmerUnit( owner )

      army
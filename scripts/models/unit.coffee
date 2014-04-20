class Unit

  @all = []

  constructor: (attributes) ->
    @setAbilities()
    @setAttributes(attributes)
    Unit.all.push this

  setAttributes: (attributes) ->
    @name = attributes.name
    @type_identifier = attributes.type_identifier
    @building_costs = attributes.building_costs
    @health = 100
    @currentMove = @moves
    @currentHealth =  Math.floor( @health * Math.random() )


  setAbilities: ->
    @attack  = 100
    @damage  = 10
    @defense = 100
    @moves = 1
    @health = 100

  @resetMove: ->
    for unit in Unit.all
      unit.currentMove = unit.moves



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

  getUnitsByType: (units = @units) ->
    result = {}
    for unit in units
      result[unit.type_identifier] = [] unless result[unit.type_identifier]?
      result[unit.type_identifier].push unit

    result

  movableUnits: ->
    @units.filter (u) -> u.currentMove > 0

  moveTo: (other, units) ->
    keep = []
    for i in [1..@units.length]
      unit = @units.pop()

      if units[unit.type_identifier]? and units[unit.type_identifier] > 0 and unit.currentMove > 0
        unit.currentMove -= 1
        other.army.units.push unit
        units[unit.type_identifier] -= 1
      else
        keep.push unit
    other.army.owner = @owner if other.army.units.length > 0

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
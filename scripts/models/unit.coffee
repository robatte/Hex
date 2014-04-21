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
    @currentHealth =  @health   

  @resetMove: ->
    for unit in Unit.all
      unit.currentMove = unit.moves

  @attributesByIdentifier: (type_identifier) ->
    switch type_identifier
      when "farmer" then FarmerUnit.attributes
      when "soldier" then SoldierUnit.attributes



class FarmerUnit extends Unit


  @attributes =
    name: "Bauer"
    type_identifier: "farmer"
    building_costs: 10

  constructor: (@owner)->
    super(FarmerUnit.attributes)

  setAbilities: ->
    # attack abilities by http://www.redblobgames.com/articles/probability/damage-rolls.html
    @attack_roles  = 6
    @attack_dice  = 2
    @attack_offset  = -4
    @armor = 0
    @moves = 1
    @health = 70


class SoldierUnit extends Unit

  @attributes =
    name: "Soldat"
    type_identifier: "soldier"
    building_costs: 25

  constructor: (@owner)->
    super(SoldierUnit.attributes)

  setAbilities: ->
    # attack abilities by http://www.redblobgames.com/articles/probability/damage-rolls.html
    @attack_roles  = 4
    @attack_dice  = 3
    @attack_offset  = 15
    @armor = 0.3
    @moves = 1
    @health = 100


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

      if units[unit.type_identifier]? and units[unit.type_identifier] > 0 and unit.currentMove > 0 and i <= max_moves
        unit.currentMove -= 1
        other.units.push unit
        units[unit.type_identifier] -= 1
      else
        keep.push unit
    other.owner = @owner if other.units.length > 0

    @units = keep





class UnitFactory

  # implements sigelton pattern by http://coffeescriptcookbook.com/chapters/design_patterns/singleton

  instance = null

  @get: () ->
    instance ?= new UnitFactoryPrivate()

  class UnitFactoryPrivate

    build: (unitSet, owner, max_amount = null) ->
      debugger
      army = new Army( owner )

      count = 0
      for type_identifier, amount of unitSet
        if amount > 0
          for i in [0...amount]
            break if max_amount? and count >= max_amount
            switch type_identifier
              when SoldierUnit.attributes.type_identifier then army.add new SoldierUnit( owner )
              when FarmerUnit.attributes.type_identifier then army.add new FarmerUnit( owner )
            count +=1

      army
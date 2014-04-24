class Unit

  @all = []
  @nextFreeID = 0

  constructor: (attributes) ->
    # set unit id
    @id = Unit.nextFreeID
    Unit.nextFreeID += 1

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
    @isActive = false

  @resetMove: ->
    for unit in Unit.all
      unit.currentMove = unit.moves

  @attributesByIdentifier: (type_identifier) ->
    switch type_identifier
      when "farmer" then FarmerUnit.attributes
      when "soldier" then SoldierUnit.attributes

  @getUnitByIdentifier: (uniqueId) =>
    (@all.filter (unit)-> unit.id == uniqueId)[0] || null

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
    building_costs: 40

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
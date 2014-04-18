
class FarmerUnit

  @attributes =
    name: "Bauer"
    type_identifier: "farmer"
    building_costs: 10

  building_costs: ->
    FarmerUnit.attributes.building_costs

class SoldierUnit

  @attributes =
    name: "Soldat"
    type_identifier: "soldier"
    building_costs: 25

  building_costs: ->
    SoldierUnit.attributes.building_costs


class Army

  constructor: ->
    @units = []

  add: (unit) ->
    @units.push unit

  addArmy: (other) ->
    @units = @units.concat other.units

  building_costs: ->
    @units.reduce ( (total, unit) -> total + unit.building_costs() ), 0

  amountOfUnits: ->
    @units.length




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
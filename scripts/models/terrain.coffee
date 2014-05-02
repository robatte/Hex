class TerrainFactory

# implements sigelton pattern by http://coffeescriptcookbook.com/chapters/design_patterns/singleton

  instance = null

  @get: () ->
    instance ?= new TerrainFactoryPrivate()

  class TerrainFactoryPrivate

    build: (type_id) ->

      switch type_id
        when 1 then new TerrainGrassland()
        when 2 then new TerrainVillage()
        when 3 then new TerrainFortress()


class Terrain

  taxRate: ->
    @tax_rate[@level]

  unitsToBuild: ->
    @units_to_build[@level]

  defense: ->
    @defense[@level]

  maxUnits: ->
    12

  hasUpgrade: ->
    @level < @maxLevel

  upgradeCosts: ->
    @upgrade_costs[@level + 1]

  upgrade: ->
    @level += 1 if @level < @maxLevel



class TerrainGrassland extends Terrain
  @type_identifier: 'Wiese'

  maxLevel: 0
  tax_rate: [ 5 ]
  defense: [ 0.0 ]
  units_to_build: [ [] ]
  upgrade_costs: [ 0 ]

  constructor: ->
    @type = TerrainGrassland.type_identifier
    @level = 0

class TerrainVillage extends Terrain
  @type_identifier: 'Dorf'

  maxLevel: 0
  tax_rate: [ 20 ]
  defense: [ 0.05 ]
  units_to_build: [ ['farmer'] ]
  upgrade_costs: [ 0 ]

  constructor: ->
    @type = TerrainVillage.type_identifier
    @level = 0

class TerrainFortress extends Terrain
  @type_identifier: 'Burg'

  maxLevel: 1
  tax_rate: [ 10, 20 ]
  defense: [ 0.20, 0.30 ]
  units_to_build: [ ['farmer'], ['farmer', 'soldier'] ]
  upgrade_costs: [ 0, 100 ]

  constructor: ->
    @type = TerrainFortress.type_identifier
    @level = 0
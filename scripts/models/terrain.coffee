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
    @tax_rate

  unitsToBuild: ->
    @units_to_build

  maxUnits: ->
    12


class TerrainGrassland extends Terrain
  @type_identifier: 'Wiese'
  tax_rate: 5
  units_to_build: []

  constructor: ->
    @type = TerrainGrassland.type_identifier

class TerrainVillage extends Terrain
  @type_identifier: 'Dorf'
  tax_rate: 30
  units_to_build: ['farmer']

  constructor: ->
    @type = TerrainVillage.type_identifier

class TerrainFortress extends Terrain
  @type_identifier: 'Burg'
  tax_rate: 15
  units_to_build: ['farmer', 'soldier']

  constructor: ->
    @type = TerrainFortress.type_identifier
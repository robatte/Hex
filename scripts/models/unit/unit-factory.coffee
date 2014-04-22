class UnitFactory

# implements sigelton pattern by http://coffeescriptcookbook.com/chapters/design_patterns/singleton

  instance = null

  @get: () ->
    instance ?= new UnitFactoryPrivate()

  class UnitFactoryPrivate

    build: (unitSet, owner, max_amount = null) ->
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
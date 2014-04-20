class UnitView
  constructor: (@unit) ->

  image: ->
    switch @unit.type_identifier
      when "farmer" then "unit_peasant_#{ @unit.owner.id }.png"
      when "soldier" then "unit_knight_#{ @unit.owner.id }.png"
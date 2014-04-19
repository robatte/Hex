class UnitView
  constructor: (@unit) ->

  image: ->
    switch @unit.type_identifier
      when "farmer" then "unit_peasant_1.png"
      when "soldier" then "unit_knight_1.png"
class UnitView
  constructor: (@unit) ->

  image: ->
    switch @unit.type_identifier
      when "farmer" then "unit_peasant_#{ @unit.owner.id }.png"
      when "soldier" then "unit_knight_#{ @unit.owner.id }.png"

  draw: ->
    health = @unit.currentHealth / @unit.health * 100
    return """
           <div class="unit">
            <img src='assets/#{ @image() }'/>
            <div class="health"><div class="bar" style="height: #{health}%; width: #{health}%"></div></div>
           </div>
           """
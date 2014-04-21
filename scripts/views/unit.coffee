class UnitView
  constructor: (@unit) ->

  @image: (unitTypeIdentifier, owner)->
    switch unitTypeIdentifier
      when "farmer" then "assets/unit_peasant_#{ owner.id }.png"
      when "soldier" then "assets/unit_knight_#{ owner.id }.png"

  draw: ->
    health = @unit.currentHealth / @unit.health * 100
    return """
           <div class="unit">
            <img src='#{ UnitView.image( @unit.type_identifier, @unit.owner) }'/>
            <div class="health"><div class="bar" style="height: #{health}%; width: #{health}%"></div></div>
           </div>
           """
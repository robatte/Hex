class UnitView
  constructor: (@unit) ->

  @image: (unitTypeIdentifier, owner)->
    switch unitTypeIdentifier
      when "farmer" then "assets/unit_peasant_#{ owner.id }.png"
      when "soldier" then "assets/unit_knight_#{ owner.id }.png"

  draw: (idPrefix) ->
    health = Math.round( @unit.currentHealth / @unit.health * 100 )
    return """
           <div class="unit#{ if @unit.isActive then ' active' else ' inactive'}#{ if @unit.currentMove > 0 then ' movable' else ' not-movable'}" id="unit-#{idPrefix}-#{@unit.id}"}>
            <img src='#{ UnitView.image( @unit.type_identifier, @unit.owner) }'/>
            <div class="health"><div class="bar" style="height: #{health}%; width: #{health}%"></div></div>
           </div>
           """

  @moveUnitIconsTo: (activePosition, targetPosition) =>
#    for unit in activePosition.army.getActiveUnits()
#      unitIcon = jQuery(".unit-icon#unit-icon-"+unit.id)
#      # set Icons position realtive to window to 'disconnect' it from parent-tile
#      unitIcon.css
#        "top":  activePosition.tile.y + "px"
#        "position": "fixed"
#        "bottom": "auto"
#
#      #get difference to target-tile
#      targetLeft = targetPosition.tile.x - activePosition.tile.x
#      targetTop = targetPosition.tile.y - activePosition.tile.y
#      #place unit in draw-queue to prevent redraw durin animation
#      View.addToDrawQueue( unitIcon)
#      # gogogogo!
#      unitIcon.animate
#        left: '+='+targetLeft
#        top: '+='+targetTop
#      , 300, "easeInExpo"
    
    
class Tile extends Drawable

  constructor: (position) ->
    @mapPosition = position
    @type = position.type

    width = 512
    height = 450

    super Math.round(width/2 * 3 / 2 * position.q),
          Math.round(width/2 * Math.sqrt(3) * (position.r + position.q / 2)),
          width,
          height, 
          "tile"

    @mapPosition.setTile( this )

    @overlays = {}
    @addOverlay "selected", 'assets/tile_overlay_selected.png'
    @addOverlay "moveTarget", 'assets/tile_overlay_yellow.png'
    @addOverlay "ownerPlayer1", 'assets/tile_base_green.png'
    @addOverlay "ownerPlayer2", 'assets/tile_base_blue.png'

    @update()
    @bindEvents()
    @updateImage()

  addOverlay: ( name, imageUrl ) ->
    @overlays[name] = (new Drawable 0, 0, @width, @height, "overlay").addClass(name).image(imageUrl).hide().appendTo(this)

  update: ->

    # get informations from assined MapPosition object
    @owner = @mapPosition.owner 
    @army = @mapPosition.army


    # set state-layers/visuals
    @setActive( @mapPosition.isActivePosition() )
    @setMoveTarget( Game.get().state.is(GameState.states.own_position_selected) && @mapPosition.isInteractionPosition() )
    # @setOwner( @owner)

    # show unitIcons
    @showUnits()

    # show owner
    @overlays.ownerPlayer1.hide()
    @overlays.ownerPlayer2.hide()
    if @owner?
      if @owner.id == 1 then @overlays.ownerPlayer1.show() else @overlays.ownerPlayer2.show()


  setActive: (activate=true)->
    if activate
      @overlays.selected.show()
    else
      @overlays.selected.hide()
  
  setMoveTarget: (isTarget=true)->
    if isTarget
      @overlays.moveTarget.show()
    else
      @overlays.moveTarget.hide()

  showUnits: ->    
    # remove all icons
    @getjQueryElement().find('.unit-icon').remove()
    #build icons for all unit-types
    typeNr = 0
    for typeIdentifier, units of @mapPosition.army.getUnitsByType() 
      unitNr = 0
      for unit in units
        x = 150 + typeNr * 70 + unitNr*6
        y = 100 + unitNr * 15
        new Drawable( x, @height - y, 36, 50, "unit").image( UnitView.image( typeIdentifier, @owner) ).setAttributes
          id: "unit-icon-#{unit.id}"
          'z-index': (20-unitNr)
        .appendTo(this)

        unitNr += 1
      typeNr += 1


  bindEvents: =>
    @getjQueryElement().data('map-position', @mapPosition)
    @getjQueryElement().on  'click', (e) =>
      e.stopPropagation()
      map_position = jQuery(e.currentTarget).data('map-position')
      new SystemEvent('view.tile.click', {mapPosition: map_position}).dispatch()

  updateImage: ->
    @type = @mapPosition.terrain.type

    filename = switch @type
      when TerrainGrassland.type_identifier then "tile_grassland.png"
      when TerrainVillage.type_identifier then "tile_village.png"
      when TerrainFortress.type_identifier then "tile_fortress.png"


    # set tile image
    @image "assets/#{ filename }"
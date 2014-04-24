class Tile

  @createCraftyTileComponent: () ->

    #Crafty-Component for multi-layer
    Crafty.c 'Layer',
      init: ->
        @requires '2D, DOM, Image'
        @css
          "pointer-events": "none"

    #will be shown if tile is clicked/activated
    Crafty.c 'ActiveOverlay',
      init: ->
        @requires 'Layer'
        @image('assets/tile_overlay_selected.png')
        @attr
          alpha: 1
    #will be shown if tile is move-target
    Crafty.c 'MoveTargetOverlay',
      init: ->
        @requires 'Layer'
        @image('assets/tile_overlay_yellow.png')
        @attr
          alpha: 0.4


    # Crafty Component for tile representation
    Crafty.c 'Tile',

      tile: (tile_position) ->
        @requires('2D, DOM, Image, Mouse')

        @width = 512
        @height = 450
        @size = @width / 2


        @attr
          x: Math.round(@size * 3 / 2 * tile_position.q)
          y: Math.round(@size * Math.sqrt(3) * (tile_position.r + tile_position.q / 2))
          w: @width
          h: @height

        this

      


  constructor: (position) ->
    @mapPosition = position
    @type = position.type
    @craftyTile = Crafty.e('Tile').tile(position)

    @mapPosition.setTile( this )

    # Layer to visualize selection
    @selectedLayer = Crafty.e('ActiveOverlay').attr
      x: @craftyTile.x
      y: @craftyTile.y
    @craftyTile.attach @selectedLayer

    #Layer to visualize move-target
    @moveTargetLayer = Crafty.e('MoveTargetOverlay').attr
      x: @craftyTile.x
      y: @craftyTile.y
    @craftyTile.attach @moveTargetLayer





    @update()
    @bindEvents()
    @updateImage()

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

    @updateCSS()


  updateCSS: ->
    #remove all classes
    jQuery(@craftyTile._element).removeClass "tile-player1 tile-player2"
    if @owner?
      jQuery(@craftyTile._element).addClass "tile-player"+@owner.id

    # set individual classes


  setActive: (activate=true)->
    if activate
      # jQuery( @craftyTile._element).addClass("tile-active") if @mapPosition.isActivePosition(@game)
      @selectedLayer.visible = true
    else
      # jQuery( @craftyTile._element).addClass("tile-inactive") if @game.state.is(GameState.states.select_move_position) && !@mapPosition.isInteractionPosition(@game)
      @selectedLayer.visible = false
  
  setMoveTarget: (isTarget=true)->
    if isTarget
      # jQuery( @craftyTile._element).addClass("tile-move-target") if @game.state.is(GameState.states.select_move_position) && @mapPosition.isInteractionPosition(@game)
      @moveTargetLayer.visible = true
    else
      @moveTargetLayer.visible = false

  showUnits: ->    
    # remove all icons
    jQuery(@craftyTile._element).find('.unit-icon').remove()
    #build icons for all unit-types
    typeNr = 0
    for typeIdentifier, units of @mapPosition.army.getUnitsByType() 
      unitNr = 0
      for unit in units
        x = 150 + typeNr * 70 + unitNr*6
        y = 50 + unitNr * 15
        jQuery("<img class='unit-icon' id='#{unit.id}' src=#{UnitView.image( typeIdentifier, @owner)} style='z-index: #{ 20-unitNr }; left: #{x}px; bottom: #{y}px;'/>").appendTo(@craftyTile._element)
        unitNr += 1
      typeNr += 1

    
    


  bindEvents: ->
    jQuery( @craftyTile._element).data('map-position', @mapPosition)
    jQuery( @craftyTile._element).on  'click', (e) ->
      event.stopPropagation()
      map_position = jQuery(this).data('map-position')
      new SystemEvent('view.tile.click', {mapPosition: map_position}).dispatch()

  updateImage: ->
    @type = @mapPosition.terrain.type

    filename = switch @type
      when TerrainGrassland.type_identifier then "tile_grassland.png"
      when TerrainVillage.type_identifier then "tile_village.png"
      when TerrainFortress.type_identifier then "tile_fortress.png"


    # set tile image
    @craftyTile.image "assets/#{ filename }", "repeat"

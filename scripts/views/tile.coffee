class Tile

  @createCraftyTileComponent: () ->
    Crafty.c 'Tile',
      soldiers: 0
      type: 0 #default-map-type
      value: 50 #Gold increase
      owner: 0 #player Nr.


      tile: (tile_position) ->
        @requires('2D, DOM, Image, Mouse')

        @width = 512
        @height = 450
        @size = @width / 2
        @type = tile_position.type


        @attr
          x: Math.round(@size * 3 / 2 * tile_position.q)
          y: Math.round(@size * Math.sqrt(3) * (tile_position.r + tile_position.q / 2))
          mapPosition: tile_position
          game: Game.instance
          w: @width
          h: @height

        @mapPosition.setTile( this)


        @updateImage()

        this



      updateImage: ->

        filename = switch @type
          when 1 then "tile_grassland.png"
          when 2 then "tile_village.png"


        # set tile image
        @image "assets/#{ filename }", "repeat"



      #Crafty-Component for multi-layer
      Crafty.c 'Layer',
        init: ->
          @requires '2D, DOM, Image'

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
            alpha: 1
      #Shows the owner-overlay
      Crafty.c 'OwnerOverlay',
        init: ->
          @requires 'Layer'
          @image('assets/tile_overlay_green.png')
          @attr
            alpha: .4

  constructor: (position) ->
    @game = Game.instance
    @mapPosition = position
    @craftyTile = Crafty.e('Tile').tile(position)

    # set tile text
    @message = Crafty.e('2D, DOM, Text')
      .unselectable()
      .textColor( "#000000", 1)
      .textFont({"size":"30px"})
      .css({"text-align": "center"})

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

    #Layer to visualize ownership
    # @ownerLayer = Crafty.e('OwnerOverlay').attr
    #   x: @craftyTile.x
    #   y: @craftyTile.y
    # @craftyTile.attach @ownerLayer



    @update()
    @bindEvents()

  update: ->

    # get informations from assined MapPosition object
    @owner = @mapPosition.owner 
    @army = @mapPosition.army

    # update text element
    @message.attr({x: @craftyTile.x + 1, y: @craftyTile.y + 380, w: @craftyTile.w}).text( "Einheiten: " + (if @army? then @army.amountOfUnits() else '0'))

    # set state-layers/visuals
    @setActive( @mapPosition.isActivePosition(@game) )
    @setMoveTarget( @game.state.is(GameState.states.select_move_position) && @mapPosition.isInteractionPosition(@game) )
    # @setOwner( @owner)

    @updateCSS()


  updateCSS: ->
    #remove all classes
    # jQuery(@craftyTile._element).removeClass "tile-active tile-inactive tile-move-target"
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

  # setOwner: (owner=0)->
  #   if owner
  #     @ownerLayer.image('assets/tile_overlay_green.png')
  #   else
  #     @ownerLayer.visible = false


  bindEvents: ->
    jQuery( @craftyTile._element).data('map-position', @mapPosition)
    jQuery( @craftyTile._element).on  'click', () ->
      map_position = jQuery(this).data('map-position')
      new SystemEvent('view.tile.click', {mapPosition: map_position}).dispatch()

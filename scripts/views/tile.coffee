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
    @game = Game.instance
    @mapPosition = position
    @type = position.type
    @craftyTile = Crafty.e('Tile').tile(position)

    @mapPosition.setTile( this )

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





    @update()
    @bindEvents()
    @updateImage()

  update: ->

    # get informations from assined MapPosition object
    @owner = @mapPosition.owner 
    @army = @mapPosition.army

    # update text element
    @message.attr({x: @craftyTile.x + 1, y: @craftyTile.y + 380, w: @craftyTile.w}).text( "Einheiten: " + (if @army? then @army.amountOfUnits() else '0'))

    # set state-layers/visuals
    @setActive( @mapPosition.isActivePosition(@game) )
    @setMoveTarget( @game.state.is(GameState.states.own_position_selected) && @mapPosition.isInteractionPosition(@game) )
    # @setOwner( @owner)

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

  updateImage: ->
    @type_id = @mapPosition.terrain.type_id

    filename = switch @type_id
      when 1 then "tile_grassland.png"
      when 2 then "tile_village.png"
      when 3 then "tile_fortress.png"


    # set tile image
    @craftyTile.image "assets/#{ filename }", "repeat"

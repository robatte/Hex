class Tile

  @createCraftyTileComponent: () ->

    #Crafty-Component for multi-layer
    Crafty.c 'Layer',
      init: ->
        @requires '2D, DOM, Image'

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



      updateLayers: ->
        #set layer-positions to tile-position
        for child in @_children
          child.attr
            x: @x
            y: @y



      setActive: ->
        layer = Crafty.e('Layer').image('assets/tile_base_red.png').attr({"alpha":"0.4"})
        @attach layer
        @updateLayers()



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

    @update()
    @bindEvents()
    @updateImage()

  update: ->

    # get informations from assined MapPosition object
    @owner = @mapPosition.owner
    @army = @mapPosition.army

    # update text element
    @message.attr({x: @craftyTile.x + 1, y: @craftyTile.y + 380, w: @craftyTile.w}).text( "Einheiten: " + (if @army? then @army.amountOfUnits() else '0'))

    @updateCSS()


  updateCSS: ->
    #remove all classes
    jQuery(@craftyTile._element).removeClass "tile-active tile-inactive tile-move-target"
    if @owner?
      jQuery(@craftyTile._element).addClass "tile-player"+@owner.id

    # set individual classes
    jQuery( @craftyTile._element).addClass("tile-active") if @mapPosition.isActivePosition(@game)
    jQuery( @craftyTile._element).addClass("tile-inactive") if @game.state.is(GameState.states.select_move_position) && !@mapPosition.isInteractionPosition(@game)
    jQuery( @craftyTile._element).addClass("tile-move-target") if @game.state.is(GameState.states.select_move_position) && @mapPosition.isInteractionPosition(@game)


  bindEvents: ->
    jQuery( @craftyTile._element).data('map-position', @mapPosition)
    jQuery( @craftyTile._element).on  'click', () ->
      map_position = jQuery(this).data('map-position')
      new SystemEvent('view.tile.click', {mapPosition: map_position}).dispatch()

  updateImage: ->
    @type = @mapPosition.type

    filename = switch @type
      when 1 then "tile_grassland.png"
      when 2 then "tile_village.png"


    # set tile image
    @craftyTile.image "assets/#{ filename }", "repeat"

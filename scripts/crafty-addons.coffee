
# override Crafty's zoom-method
Crafty.viewport.zoom = (zoomVal, time) ->
    if !Crafty.viewport.zoomCurrent?
        Crafty.viewport.zoomCurrent = Settings.default_zoom

    Crafty.viewport.zoomCurrent += zoomVal

    if Crafty.viewport.zoomCurrent < Settings.minZoom then Crafty.viewport.zoomCurrent = Settings.minZoom
    if Crafty.viewport.zoomCurrent > Settings.maxZoom then Crafty.viewport.zoomCurrent = Settings.maxZoom
    centerX = window.innerWidth / 2
    centerY = window.innerHeight / 2
    jQuery("#cr-stage > div").css
        "-webkit-transform-origin" : centerX+"px "+centerY+"px"
        "-moz-transform-origin" : centerX+"px "+centerY+"px"
        "transform-origin" : centerX+"px "+centerY+"px"
        # "-webkit-transition": "-webkit-transform .5s ease-out"
        # "-moz-transition": "-moz-transform .5s ease-out"

    Crafty.viewport.scale( Crafty.viewport.zoomCurrent)
 

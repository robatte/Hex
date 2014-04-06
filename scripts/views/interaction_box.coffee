class InteractionBox

  constructor: (game) ->
    @game = game
    # generate dom element for box
    @box_jquery = jQuery('<div id="interaction-box"></div>')
    jQuery('body').prepend @box_jquery

    # define default values
    @title = "Informationen und Aktionen"

  draw: ->
    html = """
           <h3>#{@title}</h3>
           <p>aktueller Spieler: #{@game.state.player.name}</p>
           """
    @box_jquery.html html

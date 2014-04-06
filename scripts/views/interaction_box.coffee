class InteractionBox

  constructor: (game) ->
    @game = game
    # generate dom element for box
    @box_jquery = jQuery('<div id="interaction-box"></div>')
    jQuery('body').prepend @box_jquery

    # define default values
    @title = "Informationen und Aktionen"

    # set interaction events
    @setInteractionEvents()

  setInteractionEvents: ->
    @box_jquery.on "click", "input#round-next", ->
      new SystemEvent('view.interaction_box.round-next', {}).dispatch()

  draw: ->
    html = """
           <h3>#{@title}</h3>
           <p>aktueller Spieler: #{@game.state.player.name}</p>
           #{@getStateSpecificHTML()}
           <p><input id="round-next" type="button" value="Runde beenden"></p>
           """
    @box_jquery.html html

  getStateSpecificHTML: ->
    switch @game.state.stateId
      when GameState.select_own_position then return @htmlSelectOwnPosition()

  htmlSelectOwnPosition: ->
    "<p>Bitte wähle eine Deiner Positionen auf der Karte aus</p>"

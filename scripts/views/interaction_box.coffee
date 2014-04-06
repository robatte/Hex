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

    @box_jquery.on "click", "input#move-units", ->
      new SystemEvent('view.interaction_box.move-units', {}).dispatch()

  draw: ->
    html = """
           <h3>#{@title}</h3>
           <p>
              Spieler: #{@game.state.player.name} <br>
              Geld: #{@game.state.player.money_units} Bitcoin
            </p>
           #{@getStateSpecificHTML()}
           <p><input id="round-next" type="button" value="Runde beenden"></p>
           """
    @box_jquery.html html

  getStateSpecificHTML: ->
    switch @game.state.currentState
      when GameState.states.select_own_position then return @htmlSelectOwnPosition()
      when GameState.states.own_position_selected then return @htmlOwnPositionSelect()
      when GameState.states.select_move_position then return @htmlSelectMovePosition()

  htmlSelectOwnPosition: ->
    "<p>Bitte wähle eine Deiner Positionen auf der Karte aus</p>"

  htmlOwnPositionSelect: ->
    """
    <p>Wähle eine Aktion</p>
    <p><input id="move-units" type="button" value="Einheiten bewegen"></p>
    """

  htmlSelectMovePosition: ->
    "<p>Bitte wähle das Feld zu dem Du die Einheiten bewegen möchtest.</p>"

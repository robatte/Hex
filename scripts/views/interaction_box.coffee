class InteractionBox

  constructor: () ->
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

    @box_jquery.on "click", "input#build-units", ->
      new SystemEvent('view.interaction_box.build-units', {}).dispatch()

  draw: ->
    html = """
           <h3>#{@title}</h3>
           <p>
              Spieler: #{Game.get().state.player.name} <br>
              Geld: #{Game.get().state.player.money_units} Bitcoin
            </p>
           #{@getStateSpecificHTML()}
           <p><input id="round-next" type="button" value="Runde beenden"></p>
           """
    @box_jquery.html html

  getStateSpecificHTML: ->
    switch Game.get().state.currentState
      when GameState.states.select_own_position then return @htmlSelectOwnPosition()
      when GameState.states.own_position_selected then return @htmlOwnPositionSelect()

  htmlSelectOwnPosition: ->
    "<p>Bitte wähle eine Deiner Positionen auf der Karte aus</p>"

  htmlOwnPositionSelect: ->
    if Game.get().state.activePosition.terrain.unitsToBuild().length > 0
      """
      <p>Wähle eine Aktion</p>
      <p><input id="build-units" type="button" value="Einheiten ausbilden"></p>
      """
    else
      ""

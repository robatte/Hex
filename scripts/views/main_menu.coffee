class MainMenuDialog

# implements sigelton pattern by http://coffeescriptcookbook.com/chapters/design_patterns/singleton

  instance = null

  @get: () ->
    instance ?= new MainMenuDialogPrivate()

  class MainMenuDialogPrivate 


    heigth: 168
    width: 978
    menu_img_path: "assets/main-menu.png"
    menu_style:"""
                position: relative;
                margin: 0 auto;
                width: 978px;
                height: 168px;
               """

    left_panel_style: """
                  top: 20px;
                  left: 20px;
                  width: 140px;
                  height: 130px;
                 """
    center_panel_style: """
                  top: 54px;
                  left: 186px;
                  width: 576px;
                  height: 93px;
                 """
    right_panel_style: """
                  top: 54px;
                  right: 20px;
                  width: 170px;
                  height: 125px;
                 """

    constructor: () ->

      # generate dom element for dialog
      @menu_jquery = jQuery( "<div class='menu-wrapper'></div>" )
      jQuery('body').prepend @menu_jquery
      @update()
      @setInteractionEvents()


    update: () ->
      @player = Game.get().state.player
      @position = if Game.get().state.currentState == GameState.states.own_position_selected then Game.get().state.activePosition else null

      @menu_jquery.html @html()

    setInteractionEvents: ->
      @menu_jquery.on "click", "input#round-next-btn", ->
        new SystemEvent('view.interaction_box.round-next', {}).dispatch()

      # @box_jquery.on "click", "input#build-units", ->
      #   new SystemEvent('view.interaction_box.build-units', {}).dispatch()


      
    html: () ->
      """
        <div id='main-menu' class='menu' style='#{ @menu_style }'>
        <img id="menu-image" src="#{ @menu_img_path }" />
        <div id="left-panel" class="menu-panel" style='#{ @left_panel_style }'>#{ @addLeftItems() }</div>
        <div id="center-panel" class="menu-panel" style='#{ @center_panel_style }'>#{ @addCenterItems() }</div>
        <div id="right-panel" class="menu-panel" style='#{ @right_panel_style }'>#{ @addRightItems() }</div>
        </div>
      """

    addLeftItems: () ->
      income = if @player.money_units > 0 then "<span class='money'>/ +#{@player.money_units}</span>" else "" 
      html = ""
      html += """
              <p id='main-menu-player'>Spieler: <span>#{ @player.name }</span></p> 
              <p id='main-menu-money'>Geld: <span class="money">#{ @player.money_units }</span> #{ income }</p>
              """
      html

    addCenterItems: () ->
      html = ""
      html += """
              <div id="tile-unit-list">#{ @listUnits() }</div>
              """
      html

    addRightItems: () ->
      html = ""
      html += """
              <input id="round-next-btn" type="button" value="Runde beenden">
              <p>Einheiten ausbilden</p>
              """
      if Game.get().state.currentState == GameState.states.own_position_selected && Game.get().state.activePosition.terrain.unitsToBuild().length > 0
        for unitType in @position.terrain.unitsToBuild()
          attributes = Unit.attributesByIdentifier( unitType )
          html += """
                  <div class='build-unit-btn'>
                    <img class='unit-image' src='#{ UnitView.image( unitType, @player) }' />
                    <p class='unit-cost money'>#{ attributes.building_costs }</p>
                  </div>
                  """

      html

    listUnits: () ->
      html = ""
      if @position
        for unit in @position.army.units 
          html += (new UnitView( unit)).draw()

      html






      

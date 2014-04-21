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
                  width: 155px;
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
        new SystemEvent('view.main-menu.round-next', {}).dispatch()

      @menu_jquery.on "click", ".build-unit-btn", ->
        units = {}
        units[$(this).data('type')] = 1
        new SystemEvent('view.main-menu.build-units', units).dispatch()


      
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
      income = if @player.moneyPerRound() > 0 then "<span class='money'>/ +#{@player.moneyPerRound()}</span>" else "" 
      html = ""
      html += """
              <dl>
                <dt id='main-menu-player'>Spieler</dt><dd>#{ @player.name }</dd> 
                <dt id='main-menu-money'>Geld</dt><dd><span class="money">#{ @player.money_units }</span> #{ income }</dd>
                #{ @terrainInfo() }
              </dl>
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
                  <div class='build-unit-btn' data-type='#{ unitType }'>
                    <img class='unit-image' src='#{ UnitView.image( unitType, @player) }' />
                    <p class='unit-cost money'>#{ attributes.building_costs }</p>
                  </div>
                  """

      html

    terrainInfo: ->
      html = ""
      if @position
        html += """
                <h3>#{ @position.terrain.type }</h3>
                <dt>Steuer</dt><dd><span class='money'>+#{@position.terrain.taxRate()}</span></dd>
                """
      html


    listUnits: () ->
      html = ""
      if @position
        for unit in @position.army.units 
          html += (new UnitView( unit)).draw()

      html






      

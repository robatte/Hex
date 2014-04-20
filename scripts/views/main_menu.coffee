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
                  top: 26px;
                  right: 20px;
                  width: 170px;
                  height: 125px;
                 """

    constructor: () ->

      # generate dom element for dialog
      @menu_jquery = jQuery( "<div class='menu-wrapper'></div>" )
      jQuery('body').prepend @menu_jquery
      @update()


    update: () ->
      @player = Game.get().state.player
      @position = Game.get().state.currentState == 'own_position_selected' && Game.get().state.activePosition || null

      @menu_jquery.html @html()

      
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
      html = ""
      html += """
              <p id='main-menu-player'>Spieler: <span>#{ @player.name }</span></p> 
              <p id='main-menu-money'>Geld: #{ @player.money_units } Coins</p>
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
      # for n in [0..Math.max( @attacker.length, @defender.length)]
      html += """
              """
      html

    listUnits: () ->
      html = ""
      if @position
        for unit in @position.army.units 
          html += (new UnitView( unit)).draw()

      html




      

class BattleViewDialog

# implements sigelton pattern by http://coffeescriptcookbook.com/chapters/design_patterns/singleton

  instance = null

  @get: () ->
    instance ?= new BattleViewDialogPrivate()

  class BattleViewDialogPrivate extends Dialog

    title: "Gefecht"
    heigth: 450
    width: 600
    button_succes_lable: "Angreifen"
    button_cancle_lable: "Abbrechen"

    init: () ->
      super()

      
    html: () ->
      """
      <div id="units-list">#{ @addUnits() }</div>
      """

    addUnits: () ->
      html = ""
      for n in [0..Math.max( @attacker.units.length, @defender.units.length)]
        html += """
                <div class="attacker-list" id="attacker-#{ n }">#{ @showUnit( @attacker.units[n]) }</div>
                <div class="defender-list" id="defender-#{ n }">#{ @showUnit( @defender.units[n]) }</div>
                """
      html

    showUnit: (unit) ->
      if unit?
        return """
               <img src='assets/#{ (new UnitView( unit)).image() }'/>
               <div class="health"><div class="bar" style="height: #{unit.currentHealth / unit.health * 100}%"></div></div>
               """
      else 
        return ""



    open: (@attacker, @defender, @callback_build, @callback_cancle = null ) ->
      super @callback_build, @callback_cancle

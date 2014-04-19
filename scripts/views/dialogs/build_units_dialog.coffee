class BuildUnitsDialog

# implements sigelton pattern by http://coffeescriptcookbook.com/chapters/design_patterns/singleton

  instance = null

  @get: () ->
    instance ?= new BuildUnitsDialogPrivate()

  class BuildUnitsDialogPrivate extends Dialog

    title: "Einheiten ausbilden"
    heigth: 450
    width: 600
    button_succes_lable: "Einheiten ausbilden"
    button_cancle_lable: "Abbrechen"

    init: () ->
      super()

      _this = this
      @dialog_jquery.find("input.spinner").each () ->
        jQuery(this).spinner
          min: 0
          change: -> _this.updateCosts()
          stop: -> _this.updateCosts()



    html: () ->
      """
      <p>Wähle die Einheiten die Du ausbilden möchtest.</p>
      <table>
      <tr>
      <td id="current-money">#{ @current_money }</td>
      <td>aktuelles Guthaben</td>
      </tr>
      <tr>
      <td id="current-costs">0</td>
      <td>Kosten für die Ausbildung</td>
      </tr>
      <tr>
      <td id="new-balance">#{ @current_money }</td>
      <td>neues Guthaben</td>
      </tr>
      </table>
      <form>
      <fieldset>
      #{ @addUnitSelectors() }
      </fieldset>
      </form>
      """

    addUnitSelectors: () ->
      html = ""
      for unit_name, unit of @units
        html += """
                <input type="text" name="#{ unit.type_identifier }" data-costs="#{ unit.building_costs }" value="0" class="spinner unit-selector">
                <label for="name">#{ unit.name }</label><br>
                """
      html

    updateData: () ->
      @result = {}
      @price = 0
      that = this
      @dialog_jquery.find("input.unit-selector").each ->
        el = jQuery(this)
        amount = parseInt( el.val() )
        if !isNaN(amount)
          that.result[el.attr('name')] = amount
          that.price += amount * parseInt( el.data('costs') )


    open: (@current_money, @units, @callback_build, @callback_cancle = null ) ->
      super @callback_build, @callback_cancle



    updateCosts: ->
      @updateData()
      jQuery("#current-costs").html(@price)
      jQuery("#new-balance").html(@current_money - @price)
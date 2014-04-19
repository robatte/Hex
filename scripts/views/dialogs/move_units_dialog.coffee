class MoveUnitsDialog

# implements sigelton pattern by http://coffeescriptcookbook.com/chapters/design_patterns/singleton

  instance = null

  @get: () ->
    instance ?= new MoveUnitsDialogPrivate()

  class MoveUnitsDialogPrivate extends Dialog

    title: "Einheiten bewegen"
    heigth: 300
    width: 600
    button_succes_lable: "Einheiten bewegen"
    button_cancle_lable: "Abbrechen"

    army: {}

    init: () ->
      super()

      _this = this
      @dialog_jquery.find("input.spinner").each () ->
        jQuery(this).spinner
          min: 0
          max: jQuery(this).data('max')


    html: () ->
      """
      <p>Wähle die Einheiten die Du bewegen möchtest.</p>
      <form>
      <fieldset>
      #{ @addUnitSelectors() }
      </fieldset>
      </form>
      """

    addUnitSelectors: () ->
      html = ""
      for type, units of @army.getUnitsByType()
        html += """
                <input type="text" name="#{ type }" data-max="#{ units.length }" value="#{ units.length }" class="spinner unit-selector">
                <label for="name">#{ units[0].name }</label><br>
                """
      html

    updateData: () ->
      @result = {}
      that = this
      @dialog_jquery.find("input.unit-selector").each ->
        el = jQuery(this)
        amount = parseInt( el.val() )
        if !isNaN(amount)
          that.result[el.attr('name')] = amount

    open: (@army, @callback_build, @callback_cancle = null ) ->
      super @callback_build, @callback_cancle


    updateCosts: ->
      @updateData()
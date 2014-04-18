class Dialog

  @next_dialog_id = 0

  constructor: () ->
    #set dialog id
    @id = Dialog.next_dialog_id
    Dialog.next_dialog_id += 1

    # generate dom element for dialog
    @dialog_jquery = jQuery( "<div id='dialog-#{ @id }' class='dialog' title='#{ @title() }'></div>" )
    jQuery('body').prepend @dialog_jquery

    # init dialog
    @init()


class BuildUnitsDialog

  # implements sigelton pattern by http://coffeescriptcookbook.com/chapters/design_patterns/singleton

  instance = null

  @get: () ->
    instance ?= new BuildUnitsDialogPrivate()

  class BuildUnitsDialogPrivate extends Dialog

    unitsToBuild: {}

    init: () ->
      @dialog_jquery.dialog(
        autoOpen: false,
        height: 450,
        width: 600,
        modal: true,
        buttons:
          "Einheiten ausbilden": () =>
            @close()

          "Abbrechen": () =>
            @dialog_jquery.dialog "close"
            @callback_cancle() if @callback_cancle?
      )

      _this = this
      @dialog_jquery.find("input.spinner").each () ->
        jQuery(this).spinner
          min: 0
          change: -> _this.updateCosts()
          stop: -> _this.updateCosts()

    title: () ->
      "Einheiten ausbilden"

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
          <label for="name">#{ unit.name }</label>
        """
      html

    updateUnitsToBuild: () ->
      @unitsToBuild = {}
      @price = 0
      that = this
      jQuery("input.unit-selector").each ->
        el = jQuery(this)
        amount = parseInt( el.val() )
        if !isNaN(amount)
          that.unitsToBuild[el.attr('name')] = amount
          that.price += amount * parseInt( el.data('costs') )


    open: (@current_money, @units, @callback_build, @callback_cancle = null) ->
      @dialog_jquery.html @html()
      @init()
      @dialog_jquery.dialog "open"

    close: ->
      @updateUnitsToBuild()
      @dialog_jquery.dialog "close"
      @callback_build @unitsToBuild

    updateCosts: ->
      @updateUnitsToBuild()
      jQuery("#current-costs").html(@price)
      jQuery("#new-balance").html(@current_money - @price)


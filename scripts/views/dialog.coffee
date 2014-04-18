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
        height: 300,
        width: 600,
        modal: true,
        buttons:
          "Einheiten ausbilden": () =>
            @close()

          "Abbrechen": () =>
            @dialog_jquery.dialog "close"
            @callback_cancle() if @callback_cancle?
      )

      @dialog_jquery.find("input.spinner").each () ->
        jQuery(this).spinner { min: 0 }

    title: () ->
      "Einheiten ausbilden"

    html: () ->
      """
        <p>Wähle die Einheiten die Du ausbilden möchtest.</p>
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
          <input type="text" name="#{ unit.type_identifier }" value="0" class="spinner unit-selector">
          <label for="name">#{ unit.name }</label>
        """
      html

    updateUnitsToBuild: () ->
      @unitsToBuild = {}
      that = this
      jQuery("input.unit-selector").each ->
        el = jQuery(this)
        that.unitsToBuild[el.attr('name')] = parseInt( el.val() )


    open: (@current_money, @units, @callback_build, @callback_cancle = null) ->
      @dialog_jquery.html @html()
      @init()
      @dialog_jquery.dialog "open"

    close: ->
      @updateUnitsToBuild()
      @dialog_jquery.dialog "close"
      @callback_build @unitsToBuild

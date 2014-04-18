class Dialog

  @next_dialog_id = 0

  constructor: () ->
    #set dialog id
    @id = Dialog.next_dialog_id
    Dialog.next_dialog_id += 1

    # generate dom element for dialog
    @dialog_jquery = jQuery( @html() )
    jQuery('body').prepend @dialog_jquery

    # init dialog
    @init()


class BuildUnitsDialog extends Dialog

  # implements sigelton pattern by http://coffeescriptcookbook.com/chapters/design_patterns/singleton

  instance = null

  @get: () ->
    instance ?= new BuildUnitsDialogPrivate()

  class BuildUnitsDialogPrivate extends Dialog

    init: () ->
      @dialog_jquery.dialog(
        autoOpen: false,
        height: 300,
        width: 600,
        modal: true,
      )

      @dialog_jquery.find("input.spinner").each () ->
        jQuery(this).spinner { min: 0 }

    title: () ->
      "Einheiten ausbilden"

    html: () ->
      """
        <div id="dialog-#{ @id }" class="dialog" title="#{ @title() }">
          <p>Wähle die Einheiten die Du ausbilden möchtest.</p>
          <form>
            <fieldset>
              <input type="text" name="amount-1" id="amount-1" value="0" class="spinner">
              <label for="name">Einheit Typ 1</label>
            </fieldset>
          </form>
        </div>
      """

    open: (@current_money_units) ->
      @dialog_jquery.dialog "open"
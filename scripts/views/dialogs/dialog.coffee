class Dialog

  @next_dialog_id = 0

  result: {}

  constructor: () ->
    #set dialog id
    @id = Dialog.next_dialog_id
    Dialog.next_dialog_id += 1

    # generate dom element for dialog
    @dialog_jquery = jQuery( "<div id='dialog-#{ @id }' class='dialog' title='#{ @title }'></div>" )
    jQuery('body').prepend @dialog_jquery


  init: ->
    @dialog_jquery.dialog
      autoOpen: false,
      height: @heigth,
      width: @width,
      modal: true,
      buttons:
        [
          {text: @button_succes_lable, click: () => @close() },
          {text: @button_cancle_lable, click: () => @cancle() }
        ]

  cancle: ->
    @dialog_jquery.dialog "close"
    @callback_cancle() if @callback_cancle?

  open: (@callback_build, @callback_cancle = null) ->
    @dialog_jquery.html @html()
    @init()
    @dialog_jquery.dialog "open"

  close: ->
    @updateData()
    @dialog_jquery.dialog "close"
    @callback_build @result

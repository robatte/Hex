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
    buttons = []
    buttons.push {text: @button_succes_lable, click: () => @close() } if @button_succes_lable != ""
    buttons.push {text: @button_cancle_lable, click: () => @cancle()} if @button_cancle_lable != ""

    @dialog_jquery.dialog
      autoOpen: false,
      height: @heigth,
      width: @width,
      modal: true,
      buttons: buttons

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

  updateData: ->

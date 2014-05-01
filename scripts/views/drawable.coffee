
class Drawable

  constructor: (@x, @y, @width, @height, @tag='div') ->
    @elem = jQuery "<#{@tag} class='drawable' style='left:#{@x}px;top:#{@y}px;width:#{@width}px;height:#{@height}px'></#{@tag}>"
    View.container.append @elem
    @

  image: ( @imageUrl ) ->
    @elem.css "background-image", "url(#{@imageUrl})"
    @

  append: ( other ) ->
    @elem.append other.getjQueryElement()
    @

  appendTo: ( other ) ->
    other.append this
    @

  getDOMElement: ->
    @elem.get()

  getjQueryElement: ->
    @elem

  show: ->
    @elem.show()
    @

  hide: ->
    @elem.hide()
    @

  addClass: (className) ->
    @elem.addClass className
    @

  removeClass: (className) ->
    @elem.removeClass className
    @

  setAttributes: (attr) ->
    @elem.attr attr
    @

  setPosition: (x, y) ->
    @elem.css { left: x, top: y }





'use strict'

define [
  'jquery'
  'jquery.mousewheel'
  'bacon'
  'lodash'
  'modules/base'
], ($, $mousewheel, Bacon, _, Base) ->

  class Model extends Base.Model

    _$document: undefined
    _$window: undefined

    defaults:
      delta: 0
      deltaX: 0
      deltaY: 0
      scrollLeft: 0
      scrollCenter: 0
      scrollRight: 0
      scrollTop: 0
      scrollMiddle: 0
      scrollBottom: 0
      width: 0
      height: 0

    updateMousewheel: (ev, delta, deltaX, deltaY) =>
      data =
        delta: delta
        deltaX: deltaX
        deltaY: deltaY
      @set data

    updateResize: =>
      data =
        width: @_$window.width()
        height: @_$window.height()
      @set data

    updateScroll: =>
      scrollTop = @_$document.scrollTop()
      scrollLeft = @_$document.scrollLeft()
      width = @get 'width'
      height = @get 'height'
      data =
        scrollLeft: scrollLeft
        scrollCenter: scrollLeft + (width / 2)
        scrollRight: scrollLeft + width
        scrollTop: scrollTop
        scrollMiddle: scrollTop + (height / 2)
        scrollBottom: scrollTop + height
      @set data

    initialize: =>
      @_$document = $(document)
      @_$window = $(window)

      mousewheels = @_$window.asEventStream 'mousewheel'
      resizes = @_$window.asEventStream 'resize'
      scrolls = @_$window.asEventStream 'scroll'

      _updateMousewheel = _.debounce @updateMousewheel, 100
      _updateResize = _.debounce @updateResize, 500
      _updateScroll = _.debounce @updateScroll, 300

      mousewheels.onValue @updateMousewheel
      resizes.onValue _updateResize
      scrolls.onValue @updateScroll

      @updateResize()
      @updateScroll()


  class Status extends Base.View

    _status: {}

    el: '#status'

    update: =>
      @_status = @model.attributes

    render: =>
      @update()
      @$el.empty()

      for key, val of @_status
        @$el.append "#{key}=#{val}<br>"

      return @

    initialize: =>
      @listenTo @model, 'change', @render
      @render()


  model = new Model()

  Window =
    window: model
    #status: new Status { model: model }

  return Window

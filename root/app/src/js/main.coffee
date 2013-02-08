'use strict'

require [
  'modules/base'
], (io, Base) ->

  $ ->

    class ElementA extends Base.View
      el: '#a'
      render: =>
        @$el
        .find('h1')
        .empty()
        .append('Hello, A!')
      initialize: =>
        @render()


    class ElementB extends Base.View
      el: '#b'
      render: =>
        @$el
        .find('h1')
        .empty()
        .append('Hello, B!')
      initialize: =>
        @render()


    class ElementC extends Base.View
      el: '#c'
      render: =>
        @$el
        .find('h1')
        .empty()
        .append('Hello, C!')
      initialize: =>
        @render()


    a = new ElementA()
    b = new ElementB()
    c = new ElementC()

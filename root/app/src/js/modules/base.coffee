'use strict'

define [
  'lodash'
  'backbone'
], (_, Backbone) ->

  class Model extends Backbone.Model

    request: =>
      console.debug 'Model started requesting.'

    sync: =>
      console.log 'Model synchronised.'

    error: =>
      console.debug 'Model got an error while saving.'

    fetch: (options) =>
      options = {} unless options?
      options.crossDomain = true
      options.dataType = 'jsonp'
      options.jsonp = 'jsonp'
      super options

    initialize: =>
      @on 'request', @request
      @on 'sync', @sync
      @on 'error', @error


  class Collection extends Backbone.Collection

    request: =>
      console.debug 'Collection started requesting.'

    sync: =>
      console.log 'Collection synchronised.'

    fetch: (options) =>
      options = {} unless options?
      options.crossDomain = true
      options.dataType = 'jsonp'
      options.jsonp = 'jsonp'
      super options

    initialize: =>
      @on 'request', @request
      @on 'sync', @sync


  class View extends Backbone.View


  Base =
    Model: Model
    Collection: Collection
    View: View

  return Base

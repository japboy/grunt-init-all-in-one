'use strict'

require.config

  baseUrl: '.'

  paths:
    'jquery': '../../vendor/js/jquery-1.9.1'
    'jquery.mousewheel': '../../vendor/js/jquery.mousewheel-3.1.1'
    'lodash': '../../vendor/js/lodash-1.0.1'
    'backbone': '../../vendor/js/backbone-1.0.0'
    'bacon': '../../vendor/js/Bacon-0.1.2'
    'socket.io': '../../vendor/js/socket.io-0.9.11'

  shim:
    'jquery.mousewheel':
      deps: ['jquery']

    'bacon':
      deps: ['jquery']
      exports: 'Bacon'

    'lodash':
      exports: '_'

    'backbone':
      deps: ['jquery', 'lodash']
      exports: 'Backbone'

    'socket.io':
      exports: 'io'

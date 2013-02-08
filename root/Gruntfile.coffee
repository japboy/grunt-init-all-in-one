'use strict'

fs = require 'fs'
path = require 'path'
{exec, spawn} = require 'child_process'

q = require 'q'

lrUtils = require 'grunt-contrib-livereload/lib/utils'


lrSnippet = lrUtils.livereloadSnippet

folderMount = (connect, point) ->
  return connect.static path.resolve(point)


module.exports = (grunt) ->

  conf =
    pkg: grunt.file.readJSON 'package.json'

    path:
      app:
        source: path.join 'app', 'src'
        intermediate: path.join 'app', '.intermediate'
        publish: path.join 'app', 'dist'
        reduce: path.join 'app', 'reduced'
      server:
        source: path.join 'srv', 'src'
        publish: path.join 'srv', 'dist'
      test: path.join 'test'
      document: path.join 'docs'

    ###*
    # Delete specified filess & directories
    # @property grunt-contrib-clean
    # @type Object
    # @url https://github.com/gruntjs/grunt-contrib-clean#readme
    ###
    clean:
      options:
        force: true
      optimised:
        src: '<%= path.app.reduce %>'

    ###*
    # CoffeeScript
    # @property grunt-contrib-coffee
    # @type Object
    # @url https://github.com/gruntjs/grunt-contrib-coffee#readme
    ###
    coffee:
      options:
        bare: true
        sourceMap: true
      source:
        expand: true
        cwd: '<%= path.app.source %>/js'
        src: '**/*.(litcoffee|coffee)'
        dest: '<%= path.app.intermediate %>/js'
        ext: '.js'

    ###*
    # CoffeeScript Lint
    # @property grunt-coffeelint
    # @type Object
    # @url https://github.com/vojtajina/grunt-coffeelint#readme
    # @url http://www.coffeelint.org/#options
    ###
    coffeelint:
      options:
        indentation: 2
        max_line_length: 80
        camel_case_classes: true
        no_trailing_semicolons:  true
        no_implicit_braces: true
        no_implicit_parens: false
        no_empty_param_list: true
        no_tabs: true
        no_trailing_whitespace: true
        no_plusplus: false
        no_throwing_strings: true
        no_backticks: true
        line_endings: true
        no_stand_alone_at: false
      source:
        src: [
          '<%= path.app.source %>/js/**/*.coffee'
          'Gruntfile.coffee'
        ]

    ###*
    # Connect & LiveReload static web server
    # @property grunt-contrib-connect
    # @property grunt-contrib-livereload
    # @type Object
    # @url https://github.com/gruntjs/grunt-contrib-connect#readme
    # @url https://github.com/gruntjs/grunt-contrib-livereload#readme
    ###
    connect:
      publish:
        options:
          port: 50000
          middleware: (connect, options) ->
            return [lrSnippet, folderMount(connect, 'dist')]
      reduce:
        options: 50001
        base: '<%= path.app.reduce %>'

    ###*
    # File copy
    # @property grunt-contrib-copy
    # @type Object
    # @url https://github.com/gruntjs/grunt-contrib-copy#readme
    ###
    copy:
      source:
        expand: true
        cwd: '<%= path.app.source %>'
        src: [
          '**/*'
          '!**/*.coffee'
          '!**/*.jade'
          '!**/*.jst'
          '!**/*.less'
          '!**/*.sass'
          '!**/*.scss'
          '!**/*.styl'
        ]
        dest: '<%= path.app.intermediate %>'
      intermediate:
        expand: true
        cwd: '<%= path.app.intermediate %>'
        src: [
          '**/*.html'
          'img/**/*'
        ]
        dest: '<%= path.app.publish %>'

    ###*
    # CSS Lint
    # @property grunt-css
    # @type Object
    # @url https://github.com/jzaefferer/grunt-css#readme
    ###
    csslint:
      intermediate:
        src: '<%= path.app.intermediate %>/css/**/*.css'

    ###*
    # CSSO
    # @property grunt-csso
    # @type Object
    # @url https://github.com/t32k/grunt-csso#readme
    ###
    csso:
      options:
        restructure: true
      publish:
        src: '<%= path.app.publish %>/css/app.css'
        dest: '<%= path.app.publish %>/css/app.min.css'

    ###*
    # Docco
    # @property grunt-docco
    # @type Object
    # @url https://github.com/DavidSouther/grunt-docco#readme
    ###
    docco:
      options:
        output: 'docs/docco/'
      source:
        src: [
          '<%= path.app.source %>/js/**/*.coffee'
          '<%= path.app.ource %>/js/**/*.js'
        ]

    ###*
    # HTML Lint
    # @property grunt-html
    # @type Object
    # @url https://github.com/jzaefferer/grunt-html#readme
    ###
    htmllint:
      intermediate:
        src: '<%= path.app.intermediate %>/**/*.html'

    ###*
    # Jade
    # @property grunt-contrib-jade
    # @type Object
    # @url https://github.com/gruntjs/grunt-contrib-jade#readme
    ###
    jade:
      options:
        pretty: true
        data: grunt.file.readJSON 'package.json'
      source:
        expand: true
        cwd: '<%= path.app.source %>'
        src: '**/!(_)*.jade'
        dest: '<%= path.app.intermediate %>'
        ext: '.html'

    ###*
    # JSHint
    # @property grunt-contrib-jshint
    # @type Object
    # @url https://github.com/gruntjs/grunt-contrib-jshint#readme
    ###
    jshint:
      options:
        jshintrc: '.jshintrc'
      source:
        src: '<%= path.app.source %>/js/**/*.js'

    ###*
    # JSON Lint
    # @property grunt-jsonlint
    # @type Object
    # @url https://github.com/brandonramirez/grunt-jsonlint#readme
    ###
    jsonlint:
      source:
        src: [
          '<%= path.app.source %>/**/*.json'
          'package.json'
        ]

    ###*
    # Underscore.js template
    # @property grunt-contrib-jst
    # @type Object
    # @url https://github.com/gruntjs/grunt-contrib-jst#readme
    ###
    jst:
      options:
        prettify: true
      source:
        src: '<%= path.app.source  %>/jst/**/*.jst'
        dest: '<%= path.app.intermediate %>/jst/templates.js'

    ###*
    # LESS
    # @property grunt-contrib-less
    # @type Object
    # @url https://github.com/gruntjs/grunt-contrib-less#readme
    ###
    less:
      options:
        compass: false
        yuicompress: false
        optimization: null
      source:
        expand: true
        cwd: '<%= path.app.source %>/css'
        src: '**/!(_)*.less'
        dest: '<%= path.app.intermediate %>/css'
        ext: '.css'

    ###*
    # Markdown
    # @property grunt-markdown
    # @type Object
    # @url https://github.com/treasonx/grunt-markdown#readme
    ###
    markdown:
      options:
        gfm: true
        highlight: 'auto'
        codeLines:
          before: '<span>'
          after: '</span>'
      source:
        expand: true
        cwd: '<%= path.app.source %>'
        src: '**/!(_)*.md'
        dest: '<%= path.app.intermediate %>'
        ext: '.html'

    ###*
    # AssetGraph
    # @property grunt-reduce
    # @type Object
    # @url https://github.com/Munter/grunt-reduce#readme
    # @url https://github.com/One-com/assetgraph#readme
    # @url https://github.com/One-com/assetgraph-builder#readme
    # @url https://github.com/One-com/assetgraph-sprite#readme
    ###
    reduce:
      root: '<%= path.app.publish %>'
      outRoot: '<%= path.app.reduce %>'
      less: false
      manifest: false
      pretty: true

    ###*
    # File change observer
    # @property grunt-regarde
    # @type Object
    # @url https://github.com/yeoman/grunt-regarde#readme
    ###
    regarde:
      source:
        files: '<%= path.app.source %>/**/*'
        tasks: [
          'default'
          'livereload'
        ]

    ###*
    # RequireJS
    # @property grunt-contrib-requirejs
    # @type Object
    # @url https://github.com/gruntjs/grunt-contrib-requirejs#readme
    # @url https://github.com/jrburke/r.js/blob/master/build/example.build.js
    # @url https://github.com/jrburke/almond#readme
    ###
    requirejs:
      css:
        options:
          optimizeCss: 'standard.keepComments.keepLines'
          cssIn: '<%= path.app.intermediate %>/css/config.css'
          out: '<%= path.app.publish %>/css/app.css'
      js:
        options:
          mainConfigFile: '<%= path.app.intermediate %>/js/config.js'
          optimize: 'none'
          name: '../../vendor/js/almond-0.2.5'
          include: ['main']
          insertRequire: ['main']
          out: '<%= path.app.publish %>/js/app.js'
          wrap: true

    ###*
    # Sass/SassyCSS
    # @property grunt-contrib-sass
    # @type Object
    # @url https://github.com/gruntjs/grunt-contrib-sass#readme
    ###
    sass:
      options:
        unixNewlines: true
        style: 'nested'
        compass: true
        noCache: true
      source:
        expand: true
        cwd: '<%= path.app.source %>/css'
        src: [
          '**/!(_)*.sass'
          '**/!(_)*.scss'
        ]
        dest: '<%= path.app.intermediate %>/css'
        ext: '.css'

    ###*
    # Mocha CLI test driver
    # @property grunt-simple-mocha
    # @type Object
    # @url https://github.com/yaymukund/grunt-simple-mocha#readme
    ###
    simplemocha:
      options:
        compilers: 'coffee:coffee-script'
        globals: []
        ignoreLeaks: false
        ui: 'bdd'
        reporter: 'spec'
      test:
        src: '<%= path.test %>/**/*.coffee'

    ###*
    # Styleguide generator using StyleDocco/KSS
    # @property grunt-styleguide
    # @type Object
    # @url https://github.com/indieisaconcept/grunt-styleguide#readme
    ###
    styleguide:
      css:
        src: '<%= path.app.source %>/css/**/*'
        dest: '<%= path.document %>/styledocco'

    ###*
    # Stylus
    # @property grunt-contrib-stylus
    # @type Object
    # @url https://github.com/gruntjs/grunt-contrib-stylus#readme
    ###
    stylus:
      options:
        compress: false
      source:
        expand: true
        cwd: '<%= path.app.source %>/css'
        src: '**/!(_)*.styl'
        dest: '<%= path.app.intermediate %>/css'
        ext: '.css'

    ###*
    # UglifyJS
    # @property grunt-contrib-uglify
    # @type Object
    # @url https://github.com/gruntjs/grunt-contrib-uglify#readme
    ###
    uglify:
      options:
        sourceMap: '<%= path.app.publish %>/js/app.map.json'
        sourceMapRoot: '.'
        sourceMappingURL: 'app.map.json'
        preserveComments: 'some'
      publish:
        src: '<%= path.app.publish %>/js/app.js'
        dest: '<%= path.app.publish %>/js/app.min.js'

    ###*
    # YUIDoc
    # @property grunt-contrib-yuidoc
    # @type Object
    # @url https://github.com/gruntjs/grunt-contrib-yuidoc#readme
    ###
    yuidoc:
      options:
        paths: '<%= path.app.source %>/js'
        outdir: '<%= path.document %>/yuidoc'
      js:
        name: '<%= pkg.name %>'
        description: '<%= pkg.description %>'
        version: '<%= pkg.version %>'

    fix_source_maps:
      publish:
        expand: true
        cwd: '<%= path.publish %>'
        src: '*.map'
        dest: '<%= path.publish %>'
        ext: '.map'


  tasks =
    css: [
      #'styleguide'
      'less'
      'sass'
      'stylus'
      #'csslint'
      'requirejs:css'
      'csso'
    ]
    html: [
      'jade'
      #'htmllint'
    ]
    js: [
      'coffeelint'
      'jshint'
      #'simplemocha'
      'docco'
      'yuidoc'
      'coffee'
      'requirejs:js'
      'uglify'
    ]
    json: [
      'jsonlint'
    ]
    watch: [
      'livereload-start'
      'connect'
      'regarde'
      'server'
    ]
    build: [
      'clean'
      'reduce'
      'tidy'
    ]
    default: [
      'copy:source'
      'css'
      'html'
      'js'
      'json'
      'copy:intermediate'
    ]


  # Server
  grunt.registerTask 'server', 'Node.js local server', ->
    app = require './srv/src/app'
    app.listen 50000
    grunt.log.writeln 'Express server started'


  # Tidy
  grunt.registerTask 'tidy', 'HTML formatter', ->
    done = @async()

    conf = '.tidyrc'
    targets = [
      path.join 'app', 'reduced', 'index.html'
    ]
    promises = []

    proceed = (target, deferred) ->
      exec "tidy -config #{conf} -modify #{target}", (err) ->
        return deferred.reject(new Error(err)) if err
        deferred.resolve()

    for target in targets
      deferred = q.defer()
      promises.push deferred
      proceed target, deferred

    resolved = q.allResolved promises

    resolved.then (promises) ->
      return done false for promise in promises when not promise.isFulfilled()
      done()


  # Fix source map path
  # https://github.com/gruntjs/grunt-contrib-uglify/issues/39
  grunt.registerMultiTask 'fix_source_maps', 'Fixes uglified source maps', ->
    grunt.verbose.write 'Source maps in fixation process'

    for file in @filess
      src = file.src.filter (filepath) ->
        unless grunt.file.exists filepath
          grunt.log.warn "Source file #{filepath} not found."
          return false
        else
          return true

      json = grunt.file.readJSON src
      new_file_value = json.file.replcae /root\/js\//, ''
      return if new_file_value is json.file
      json.file = new_file_value
      grunt.file.write f.dest, JSON.stringify(json)
      grunt.log.writeln "Source map in #{src} fixed."


  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-contrib-jshint'
  grunt.loadNpmTasks 'grunt-contrib-jst'
  grunt.loadNpmTasks 'grunt-contrib-less'
  grunt.loadNpmTasks 'grunt-contrib-livereload'
  grunt.loadNpmTasks 'grunt-contrib-requirejs'
  grunt.loadNpmTasks 'grunt-contrib-sass'
  grunt.loadNpmTasks 'grunt-contrib-stylus'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-yuidoc'
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-css'
  grunt.loadNpmTasks 'grunt-csso'
  grunt.loadNpmTasks 'grunt-docco'
  grunt.loadNpmTasks 'grunt-html'
  grunt.loadNpmTasks 'grunt-jsonlint'
  grunt.loadNpmTasks 'grunt-markdown'
  grunt.loadNpmTasks 'grunt-reduce'
  grunt.loadNpmTasks 'grunt-regarde'
  grunt.loadNpmTasks 'grunt-styleguide'
  grunt.loadNpmTasks 'grunt-simple-mocha'

  grunt.initConfig conf

  grunt.registerTask 'css', tasks.css
  grunt.registerTask 'html', tasks.html
  grunt.registerTask 'js', tasks.js
  grunt.registerTask 'json', tasks.json
  grunt.registerTask 'watch', tasks.watch
  grunt.registerTask 'build', tasks.build
  grunt.registerTask 'default', tasks.default

'use strict'


fs = require 'fs'

express = require 'express'
socket = require 'socket.io'
spdy = require 'spdy'

{config} = require './config'


options =
  key: fs.readFileSync "#{__dirname}/../pems/spdy-key.pem"
  cert: fs.readFileSync "#{__dirname}/../pems/spdy-cert.pem"
  ca: fs.readFileSync "#{__dirname}/../pems/spdy-csr.pem"
  windowSize: 1024

app = express()
server  = spdy.createServer options, app
io = socket.listen server


app.configure ->
  app.set 'port', config.app_port or 50000
  app.use express.favicon()
  app.use express.bodyParser()
  app.use express.cookieParser(config.session_secret)
  app.use express.methodOverride()
  app.use express.session()
  app.use (req, res, next) ->
    res.my_message = 'Hello, this is just a test :)'
    next()
  app.use app.router
  app.use express.static("#{__dirname}/../app.built")

app.configure 'development', ->
  app.use express.logger('dev')
  app.use express.errorHandler { dumpExceptions: true, showStack: true }

app.all '/basicauth', express.basicAuth (username, password) ->
  'test' is username and 'password' is password

app.get '/test', (req, res) ->
  resp =
    status: 'TEST'
    message: res.my_message
  res.send resp

app.get '/basicauth', (req, res) ->
  resp =
    status: 'BASIC_AUTH'
    message: res.my_message
  res.send resp


###
io.sockets.on 'connection', (sock) ->
  sock.on 'event', (data) ->
    console.log 'Event fired.'

  sock.on 'disconnect', ->
    console.log 'Disconnected'


server.listen app.get('port')
###

module.exports = server

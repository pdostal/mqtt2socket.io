moment = require 'moment'
express = require 'express'
app = express()
http = require('http').Server app
io = require('socket.io') http

app.use express.static 'public'

app.get '/', (req, res) ->
  res.render 'index.ejs'
  console.log moment().format('hh:mm:ss') + ' get / served'

http.listen 3000, ->
  console.log moment().format('hh:mm:ss') + ' server started'

io.on 'connection', (socket) ->
  console.log moment().format('hh:mm:ss') + ' client connected'
  
  socket.on 'disconnect', ->
    console.log moment().format('hh:mm:ss') + ' client disconnected'


moment = require 'moment'
express = require 'express'
app = express()
http = require('http').Server app
io = require('socket.io') http

app.use express.static 'public'

Mqtt = require 'mqtt'
mqtt = Mqtt.connect { host: 'iot.siliconhill.cz', port: 1883, protocolId: 'MQIsdp', protocolVersion: 3 }

mqtt.on 'connect', ->
  mqtt.subscribe '/#'

mqtt.on 'message', (topic, message) ->
  console.log moment.utc().format() + ' ' + topic.toString() + ' ' + message.toString()
  io.emit 'mqtt', { 'timestamp': moment.utc().format(), 'topic': topic.toString(), 'message': message.toString() }

app.get '/', (req, res) ->
  res.render 'index.ejs'
  console.log moment.utc().format() + ' get / served'

http.listen 3000, ->
  console.log moment.utc().format() + ' server started'

io.on 'connection', (socket) ->
  console.log moment.utc().format() + ' client connected'
  
  socket.on 'disconnect', ->
    console.log moment.utc().format() + ' client disconnected'


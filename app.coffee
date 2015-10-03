moment = require 'moment'
express = require 'express'
app = express()
http = require('http').Server app
io = require('socket.io') http

app.use express.static 'public'

Redis = require 'redis'
redis = Redis.createClient()

redis.on 'connect', () ->
  console.log moment.utc().format() + ' redis connected'

Mqtt = require 'mqtt'
mqtt = Mqtt.connect { host: 'iot.siliconhill.cz', port: 1883, protocolId: 'MQIsdp', protocolVersion: 3 }

mqtt.on 'connect', ->
  mqtt.subscribe '/#'
  console.log moment.utc().format() + ' mqtt connected'

mqtt.on 'message', (topic, message) ->
  console.log moment.utc().format() + ' ' + topic.toString() + ' ' + message.toString()
  send = { 'timestamp': moment.utc().format(), 'topic': topic.toString(), 'message': message.toString() }
  io.emit 'mqtt', send
  redis.hmset 'mqtt:'+topic, send, (err, reply) ->

app.get '/', (req, res) ->
  res.render 'index.ejs'
  console.log moment.utc().format() + ' get / served'

http.listen 3000, ->
  console.log moment.utc().format() + ' server started'

io.on 'connection', (socket) ->
  console.log moment.utc().format() + ' client connected'

  redis.keys 'mqtt:/*', (err, keys) ->
    for key in keys
      redis.hgetall key, (err, reply) ->
        io.emit 'mqtt', { 'timestamp': moment.utc().format(), 'topic': reply.topic, 'message': reply.message }

  socket.on 'disconnect', ->
    console.log moment.utc().format() + ' client disconnected'

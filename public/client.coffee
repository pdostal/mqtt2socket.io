(($) ->
  $ ->
    console.log 'DOM is ready'

  socketio = io()

  socketio.on 'connection', (socket) ->
    console.log 'socket is ready'

  socketio.on 'mqtt', (message) ->
    text = "<li>"
    text += "<span class='timestamp'>" + message.timestamp + "</span>"
    text += "<span class='topic'>" + message.topic + "</span>"
    text += "<span class='message'>" + message.message + "</span>"
    text += "</li>"
    li = $('#mqtt').append text

) jQuery


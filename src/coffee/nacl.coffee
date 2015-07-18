module.exports = (id, url)->
  # module object
  module = 
    _ready: false

  # nacl embed object
  embed = document.createElement 'embed'
  embed.setAttribute 'id', id
  embed.setAttribute 'width', 0
  embed.setAttribute 'height', 0
  embed.setAttribute 'src', url
  embed.setAttribute 'type', 'application/x-pnacl'

  # callback
  session = (arg)->
    if arg is 
      registry[id] = 
  session = {}
  session_serial = 0
  session_get_serial = ()->
    session_serial += 1
    return session_serial
  log = (message)->
    console.log "nacl: ##{id}: #{message}"

  # event lisnter wrapper
  listener = document.createElement 'div'
  listener.addEventListener 'load', ((event)->
    log "loaded"
    register = (methods)->
      for id, type of methods
        module[id] = (args=[], callback=null)->
          embed.postMessage
            serial: session(callback)
            method: name
            arguments: args
      module._ready = true
      console.log module
      null # no reture value
    embed.postMessage
      serial: session(register)
      method: '_interface'
      arguments: []
    null # no reture value
  ), true
  listener.addEventListener 'message', ((event)->
    console.log event.data
    serial = event.data.serial
    session(serial) event.data.results
    null # no reture value
  ), true
  ###
  listener.addEventListener 'error', ((event)->
    log embed.lastError
    null # no reture value
  ), true
  listener.addEventListener 'crash', ((event)->
    log if embed.exitStatus == -1 then "crashed" 
    else "exited with code #{embed.exitStatus}"
    null # no reture value
  ), true
  ###

  document.body.appendChild listener
  listener.appendChild embed
    
  return module

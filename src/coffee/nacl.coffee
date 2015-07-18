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
  session = 
    serial: 0
    registry: {}
    create: (callback)->
      id = "#{@serial}"
      @serial += 1
      @registry[id] = callback
      return id
    release: (id)->
      callback = @registry[id]
      delete @registry[id]
      return callback
  noop = ()->
  log = (message)->
    console.log "nacl: ##{id}: #{message}"

  # event lisnter wrapper
  listener = document.createElement 'div'
  listener.addEventListener 'load', ((event)->
    log "loaded"
    register = (methods)->
      for id, type of methods
        module[id] = (args=[], callback=()->)->
          embed.postMessage
            serial: session.create(callback)
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
    session.release(serial) event.data.results
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

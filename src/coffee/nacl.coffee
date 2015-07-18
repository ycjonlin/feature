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
    create: (method, args, callback)->
      id = "#{@serial}"
      @serial += 1
      @registry[id] = callback
      console.log id, @serial
      embed.postMessage
        id: id
        method: method
        arguments: args
    release: (id)->
      callback = @registry[id]
      delete @registry[id]
      return callback
  log = (message)->
    console.log "nacl: ##{id}: #{message}"

  # event lisnter wrapper
  listener = document.createElement 'div'
  listener.addEventListener 'load', ((event)->
    log "loaded"
    register = (methods)->
      for method, type of methods
        module[method] = (args=[], callback=null)->
          session.create(method, args, callback)
      module._ready = true
      console.log module
      null # no reture value
    session.create('_interface', [], register)
    null # no reture value
  ), true
  listener.addEventListener 'message', ((event)->
    callback = session.release(event.data.id)
    if callback
      callback event.data.results
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

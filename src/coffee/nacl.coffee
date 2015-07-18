module.exports = (id, url, onload)->
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
    create: (method, args=[], callback=null)->
      id = "#{@serial}"
      @serial += 1
      @registry[id] = callback
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
    register = (methods)->
      for method, type of methods
        module[method] = session.create.bind session, method
      module._ready = true
      if onload
        onload()
      null # no reture value
    session.create('_interface', [], register)
    null # no reture value
  ), true
  listener.addEventListener 'message', ((event)->
    callback = session.release(event.data.id)
    if event.data.id == '1'
      console.log new Float32Array(event.data.arguments[0])
    if callback
      callback event.data.results
    null # no reture value
  ), true

  document.body.appendChild listener
  listener.appendChild embed
    
  return module

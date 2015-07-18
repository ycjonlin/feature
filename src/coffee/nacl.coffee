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

  log = (message)->
    console.log "nacl: ##{id}: #{message}"

  # event lisnter wrapper
  listener = document.createElement 'div'
  listener.addEventListener 'load', ((event)->
    log "loaded"
    embed.postMessage
      method: '_interface'
      callback: (methods)->
        for id, type of methods
          module[id] = (args=[], callback=null)->
            embed.postMessage
              method: name
              arguments: args
              results: null
              callback: callback
        module._ready = true
        console.log module
        null # no reture value
    null # no reture value
  ), true
  listener.addEventListener 'message', ((event)->
    console.log event.data
    event.data.callback.apply null, event.data.results
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

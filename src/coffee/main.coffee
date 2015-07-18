console.log 'foobar'

# NaCl

NaCl = (id, url)->
  # module object
  module = 
    _ready: false

  # nacl embed object
  embed = document.createElement 'embed'
  embed.setAttribute 'id', @id
  embed.setAttribute 'width', 0
  embed.setAttribute 'height', 0
  embed.setAttribute 'path', "#{path}/#{name}.nmf"
  embed.setAttribute 'src', @url
  embed.setAttribute 'type', 'application/x-pnacl'

  # event lisnter wrapper
  listener = document.createElement 'div'
  listener.appendChild embed

  log = (message)->
    console.log "##{id}: #{message}"

  # add event listener functions
  listener.addEventListener 'load', ((event)->
    log "loaded"
    embed.postMessage
      method: '_get_methods'
      callback: (methods)->
        for id, type of methods
          module[id] = (args=[], callback=null)->
            embed.postMessage
              method: name
              arguments: args
              results: null
              callback: callback
        module._ready = true
        null # no reture value
  ), true
  listener.addEventListener 'message', ((event)->
    event.data.callback.apply null, event.data.results
  ), true
  listener.addEventListener 'error', ((event)->
    log @listener.lastError
  ), true
  listener.addEventListener 'crash', ((event)->
    log if @embed.exitStatus == -1 then "crashed" 
    else "exited with code #{@embed.exitStatus}"
  ), true

  document.appendChild listener
    
  return module
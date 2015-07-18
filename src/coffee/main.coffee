console.log 'foobar'

# NaCl

NaCl = (id, url)->
  embed = document.createElement 'embed'
  embed.setAttribute 'id', @id
  embed.setAttribute 'width', 0
  embed.setAttribute 'height', 0
  embed.setAttribute 'path', "#{path}/#{name}.nmf"
  embed.setAttribute 'src', @url
  embed.setAttribute 'type', 'application/x-pnacl'

  log = (message)->
    console.log "##{id}: #{message}"

  listener = document.createElement 'div'
  listener.addEventListener 'load', ((event)->
    log "loaded"
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
  listener.appendChild embed

  document.appendChild listener
    

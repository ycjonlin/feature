console.log 'foobar'

# NaCl
class NaCl
  constructor: (@id, @path, @name)->
    embed = document.createElement 'embed'
    embed.setAttribute 'id', @id
    embed.setAttribute 'width', 0
    embed.setAttribute 'height', 0
    embed.setAttribute 'path', "#{path}/#{name}.nmf"
    embed.setAttribute 'src', @path
    embed.setAttribute 'type', 'application/x-pnacl'

    listener = document.createElement 'div'
    listener.appendChild embed

    document.appendChild listener

  manifest: ()->  
    'program':
      'portable':
        'pnacl-translate':
          'url': @url
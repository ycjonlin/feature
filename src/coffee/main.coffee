console.log 'foobar'

# NaCl
class NaCl
  constructor: (@url)->
    div = document.createElement 'DIV'
    embed = document.createElement 'EMBED'

  manifest: ()->  
    'program':
      'portable':
        'pnacl-translate':
          'url': @url
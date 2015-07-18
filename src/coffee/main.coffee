console.log 'foobar'

# NaCl
class NaCl
  constructor: (@url)->
    
  manifest: ()->  
    'program':
      'portable':
        'pnacl-translate':
          'url': @url
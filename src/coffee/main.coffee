feature = require('./nacl') 'feature', 'nacl/feature.nmf', (data)->
  log = (data)-> console.log data
  log data
  feature.image_import ['http://localhost:9001/images/505494059_ed850a8b0a_o.jpg'], log


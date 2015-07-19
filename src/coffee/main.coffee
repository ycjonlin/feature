feature = require('./nacl') 'feature', 'nacl/feature.nmf', (data)->
  log = (data)-> console.log data
  log data
  feature.image_import ['https://farm1.staticflickr.com/194/505494059_ed850a8b0a_o_d.jpg'], log
  feature.image_import ['https://cdnjs.cloudflare.com/ajax/libs/jade/1.11.0/jade.min.js'], log
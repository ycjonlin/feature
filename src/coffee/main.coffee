feature = require('./nacl') 'feature', 'nacl/feature.nmf', (data)->
  log = (data)-> console.log data
  log data
  feature.image_import ['https://farm10.staticflickr.com/194/505494059_ed850a8b0a_o_d.jpg'], log
  feature.image_import ['https://farm10.staticflickr.com/16/20983487_1d88ca94e7_o_d.jpg'], log


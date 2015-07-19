feature = require('./nacl') 'feature', 'nacl/feature.nmf', (data)->
  log = (data)-> console.log data
  log data
  feature.image_import ['https://farm1.staticflickr.com/16/20983487_1d88ca94e7_o_d.jpg'], log

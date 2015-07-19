feature = require('./nacl') 'feature', 'nacl/feature.nmf', (data)->
  console.log data
  #feature.image_import ['flickr', '194/505494059_ed850a8b0a_o_d.jpg'], (data)->
  feature.image_import ['cdnjs', 'jade/1.11.0/jade.min.js'], (data)->
  	console.log data
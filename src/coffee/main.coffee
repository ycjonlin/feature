feature = require('./nacl') 'feature', 'nacl/feature.nmf', (data)->
  console.log feature
  feature.image_import ['flickr', '194/505494059_ed850a8b0a_o_d.jpg'], (data)->
  	console.log data
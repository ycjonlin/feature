feature = require('./nacl') 'feature', 'nacl/feature.nmf', (data)->
  console.log data
  url = 'https://farm1.staticflickr.com/194/505494059_ed850a8b0a_o_d.jpg'
  feature.image_import [url], (image)->
    feature.split_cie_xyz [url], (array)->
      feature.calculus_convolute [array], (array_u)->
        feature.calculus_convolute [array_u], (array_uv)->
          feature.merge_cie_xyz [url], (data)->



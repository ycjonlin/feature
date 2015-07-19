feature = require('./nacl') 'feature', 'nacl/feature.nmf', (data)->
  console.log data
  url = 'https://farm1.staticflickr.com/194/505494059_ed850a8b0a_o_d.jpg'
  feature.image_import [url], (data)->
    console.log data
    feature.split_cie_xyz, [url], (data)->
      console.log data
      feature.calculus_convolute, [url], (data)->
        console.log data
        feature.calculus_convolute, [url], (data)->
          console.log data
          feature.merge_cie_xyz, [url], (data)->
            console.log data



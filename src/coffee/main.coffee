sigma = 2
kernel = new Float32Array(Math.ceil(sigma*8)|1)
radius = (kernel.length-1)/2
for i in [0..kernel.length-1]
  x = (i-radius)/sigma
  kernel[i] = Math.exp(-x*x/2)

feature = require('./nacl') 'feature', 'nacl/feature.nmf', (data)->
  url = 'https://farm1.staticflickr.com/194/505494059_ed850a8b0a_o_d.jpg'
  feature.image_import [url], (image)->
    feature.split_cie_xyz [url], (array)->
      args = [array, kernel, image.height*2, image.width*2, image.width*2, 1, kernel.length, 1]
      feature.calculus_convolute args, (array_u)->
        args = [array_u, kernel, image.height*2, image.width*2, image.width*2, 1, kernel.length, image.width*2]
        feature.calculus_convolute args, (array_uv)->
          feature.merge_cie_xyz [url], (data)->



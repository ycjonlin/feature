###
sigma = 2
kernel = new Float32Array(Math.ceil(sigma*8)|1)
radius = (kernel.length-1)/2
for i in [0..kernel.length-1]
  x = (i-radius)/sigma
  kernel[i] = Math.exp(-x*x/2)

feature = require('./nacl') 'feature', 'nacl/feature.nmf', (data)->
  url = 'https://farm1.staticflickr.com/194/505494059_ed850a8b0a_o_d.jpg'
  feature.image_import [url], (image)->
    feature.split_cie_xyz [url], (raw)->
      feature.image_export [raw, image.width, image.height], (data)->
        canvas = document.createElement "canvas"
        canvas.width = image.width
        canvas.height = image.height

        context = canvas.getContext "2d"
        imageData = context.createImageData image.width, image.height
        pixel = imageData.data
        for i in [0..data.length-1]
          pixel[i] = data[i]
        context.putImageData(imageData, 0, 0)

        document.appendChild(canvas)

      args = [array, kernel, image.height*2, image.width*2, image.width*2, 1, kernel.length, 1]
      feature.calculus_convolute args, (array_u)->
        args = [array_u, kernel, image.height*2, image.width*2, image.width*2, 1, kernel.length, image.width*2]
        feature.calculus_convolute args, (array_uv)->
###

image_load = (url, callback)->
  image = new Image
  image.crossOrigin = "Anonymous"
  image.onload = (event)->
    canvas = document.createElement("canvas")
    canvas.width = image.width
    canvas.height = image.height
    context = canvas.getContext "2d"
    context.drawImage image, 0, 0
    imageData = context.getImageData 0, 0, image.width, image.height
    callback imageData
    null
  image.src = url
  null

converge = (oppum, opend, offset0, offset1, offset2, i_count, i_step, j_count, j_step)->
  i_count = i_count|0; i_step = i_step|0
  j_count = j_count|0; j_step = j_step|0
  _ = 0
  i = 0; I = 0
  while i < i_count
    j = 0; J = I
    while j < j_count
      channel0 = opend[offset0+J|0]
      channel1 = opend[offset1+J|0]
      channel2 = opend[offset2+J|0]
      oppum[_] = channel0*255|0; _ = _+1|0
      oppum[_] = channel1*255|0; _ = _+1|0
      oppum[_] = channel2*255|0; _ = _+1|0
      oppum[_] = 255; _ = _+1|0
      j = (j+1)|0; J = (J+j_step)|0
    i = (i+1)|0; I = (I+i_step)|0
  null

diverge = (oppum, opend, offset0, offset1, offset2, i_count, i_step, j_count, j_step)->
  i_count = i_count|0; i_step = i_step|0
  j_count = j_count|0; j_step = j_step|0
  _ = 0
  i = 0; I = 0
  while i < i_count
    j = 0; J = I
    while j < j_count
      channel0 = +opend[_]/+255; _ = _+1|0
      channel1 = +opend[_]/+255; _ = _+1|0
      channel2 = +opend[_]/+255; _ = _+1|0
      _ = _+1|0
      oppum[offset0+J|0] = channel0
      oppum[offset1+J|0] = channel1
      oppum[offset2+J|0] = channel2
      j = (j+1)|0; J = (J+j_step)|0
    i = (i+1)|0; I = (I+i_step)|0
  null

image_split = (image)->
  array = new Float32Array(image.width*image.height*4)
  width = image.width
  height = image.height
  size = width * height
  diverge array, image.data, 
    width, size*2, width+size*2, 
    height, width*2, width, 1
  array


image_merge = (array, context, width, height)->
  image = context.createImageData width, height
  size = width * height
  converge image.data, array, 
    width, size*2, width+size*2, 
    height, width*2, width, 1
  image

array_convolute = (opend, oppor, i_count, i_step, j_count, j_step, k_count, k_step)->
  oppum = new Float32Array(opend.length)
  i_count = i_count|0; i_step = i_step|0
  j_count = j_count|0; j_step = j_step|0
  k_count = k_count|0; k_step = k_step|0
  i = 0; I = 0
  while i < i_count
    j = 0; J = I
    while j < j_count
      sum = +0.0
      k = 0; K = J
      while k < k_count
        sum = +sum + +opend[K] * +oppor[k]
        k = (k+1)|0; K = (K+k_step)|0
      oppum[J] = sum
      j = (j+1)|0; J = (J+j_step)|0
    i = (i+1)|0; I = (I+i_step)|0


(()->

  image_load 'https://farm1.staticflickr.com/194/505494059_426290217e.jpg', (imageData)->

    sigma = 4
    kernel = new Float32Array(sigma*8|1)
    radius = (kernel.length-1)/2
    for i in [0..kernel.length-1]
      x = (i-radius)/sigma
      kernel[i] = Math.exp(-x*x/2)

    width = imageData.width
    height = imageData.height
    length = kernel.length

    array0 = image_split imageData
    array1 = array_convolute array0, kernel, height*2, width*2, width*2, 1, length, 1
    array2 = array_convolute array1, kernel, height*2, width*2, width*2, 1, length, width*2
    array = array2

    # create image
    canvas = document.createElement("canvas")
    context = canvas.getContext("2d")
    newImageData = image_merge array, context, width, height
    canvas.width = width
    canvas.height = height
    context.putImageData newImageData, 0, 0

    # append to document
    div = document.createElement("div")
    div.className = "slide"
    document.body.appendChild div
    div.appendChild canvas
)()

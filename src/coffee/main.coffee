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

convolute = (oppum, opend, oppor, i_count, i_step, j_count, j_step, k_count, k_step)->
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

    sigma = 1
    length = sigma*8|1
    radius = (length-1)/2
    kernel0 = new Float32Array(length)
    kernel1 = new Float32Array(length)
    kernel2 = new Float32Array(length)
    constant = 1/Math.sqrt(Math.PI*2)/sigma
    for i in [0..length-1]
      x = (i-radius)/sigma
      y = Math.exp(-x*x/2)*constant
      kernel0[i] = y
      kernel1[i] = -x*y
      kernel2[i] = (x*x-1)*y
    console.log kernel0
    console.log kernel1
    console.log kernel2
    return

    width = imageData.width
    height = imageData.height

    array = image_split imageData
    array0 = new Float32Array(array.length)
    array1 = new Float32Array(array.length)
    array2 = new Float32Array(array.length)
    array00 = new Float32Array(array.length)
    array10 = new Float32Array(array.length)
    array20 = new Float32Array(array.length)
    array01 = new Float32Array(array.length)
    array11 = new Float32Array(array.length)
    array02 = new Float32Array(array.length)

    convolute array0, array, kernel0, height*2, width*2, width*2, 1, length, width*2
    convolute array1, array, kernel1, height*2, width*2, width*2, 1, length, width*2
    convolute array2, array, kernel2, height*2, width*2, width*2, 1, length, width*2

    convolute array00, array0, kernel0, height*2, width*2, width*2, 1, length, 1
    convolute array10, array0, kernel1, height*2, width*2, width*2, 1, length, 1
    convolute array20, array0, kernel2, height*2, width*2, width*2, 1, length, 1
    convolute array01, array1, kernel0, height*2, width*2, width*2, 1, length, 1
    convolute array11, array1, kernel1, height*2, width*2, width*2, 1, length, 1
    convolute array02, array2, kernel0, height*2, width*2, width*2, 1, length, 1

    # create image
    canvas = document.createElement("canvas")
    context = canvas.getContext("2d")
    newImageData = image_merge array11, context, width, height
    canvas.width = width
    canvas.height = height
    context.putImageData newImageData, 0, 0

    # append to document
    div = document.createElement("div")
    div.className = "slide"
    document.body.appendChild div
    div.appendChild canvas
)()

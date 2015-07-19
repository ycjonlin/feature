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

image_element = (array, width, height)->
    canvas = document.createElement("canvas")
    context = canvas.getContext("2d")
    imageData = image_merge array, context, width, height
    canvas.width = width
    canvas.height = height
    context.putImageData imageData, 0, 0
    canvas

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
  i_count = i_count-k_count+1|0; i_step = i_step|0
  j_count = j_count-k_count+1|0; j_step = j_step|0
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

matrixTrace = (oppum, opend, i_count, i_step, j_count, j_step)->
  i_count = i_count|0; i_step = i_step|0
  j_count = j_count|0; j_step = j_step|0
  k_count = k_count|0; k_step = k_step|0
  i = 0; I = 0
  while i < i_count
    j = 0; J = I
    while j < j_count
      xx = +opend[J-j_step|0] - +opend[J] * +2 + +opend[J+j_step|0]
      yy = +opend[J-i_step|0] - +opend[J] * +2 + +opend[J+i_step|0]
      oppum[J] = xx+yy
      j = (j+1)|0; J = (J+j_step)|0
    i = (i+1)|0; I = (I+i_step)|0

matrixDeterminant = (oppum, opend, i_count, i_step, j_count, j_step)->
  i_count = i_count|0; i_step = i_step|0
  j_count = j_count|0; j_step = j_step|0
  k_count = k_count|0; k_step = k_step|0
  i = 0; I = 0
  while i < i_count
    j = 0; J = I
    while j < j_count
      xx = +opend[J-j_step|0] - +opend[J] * +2 + +opend[J+j_step|0]
      yy = +opend[J-i_step|0] - +opend[J] * +2 + +opend[J+i_step|0]
      xy = +0.25*(
        +opend[J-i_step-j_step|0] -
        +opend[J+i_step-j_step|0] -
        +opend[J-i_step+j_step|0] +
        +opend[J+i_step+j_step|0])
      oppum[J] = +xx * +yy + +xy * +xy
      j = (j+1)|0; J = (J+j_step)|0
    i = (i+1)|0; I = (I+i_step)|0


(()->

  image_load 'https://farm1.staticflickr.com/194/505494059_426290217e.jpg', (imageData)->

    sigma = 4
    length = sigma*6|1
    radius = (length-1)/2
    kernel = new Float32Array(length)
    constant = 1/Math.sqrt(Math.PI*2)/sigma
    for i in [0..length-1]
      x = (i-radius)/sigma
      y = Math.exp(-x*x/2)*constant
      kernel[i] = y

    width = imageData.width
    height = imageData.height

    array0 = image_split imageData
    array1 = new Float32Array(array0.length)

    convolute array1, array0, kernel, height*2, width*2, width*2, 1, length, width*2
    convolute array0, array1, kernel, height*2, width*2, width*2, 1, length, 1


    div = document.createElement("div")
    div.className = "slide"
    document.body.appendChild div

    matrixTrace array1, array0, height*2, width*2, width*2, 1
    div.appendChild image_element(array1, width, height)
)()

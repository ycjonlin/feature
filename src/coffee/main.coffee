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
      oppum[J] = +0.5 + +1e0 * (+xx + +yy)
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
      oppum[J] = +0.5 + +1e4 * (+xx * +yy - +xy * +xy)
      j = (j+1)|0; J = (J+j_step)|0
    i = (i+1)|0; I = (I+i_step)|0

matrixGaussian = (oppum, opend, i_count, i_step, j_count, j_step)->
  i_count = i_count|0; i_step = i_step|0
  j_count = j_count|0; j_step = j_step|0
  k_count = k_count|0; k_step = k_step|0
  i = 0; I = 0
  while i < i_count
    j = 0; J = I
    while j < j_count
      _ = +opend[J]
      _j = +0.5 * (+opend[J+j_step|0] - +opend[J-j_step|0])
      _i = +0.5 * (+opend[J+i_step|0] - +opend[J-i_step|0])
      _jj = +opend[J-j_step|0] - _ * +2 + +opend[J+j_step|0]
      _ii = +opend[J-i_step|0] - _ * +2 + +opend[J+i_step|0]
      _ij = +0.25 * (
        +opend[J+i_step+j_step|0] -
        +opend[J-i_step+j_step|0] -
        +opend[J+i_step-j_step|0] +
        +opend[J-i_step-j_step|0])
      norm = +_ * +_
      _uu = (+_ii * +_ - +_i * +_i) / +norm
      _vv = (+_jj * +_ - +_j * +_j) / +norm
      _uv = (+_ij * +_ - +_i * +_j) / +norm
      oppum[J] = +0.5 + +1e3 * (+_uu * +_vv - +_uv * +_uv)
      j = (j+1)|0; J = (J+j_step)|0
    i = (i+1)|0; I = (I+i_step)|0


gaussian = (sigma)->
  length = Math.ceil(sigma*6)|1
  radius = (length-1)/2
  kernel = new Float32Array(length)
  constant = 1/Math.sqrt(Math.PI*2)
  for i in [0..length-1]
    x = (i-radius)/sigma
    y = Math.exp(-x*x/2)*constant
    kernel[i] = y
  kernel

(()->

  image_load 'https://farm1.staticflickr.com/194/505494059_426290217e.jpg', (imageData)->

    width = imageData.width
    height = imageData.height

    array = image_split imageData
    array0 = new Float32Array(array.length)
    array1 = new Float32Array(array.length)

    div = document.createElement("div")
    div.className = "slide"
    document.body.appendChild div
    div.appendChild image_element(array, width, height)

    n = 2
    for i in [0..n]
      kernel = gaussian(2*Math.sqrt(1+3*i/n))
      console.log kernel.length

      convolute array1, array, kernel, height*2, width*2, width*2, 1, kernel.length, width*2
      convolute array0, array1, kernel, height*2, width*2, width*2, 1, kernel.length, 1

      matrixTrace array1, array0, height*2, width*2, width*2, 1
      div.appendChild image_element(array1, width, height)
      ###
      matrixDeterminant array1, array0, height*2, width*2, width*2, 1
      div.appendChild image_element(array1, width, height)

      matrixGaussian array1, array0, height*2, width*2, width*2, 1
      div.appendChild image_element(array1, width, height)
      ###
)()

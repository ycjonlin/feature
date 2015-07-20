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
  offset = (k_count>>1)*k_step|0
  i = 0; I = offset
  while i < i_count
    j = 0; J = I
    while j < j_count
      sum = +0.0
      k = 0; K = J-offset|0
      while k < k_count
        sum = +sum + +opend[K] * +oppor[k]
        k = (k+1)|0; K = (K+k_step)|0
      oppum[J] = sum
      j = (j+1)|0; J = (J+j_step)|0
    i = (i+1)|0; I = (I+i_step)|0

fround = Math.fround
measure = (blr, trc, det, gau, opend, sigma, i_count, i_step, j_count, j_step)->
  i_count = i_count|0; i_step = i_step|0
  j_count = j_count|0; j_step = j_step|0
  k_count = k_count|0; k_step = k_step|0
  i = 0; I = 0
  s1_2 = fround(sigma/2)
  s2_1 = fround(sigma*sigma)
  s2_4 = fround(sigma*sigma/4)
  while i < i_count
    j = 0; J = I
    while j < j_count

      _   = opend[J]
      _j  = fround(s1_2 * (opend[J+j_step] - opend[J-j_step]))
      _i  = fround(s1_2 * (opend[J+i_step] - opend[J-i_step]))
      _jj = fround(s2_1 * (opend[J-j_step] - _ - _ + opend[J+j_step]))
      _ii = fround(s2_1 * (opend[J-i_step] - _ - _ + opend[J+i_step]))
      _ij = fround(s2_4 * (
        opend[J+i_step+j_step] -
        opend[J-i_step+j_step] -
        opend[J+i_step-j_step] +
        opend[J-i_step-j_step]))

      norm = fround(1 / (_ * _))
      _uu = fround((_ii * _ - _i * _i) * norm)
      _vv = fround((_jj * _ - _j * _j) * norm)
      _uv = fround((_ij * _ - _i * _j) * norm)

      blr[J] = _
      trc[J] = 0.5 + 1e0 * (_ii + _jj)
      det[J] = 0.5 + 1e2 * (_ii * _jj - _ij * _ij)
      gau[J] = 0.5 + 1e1 * (_uu * _vv - _uv * _uv)

      j = (j+1)|0; J = (J+j_step)|0
    i = (i+1)|0; I = (I+i_step)|0

erf = (x)->
  t = 1/(1+0.3275911*Math.abs(x))
  y = 1-((((1.061405429*t-1.453152027)*t+1.421413741)*t-0.284496736)*t+0.254829592)*t*Math.exp(-x*x)
  if x > 0 then y else -y

gaussian = (sigma)->
  length = Math.ceil(sigma*6)|1
  radius = length/2
  kernel = new Float32Array(length)
  constant = 1/Math.sqrt(Math.PI*2)/sigma
  for i in [0..length-1]
    x0 = (i-radius)/sigma/Math.sqrt(2)
    x1 = (i+1-radius)/sigma/Math.sqrt(2)
    y = (erf(x1)-erf(x0))/2
    kernel[i] = y
  kernel

(()->

  image_load 'https://farm1.staticflickr.com/194/505494059_426290217e.jpg', (imageData)->

    width = imageData.width
    height = imageData.height

    array = image_split imageData
    array0 = new Float32Array(array.length)
    array1 = new Float32Array(array.length)
    array2 = new Float32Array(array.length)
    array3 = new Float32Array(array.length)
    array4 = new Float32Array(array.length)

    divBlur = document.createElement("div")
    divBlur.className = "slide"
    document.body.appendChild divBlur
    divBlur.appendChild image_element(array, width, height)

    divTrace = document.createElement("div")
    divTrace.className = "slide"
    document.body.appendChild divTrace
    divTrace.appendChild image_element(array, width, height)

    divDeterminant = document.createElement("div")
    divDeterminant.className = "slide"
    document.body.appendChild divDeterminant
    divDeterminant.appendChild image_element(array, width, height)

    divGaussian = document.createElement("div")
    divGaussian.className = "slide"
    document.body.appendChild divGaussian
    divGaussian.appendChild image_element(array, width, height)

    n = 4
    for i in [0..n]
      sigma = 2*Math.sqrt(1+3*i/n)
      kernel = gaussian(2*Math.sqrt(1+3*i/n))

      convolute array1, array, kernel, height*2, width*2, width*2, 1, kernel.length, width*2
      convolute array0, array1, kernel, height*2, width*2, width*2, 1, kernel.length, 1

      measure array1, array2, array3, array4, array0, sigma, height*2, width*2, width*2, 1
      divBlur.appendChild image_element(array1, width, height)
      divTrace.appendChild image_element(array2, width, height)
      divDeterminant.appendChild image_element(array3, width, height)
      divGaussian.appendChild image_element(array4, width, height)
)()

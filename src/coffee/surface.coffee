# Surface library provides basic functions that manipulate Float32Array objects.
# All functions are written in a index-free fashion.

fround = Math.fround
pow = Math.pow

linearToCurve = new Float32Array(256)
for i in [0..255]
  c = i/255
  linearToCurve[i] = if c > 0.04045 then pow((c+0.055)/1.055, 2.4) else c/12.92

module.exports =

  # extract
  # --
  # Convert a 3-componented Uint8Array object into a 1-componented Float32Array object.
  # The result object contains 4 sub-planes, which are filled with 0s, red-, green-, and 
  # blue-channel data of the original object, respectively.

  extract: (oppum, opend, offset0, offset1, offset2, i_count, i_step, j_count, j_step)->
    i_count = i_count|0; i_step = i_step|0
    j_count = j_count|0; j_step = j_step|0
    _ = 0
    i = 0; I = 0
    while i < i_count
      j = 0; J = I
      while j < j_count
        channel0 = linearToCurve[opend[_]]; _ = _+1|0
        channel1 = linearToCurve[opend[_]]; _ = _+1|0
        channel2 = linearToCurve[opend[_]]; _ = _+1|0
        _ = _+1|0
        oppum[offset0+J|0] = fround(0.4124*channel0+0.3576*channel1+0.1805*channel2)
        oppum[offset1+J|0] = fround(0.2126*channel0+0.7152*channel1+0.0722*channel2)
        oppum[offset2+J|0] = fround(0.0193*channel0+0.1192*channel1+0.9505*channel2)

        j = (j+1)|0; J = (J+j_step)|0
      i = (i+1)|0; I = (I+i_step)|0
    null

  
  # compact
  # --
  # Convert a 1-componented Float32Array object into a 3-componented Uint8Array object.
  # It's basically the opposite of Surface.extract(). Only the last 3 sub-planes of the argument object
  # is filled in the red-, green-, blue-channel of the result object.

  compact: (oppum, opend, offset0, offset1, offset2, i_count, i_step, j_count, j_step)->
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
        value0 = fround(+3.2406*channel0-1.5372*channel1-0.4986*channel2)
        value1 = fround(-0.9689*channel0+1.8758*channel1+0.0415*channel2)
        value2 = fround(+0.0557*channel0-0.2040*channel1+1.0570*channel2)
        value0 = if value0 > 0.0031308 then fround(1.055*pow(value0, 1/2.4)) else fround(12.92*value0)
        value1 = if value1 > 0.0031308 then fround(1.055*pow(value1, 1/2.4)) else fround(12.92*value1)
        value2 = if value2 > 0.0031308 then fround(1.055*pow(value2, 1/2.4)) else fround(12.92*value2)
        oppum[_] = (value0*255)|0; _ = _+1|0
        oppum[_] = (value1*255)|0; _ = _+1|0
        oppum[_] = (value2*255)|0; _ = _+1|0
        oppum[_] = 255; _ = _+1|0
        j = (j+1)|0; J = (J+j_step)|0
      i = (i+1)|0; I = (I+i_step)|0
    null

  
  # flatten
  # --
  # Convert a 1-componented Float32Array object into a 3-componented Uint8Array object.
  # The single-channeled data of the original object is copyed into all 3 channels of the result object, 
  # creating a grayscale complete image.

  flatten: (oppum, opend, i_count, i_step, j_count, j_step)->
    i_count = i_count|0; i_step = i_step|0
    j_count = j_count|0; j_step = j_step|0
    _ = 0
    i = 0; I = 0
    while i < i_count
      j = 0; J = I
      while j < j_count
        channel = opend[J]
        channel = if channel > 0.0031308 then fround(1.055*pow(channel, 1/2.4)) else fround(12.92*channel)
        oppum[_] = (channel*255)|0; _ = _+1|0
        oppum[_] = (channel*255)|0; _ = _+1|0
        oppum[_] = (channel*255)|0; _ = _+1|0
        oppum[_] = 255; _ = _+1|0
        j = (j+1)|0; J = (J+j_step)|0
      i = (i+1)|0; I = (I+i_step)|0
    null
  
  # downsize
  # --
  # Shrink the last 3 sub-places of a 1-componented Float32Array object 
  # onto the first sub-plane of another Float32Array object (could also be the same one).

  downsize: (oppum, opend, i_count, i_step, j_count, j_step)->
    i_count = i_count|0; i_step = i_step|0
    j_count = j_count|0; j_step = j_step|0
    i = 0; I = 0
    while i < i_count
      j = 0; J = I
      while j < j_count
        sum = fround(0.0)
        K = J<<1
        oppum[J] = fround(0.25*(opend[K]+opend[K+i_step]+opend[K+j_step]+opend[K+i_step+j_step]))
        j = (j+1)|0; J = (J+j_step)|0
      i = (i+1)|0; I = (I+i_step)|0
    null

  # convolute
  # --
  # Convolute a 1-componented Float32Array object with a 1D Float32Array kernel 
  # onto another 1-componented Float32Array object (should not be the same one).

  convolute: (oppum, opend, oppor, i_count, i_step, j_count, j_step, k_count, k_step)->
    i_count = i_count|0; i_step = i_step|0
    j_count = j_count|0; j_step = j_step|0
    k_count = k_count|0; k_step = k_step|0
    i = 0; I = 0
    while i < i_count
      j = 0; J = I
      while j < j_count
        sum = fround(0.0)
        k = 0; K = J|0
        while k < k_count
          sum = fround(sum + opend[K] * oppor[k])
          k = (k+1)|0; K = (K+k_step)|0
        oppum[J] = sum
        j = (j+1)|0; J = (J+j_step)|0
      i = (i+1)|0; I = (I+i_step)|0
    null

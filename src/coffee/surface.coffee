# Surface library provides basic functions that manipulate Float32Array objects.
# All functions are written in a order-free fashion.

fround = Math.fround
round = Math.round
pow = Math.pow

linearToCurve = new Float32Array(256)
for i in [0..255]
  c = i/255
  linearToCurve[i] = if c > 0.04045 then fround(pow((c+0.055)/1.055, 2.4)) else fround(c/12.92)


module.exports =

  # extract
  # --
  # Convert a 3-componented Uint8Array object into a 1-componented Float32Array object.
  # The result object contains 4 sub-planes, which are filled with 0s, red-, green-, and
  # blue-channel data of the original object, respectively.

  extract: (oppee0, oppee1, oppee2, opend, count1, step1, count0, step0)->
    count0 = count0|0; step0 = step0|0
    count1 = count1|0; step1 = step1|0
    _ = 0

    index1 = 0; offset1 = 0
    while index1 < count1
      index0 = 0; offset0 = offset1
      while index0 < count0

        channel0 = linearToCurve[opend[_]]; _ = _+1|0
        channel1 = linearToCurve[opend[_]]; _ = _+1|0
        channel2 = linearToCurve[opend[_]]; _ = _+1|0
        _ = _+1|0

        oppee0[offset0] = fround(0.4124*channel0+0.3576*channel1+0.1805*channel2)
        oppee1[offset0] = fround(0.2126*channel0+0.7152*channel1+0.0722*channel2)
        oppee2[offset0] = fround(0.0193*channel0+0.1192*channel1+0.9505*channel2)

        index0 = (index0+1)|0; offset0 = (offset0+step0)|0
      index1 = (index1+1)|0; offset1 = (offset1+step1)|0
    null

  # compact
  # --
  # Convert a 1-componented Float32Array object into a 3-componented Uint8Array object.
  # It's basically the opposite of Surface.extract(). Only the last 3 sub-planes of the argument object
  # is filled in the red-, green-, blue-channel of the result object.

  compact: (oppee, opend0, opend1, opend2, count1, step1, count0, step0)->
    count0 = count0|0; step0 = step0|0
    count1 = count1|0; step1 = step1|0
    _ = 0

    index1 = 0; offset1 = 0
    while index1 < count1
      index0 = 0; offset0 = offset1
      while index0 < count0

        channel0 = opend0[offset0]
        channel1 = opend1[offset0]
        channel2 = opend2[offset0]

        value0 = fround(+3.2406*channel0-1.5372*channel1-0.4986*channel2)
        value1 = fround(-0.9689*channel0+1.8758*channel1+0.0415*channel2)
        value2 = fround(+0.0557*channel0-0.2040*channel1+1.0570*channel2)

        value0 = if value0 > 0.0031308 then fround(pow(value0, 1/2.4)*1.055-0.055) else fround(12.92*value0)
        value1 = if value1 > 0.0031308 then fround(pow(value1, 1/2.4)*1.055-0.055) else fround(12.92*value1)
        value2 = if value2 > 0.0031308 then fround(pow(value2, 1/2.4)*1.055-0.055) else fround(12.92*value2)

        oppee[_] = round(value0*255)|0; _ = _+1|0
        oppee[_] = round(value1*255)|0; _ = _+1|0
        oppee[_] = round(value2*255)|0; _ = _+1|0
        oppee[_] = 255; _ = _+1|0

        index0 = (index0+1)|0; offset0 = (offset0+step0)|0
      index1 = (index1+1)|0; offset1 = (offset1+step1)|0
    null

  # flatten
  # --
  # Convert a 1-componented Float32Array object into a 3-componented Uint8Array object.
  # The single-channeled data of the original object is copyed into all 3 channels of the result object,
  # creating a grayscale complete image.

  flatten: (oppee, opend, count1, step1, count0, step0)->
    count0 = count0|0; step0 = step0|0
    count1 = count1|0; step1 = step1|0
    _ = 0

    index1 = 0; offset1 = 0
    while index1 < count1
      index0 = 0; offset0 = offset1
      while index0 < count0

        channel = opend[offset0]
        value = if channel > 0.0031308 then fround(pow(channel, 1/2.4)*1.055-0.055) else fround(channel*12.92)
        value = round(value*255)|0

        oppee[_] = value; _ = _+1|0
        oppee[_] = value; _ = _+1|0
        oppee[_] = value; _ = _+1|0
        oppee[_] = 255; _ = _+1|0

        index0 = (index0+1)|0; offset0 = (offset0+step0)|0
      index1 = (index1+1)|0; offset1 = (offset1+step1)|0
    console.log _
    null

  # downsize
  # --
  # Shrink the last 3 sub-places of a 1-componented Float32Array object
  # onto the first sub-plane of another Float32Array object. (could also be the same one)

  downsize: (oppee, opend, count1, step1, count0, step0)->
    count0 = count0|0; step0 = step0|0
    count1 = count1|0; step1 = step1|0

    index1 = 0; offset1 = 0
    while index1 < count1
      index0 = 0; offset0 = offset1
      while index0 < count0

        offset2 = offset0<<1
        oppee[offset0] = fround((
          opend[offset2]+
          opend[offset2+step0]+
          opend[offset2+step1]+
          opend[offset2+step0+step1]
        )/4)

        index0 = (index0+1)|0; offset0 = (offset0+step0)|0
      index1 = (index1+1)|0; offset1 = (offset1+step1)|0
    null

  # convolute
  # --
  # Convolute a 1-componented Float32Array object with a 1D Float32Array kernel
  # onto another 1-componented Float32Array object. (should not be the same one)

  convolute: (oppee, opend, opper, count1, step1, count0, step0, countKernel, stepKernel)->
    count0 = count0|0; step0 = step0|0
    count1 = count1|0; step1 = step1|0
    countKernel = countKernel|0; stepKernel = stepKernel|0

    index1 = 0; offset1 = 0
    while index1 < count1
      index0 = 0; offset0 = offset1
      while index0 < count0
        sum = fround(0.0)
        indexKernel = 0; offsetKernel = offset0
        while indexKernel < countKernel
          sum = fround(sum + opend[offsetKernel] * opper[indexKernel])
          indexKernel = (indexKernel+1)|0; offsetKernel = (offsetKernel+stepKernel)|0
        oppee[offset0] = sum
        index0 = (index0+1)|0; offset0 = (offset0+step0)|0
      index1 = (index1+1)|0; offset1 = (offset1+step1)|0
    null

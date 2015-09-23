fround = Math.fround

module.exports =

  # trace
  # --
  # Retrieve the __trace of Hessian matrix__ from a Float32Array object in a new Float32Array object.

  trace: (oppee, opend, sigma, count1, step1, count0, step0)->
    s2_1 = fround(sigma*sigma)
    count0 = (count0-2)|0; step0 = step0|0
    count1 = (count1-2)|0; step1 = step1|0
    offset = (step0+step1)|0
    index1 = 0; offset1 = offset
    while index1 < count1
      index0 = 0; offset0 = offset1
      e10 = opend[offset0-step0-step1]; e20 = opend[offset0-step1]
      e11 = opend[offset0-step0      ]; e21 = opend[offset0      ]
      e12 = opend[offset0-step0+step1]; e22 = opend[offset0+step1]
      while index0 < count0
        e00 = e10; e10 = e20; e20 = opend[offset0+step0-step1]
        e01 = e11; e11 = e21; e21 = opend[offset0+step0      ]
        e02 = e12; e12 = e22; e22 = opend[offset0+step0+step1]

        f00 = fround(s2_1*(e01+e21-e11-e11))
        f11 = fround(s2_1*(e10+e12-e11-e11))

        oppee[offset0] = f00+f11

        index0 = (index0+1)|0; offset0 = (offset0+step0)|0
      index1 = (index1+1)|0; offset1 = (offset1+step1)|0
    null

  # determinant
  # --
  # Retrieve the __determinant of Hessian matrix__ from a Float32Array object in a new Float32Array object.

  determinant: (oppee, opend, sigma, count1, step1, count0, step0)->
    s2_1 = fround(sigma*sigma)
    s2_4 = fround(sigma*sigma/4)
    count0 = (count0-2)|0; step0 = step0|0
    count1 = (count1-2)|0; step1 = step1|0
    offset = (step0+step1)|0
    index1 = 0; offset1 = offset
    while index1 < count1
      index0 = 0; offset0 = offset1
      e10 = opend[offset0-step0-step1]; e20 = opend[offset0-step1]
      e11 = opend[offset0-step0      ]; e21 = opend[offset0      ]
      e12 = opend[offset0-step0+step1]; e22 = opend[offset0+step1]
      while index0 < count0
        e00 = e10; e10 = e20; e20 = opend[offset0+step0-step1]
        e01 = e11; e11 = e21; e21 = opend[offset0+step0      ]
        e02 = e12; e12 = e22; e22 = opend[offset0+step0+step1]

        f00 = fround(s2_1*(e01+e21-e11-e11))
        f01 = fround(s2_4*(e00+e22-e02-e20))
        f11 = fround(s2_1*(e10+e12-e11-e11))

        oppee[offset0] = f00*f11-f01*f01

        index0 = (index0+1)|0; offset0 = (offset0+step0)|0
      index1 = (index1+1)|0; offset1 = (offset1+step1)|0
    null

  # gaussian
  # --
  # Retrieve the __determinant of Gaussian matrix__ from a Float32Array object in a new Float32Array object.

  gaussian: (oppee, opend, sigma, count1, step1, count0, step0)->
    s1_2 = fround(sigma/2)
    s2_1 = fround(sigma*sigma)
    s2_4 = fround(sigma*sigma/4)
    count0 = (count0-2)|0; step0 = step0|0
    count1 = (count1-2)|0; step1 = step1|0
    offset = (step0+step1)|0
    index1 = 0; offset1 = offset
    while index1 < count1
      index0 = 0; offset0 = offset1
      e10 = opend[offset0-step0-step1]; e20 = opend[offset0-step1]
      e11 = opend[offset0-step0      ]; e21 = opend[offset0      ]
      e12 = opend[offset0-step0+step1]; e22 = opend[offset0+step1]
      while index0 < count0
        e00 = e10; e10 = e20; e20 = opend[offset0+step0-step1]
        e01 = e11; e11 = e21; e21 = opend[offset0+step0      ]
        e02 = e12; e12 = e22; e22 = opend[offset0+step0+step1]

        f00 = fround(s2_1*(e01+e21-e11-e11))
        f01 = fround(s2_4*(e00+e22-e02-e20))
        f11 = fround(s2_1*(e10+e12-e11-e11))
        f0  = fround(s1_2*(e21-e01))
        f1  = fround(s1_2*(e12-e10))
        f   = e11

        norm = fround(1/(f*f))
        g00 = fround(norm*(f00*f-f0*f0))
        g01 = fround(norm*(f01*f-f0*f1))
        g11 = fround(norm*(f11*f-f1*f1))

        oppee[offset0] = g00*g11-g01*g01

        index0 = (index0+1)|0; offset0 = (offset0+step0)|0
      index1 = (index1+1)|0; offset1 = (offset1+step1)|0
    null

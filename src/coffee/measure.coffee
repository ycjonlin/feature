fround = Math.fround

module.exports = 
  constant: (oppum, opend, sigma, count0, step0, count1, step1)->
    count0 = count0|0; step0 = step0|0
    count1 = count1|0; step1 = step1|0
    index1 = 0; offset1 = 0
    while index1 < count1
      index0 = 0; offset0 = offset1
      while index0 < count0

        oppum[offset0] = opend[offset0]

        index0 = (index0+1)|0; offset0 = (offset0+step0)|0
      index1 = (index1+1)|0; offset1 = (offset1+step1)|0
    null

  trace: (oppum, opend, sigma, count0, step0, count1, step1)->
    s2_1 = fround(sigma*sigma)
    count0 = count0|0; step0 = step0|0
    count1 = count1|0; step1 = step1|0
    index1 = 0; offset1 = 0
    while index1 < count1
      index0 = 0; offset0 = offset1
      while index0 < count0

        e00 = e10; e10 = e20; e20 = opend[offset0+step0-step1]
        e01 = e11; e11 = e21; e21 = opend[offset0+step0]
        e02 = e12; e12 = e22; e22 = opend[offset0+step0+step1]

        f00 = fround(s2_1*(e01+e21-e11-e11))
        f11 = fround(s2_1*(e10+e12-e11-e11))

        oppum[offset0] = f00+f11

        index0 = (index0+1)|0; offset0 = (offset0+step0)|0
      index1 = (index1+1)|0; offset1 = (offset1+step1)|0
    null

  determinant: (oppum, opend, sigma, count0, step0, count1, step1)->
    s2_1 = fround(sigma*sigma)
    s2_4 = fround(sigma*sigma/4)
    count0 = count0|0; step0 = step0|0
    count1 = count1|0; step1 = step1|0
    index1 = 0; offset1 = 0
    while index1 < count1
      index0 = 0; offset0 = offset1
      while index0 < count0

        e00 = e10; e10 = e20; e20 = opend[offset0+step0-step1]
        e01 = e11; e11 = e21; e21 = opend[offset0+step0]
        e02 = e12; e12 = e22; e22 = opend[offset0+step0+step1]

        f00 = fround(s2_1*(e01+e21-e11-e11))
        f01 = fround(s2_4*(e00+e22-e02-e20))
        f11 = fround(s2_1*(e10+e12-e11-e11))

        oppum[offset0] = f00*f11-f01*f01

        index0 = (index0+1)|0; offset0 = (offset0+step0)|0
      index1 = (index1+1)|0; offset1 = (offset1+step1)|0
    null

  gaussian: (oppum, opend, sigma, count0, step0, count1, step1)->
    s1_2 = fround(sigma/2)
    s2_1 = fround(sigma*sigma)
    s2_4 = fround(sigma*sigma/4)
    count0 = count0|0; step0 = step0|0
    count1 = count1|0; step1 = step1|0
    index1 = 0; offset1 = 0
    while index1 < count1
      index0 = 0; offset0 = offset1
      while index0 < count0

        e00 = e10; e10 = e20; e20 = opend[offset0+step0-step1]
        e01 = e11; e11 = e21; e21 = opend[offset0+step0]
        e02 = e12; e12 = e22; e22 = opend[offset0+step0+step1]

        f00 = fround(s2_1*(e01+e21-e11-e11))
        f01 = fround(s2_4*(e00+e22-e02-e20))
        f11 = fround(s2_1*(e10+e12-e11-e11))
        f0  = fround(s1_2*(e21-e01))
        f1  = fround(s1_2*(e12-e10))
        f   = e11

        norm = 1/(f*f)
        g00 = fround((f00*f-f0*f0)*norm)
        g01 = fround((f01*f-f0*f1)*norm)
        g11 = fround((f11*f-f1*f1)*norm)

        oppum[offset0] = g00*g11-g01*g01

        index0 = (index0+1)|0; offset0 = (offset0+step0)|0
      index1 = (index1+1)|0; offset1 = (offset1+step1)|0
    null

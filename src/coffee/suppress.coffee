
module.exports = 
  neighbor_18: (oppum, opend0, opend1, opend2, count0, step0, count1, step1)->
    total = 0
    count0 = count0|0; step0 = step0|0
    count1 = count1|0; step1 = step1|0
    index1 = 0; offset1 = 0
    while index1 < count1
      index0 = 0; offset0 = offset1
      while index0 < count0

        e00 = e10; e10 = e20; e20 = opend1[offset0+step0-step1]
        e01 = e11; e11 = e21; e21 = opend1[offset0+step0]
        e02 = e12; e12 = e22; e22 = opend1[offset0+step0+step1]

        sign = e11<e01
        if (sign and (
            (e11<e00) and (e11<e01) and (e11<e02) and 
            (e11<e10) and               (e11<e12) and 
            (e11<e20) and (e11<e21) and (e11<e22) and 
            (e11<opend0[offset0]) and 
            (e11<opend0[offset0-step0]) and (e11<opend0[offset0+step0]) and 
            (e11<opend0[offset0-step1]) and (e11<opend0[offset0+step1]) and 
            (e11<opend2[offset0]) and 
            (e11<opend2[offset0-step0]) and (e11<opend2[offset0+step0]) and 
            (e11<opend2[offset0-step1]) and (e11<opend2[offset0+step1])
          ) or (
            (e11>e00) and (e11>e01) and (e11>e02) and 
            (e11>e10) and               (e11>e12) and 
            (e11>e20) and (e11>e21) and (e11>e22) and 
            (e11>opend0[offset0]) and 
            (e11>opend0[offset0-step0]) and (e11>opend0[offset0+step0]) and 
            (e11>opend0[offset0-step1]) and (e11>opend0[offset0+step1]) and 
            (e11>opend2[offset0]) and 
            (e11>opend2[offset0-step0]) and (e11>opend2[offset0+step0]) and 
            (e11>opend2[offset0-step1]) and (e11>opend2[offset0+step1])
          )
        )
          oppum[total] = if sign then -offset0 else offset0
          total += 1

        index0 = (index0+1)|0; offset0 = (offset0+step0)|0
      index1 = (index1+1)|0; offset1 = (offset1+step1)|0
    total

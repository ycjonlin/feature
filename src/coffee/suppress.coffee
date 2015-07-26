
module.exports =
  neighbor_6: (oppum, opend0, opend1, opend2, count1, step1, count0, step0)->
    total = 0
    count0 = (count0-2)|0; step0 = step0|0
    count1 = (count1-2)|0; step1 = step1|0
    index1 = 0; offset1 = (step0+step1)|0
    while index1 < count1
      index0 = 0; offset0 = offset1
      e10 = opend1[offset0-step0-step1]; e20 = opend1[offset0-step1]
      e11 = opend1[offset0-step0      ]; e21 = opend1[offset0      ]
      e12 = opend1[offset0-step0+step1]; e22 = opend1[offset0+step1]
      while index0 < count0
        e00 = e10; e10 = e20; e20 = opend1[offset0+step0-step1]
        e01 = e11; e11 = e21; e21 = opend1[offset0+step0      ]
        e02 = e12; e12 = e22; e22 = opend1[offset0+step0+step1]

        sign = e11<e01
        if (sign and (
            (e11<e01) and (e11<e10) and (e11<e12) and (e11<e21) and
            (e11<opend0[offset0]) and (e11<opend2[offset0])
          ) or (
            (e11>e01) and (e11>e10) and (e11>e12) and (e11>e21) and
            (e11>opend0[offset0]) and (e11>opend2[offset0])
          )
        )
          oppum[total] = offset0
          total += 1

        index0 = (index0+1)|0; offset0 = (offset0+step0)|0
      index1 = (index1+1)|0; offset1 = (offset1+step1)|0
    #console.log 'suppress', total
    total

  neighbor_18: (oppum, opend0, opend1, opend2, count1, step1, count0, step0)->
    total = 0
    count0 = (count0-2)|0; step0 = step0|0
    count1 = (count1-2)|0; step1 = step1|0
    index1 = 0; offset1 = (step0+step1)|0
    while index1 < count1
      index0 = 0; offset0 = offset1
      e10 = opend1[offset0-step0-step1]; e20 = opend1[offset0-step1]
      e11 = opend1[offset0-step0      ]; e21 = opend1[offset0      ]
      e12 = opend1[offset0-step0+step1]; e22 = opend1[offset0+step1]
      while index0 < count0
        e00 = e10; e10 = e20; e20 = opend1[offset0+step0-step1]
        e01 = e11; e11 = e21; e21 = opend1[offset0+step0      ]
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
          oppum[total] = offset0
          total += 1

        index0 = (index0+1)|0; offset0 = (offset0+step0)|0
      index1 = (index1+1)|0; offset1 = (offset1+step1)|0
    console.log 'suppress', total
    total

console.log global
module.exports =
  neighbor_6: (oppumList, opend0, opend1, opend2, border, count1, step1, count0, step0)->
    totalList = (0 for color in [1..oppumList.length])
    lastColor = 0
    oppum = oppumList[lastColor]
    total = totalList[lastColor]
    colorChanges = 0

    count0 = count0|0; step0 = step0|0
    count1 = count1|0; step1 = step1|0
    range0 = (count0-border)|0
    range1 = (count1-border)|0
    index1 = border; offset1 = ((step0+step1)*border)|0
    while index1 < range1
      index0 = border; offset0 = offset1
      e10 = opend1[offset0-step0-step1]; e20 = opend1[offset0-step1]
      e11 = opend1[offset0-step0      ]; e21 = opend1[offset0      ]
      e12 = opend1[offset0-step0+step1]; e22 = opend1[offset0+step1]
      while index0 < range0
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
          # index
          i0 = index0|0; n0 = count0
          i1 = index1|0; n1 = count1
          # scale
          scale = -1
          while n0 >= i0 and n1 >= i1
            n0 >>= 1; n1 >>= 1; scale += 1
          # color
          color = if sign then -1 else 2
          if i0 >= n0 then i0 -= n0; color += 2
          if i1 >= n1 then i1 -= n1; color += 1
          # border
          if i0 >= border and i0 < n0-border and
             i1 >= border and i1 < n1-border
            if lastColor != color
              colorChanges += 1
              totalList[lastColor] = total
              oppum = oppumList[color]
              total = totalList[color]
              lastColor = color
            oppum[total+0] = offset0
            oppum[total+1] = i0|(i1<<12)|(scale<<24)|(color<<28)
            total += 2

        index0 = (index0+1)|0; offset0 = (offset0+step0)|0
      index1 = (index1+1)|0; offset1 = (offset1+step1)|0
    totalList[lastColor] = total
    totalList

  neighbor_18: (oppum, opend0, opend1, opend2, border, count1, step1, count0, step0)->
    total = 0
    count0 = count0|0; step0 = step0|0
    count1 = count1|0; step1 = step1|0
    range0 = (count0-border)|0
    range1 = (count1-border)|0
    index1 = border; offset1 = ((step0+step1)*border)|0
    while index1 < range1
      index0 = border; offset0 = offset1
      e10 = opend1[offset0-step0-step1]; e20 = opend1[offset0-step1]
      e11 = opend1[offset0-step0      ]; e21 = opend1[offset0      ]
      e12 = opend1[offset0-step0+step1]; e22 = opend1[offset0+step1]
      while index0 < range0
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
          # index
          i0 = index0|0; n0 = count0
          i1 = index1|0; n1 = count1
          # scale
          scale = -1
          while n0 >= i0 and n1 >= i1
            n0 >>= 1; n1 >>= 1; scale += 1
          # color
          color = if sign then 0 else 4
          if i0 >= n0 then i0 -= n0; color |= 2
          if i1 >= n1 then i1 -= n1; color |= 1
          # border
          if i0 >= border and i0 < n0-border and
             i1 >= border and i1 < n1-border
            oppum[total+0] = offset0
            oppum[total+1] = i0|(i1<<12)|(scale<<24)|(color<<28)
            total += 2

        index0 = (index0+1)|0; offset0 = (offset0+step0)|0
      index1 = (index1+1)|0; offset1 = (offset1+step1)|0
    total

sign = Math.sign

module.exports = 
  neighbor_6: (oppum, opend0, opend1, opend2, i_count, i_step, j_count, j_step)->
    total = 0
    i_count = i_count|0; i_step = i_step|0
    j_count = j_count|0; j_step = j_step|0
    i = 0; I = 0
    while i < i_count
      j = 0; J = I
      while j < j_count

        J1 = (J+j_step)|0
        J0 = (J1-i_step)|0
        J2 = (J1+i_step)|0

        e00 = e10; e01 = e11; e02 = e12
        e10 = e20; e11 = e21; e12 = e22
        e20 = opend1[J0]
        e21 = opend1[J1]
        e22 = opend1[J2]

        if (e01<e11) and (
          (e01<e11) and (e21<e11) and 
          (e10<e11) and (e12<e11) and 
          (opend0[J]<e11) and (opend2[J]<e11)
        ) or (
          (e01>e11) and (e21>e11) and 
          (e10>e11) and (e12>e11) and 
          (opend0[J]>e11) and (opend2[J]>e11)
        )
          oppum[total] = J
          total += 1

        j = (j+1)|0; J = (J+j_step)|0
      i = (i+1)|0; I = (I+i_step)|0
    total

  neighbor_18: (oppum, opend0, opend1, opend2, i_count, i_step, j_count, j_step)->
    total = 0
    i_count = i_count|0; i_step = i_step|0
    j_count = j_count|0; j_step = j_step|0
    i = 0; I = 0
    while i < i_count
      j = 0; J = I
      while j < j_count

        J1 = (J+j_step)|0
        J0 = (J1-i_step)|0
        J2 = (J1+i_step)|0

        d00 = d10; d01 = d11; d02 = d12
        d10 = d20; d11 = d21; d12 = d22
        d20 = opend0[J0]
        d21 = opend0[J1]
        d22 = opend0[J2]

        e00 = e10; e01 = e11; e02 = e12
        e10 = e20; e11 = e21; e12 = e22
        e20 = opend1[J0]
        e21 = opend1[J1]
        e22 = opend1[J2]

        f00 = f10; f01 = f11; f02 = f12
        f10 = f20; f11 = f21; f12 = f22
        f20 = opend2[J0]
        f21 = opend2[J1]
        f22 = opend2[J2]

        if (d01<e11) and (
          #(d01<e11) and 
          (d10<e11) and (d11<e11) and (d12<e11) and 
          (d21<e11) and

          (e00<e11) and (e01<e11) and (e02<e11) and 
          (e10<e11) and               (e12<e11) and 
          (e20<e11) and (e21<e11) and (e22<e11) and

          (f01<e11) and 
          (f10<e11) and (f11<e11) and (f12<e11) and 
          (f21<e11)
        ) or (
          #(d01>e11) and 
          (d10>e11) and (d11>e11) and (d12>e11) and 
          (d21>e11) and

          (e00>e11) and (e01>e11) and (e02>e11) and 
          (e10>e11) and               (e12>e11) and 
          (e20>e11) and (e21>e11) and (e22>e11) and

          (f01>e11) and 
          (f10>e11) and (f11>e11) and (f12>e11) and 
          (f21>e11)
        )
          oppum[total] = J
          total += 1

        j = (j+1)|0; J = (J+j_step)|0
      i = (i+1)|0; I = (I+i_step)|0
    total

  neighbor_26: (oppum, opend0, opend1, opend2, i_count, i_step, j_count, j_step)->
    total = 0
    i_count = i_count|0; i_step = i_step|0
    j_count = j_count|0; j_step = j_step|0
    i = 0; I = 0
    while i < i_count
      j = 0; J = I
      while j < j_count

        J1 = (J+j_step)|0
        J0 = (J1-i_step)|0
        J2 = (J1+i_step)|0

        d00 = d10; d01 = d11; d02 = d12
        d10 = d20; d11 = d21; d12 = d22
        d20 = opend0[J0]
        d21 = opend0[J1]
        d22 = opend0[J2]

        e00 = e10; e01 = e11; e02 = e12
        e10 = e20; e11 = e21; e12 = e22
        e20 = opend1[J0]
        e21 = opend1[J1]
        e22 = opend1[J2]

        f00 = f10; f01 = f11; f02 = f12
        f10 = f20; f11 = f21; f12 = f22
        f20 = opend2[J0]
        f21 = opend2[J1]
        f22 = opend2[J2]

        if (d00<e11) and (
          (d00<e11) and (d01<e11) and (d02<e11) and
          (d10<e11) and (d11<e11) and (d12<e11) and
          (d20<e11) and (d21<e11) and (d22<e11) and

          (e00<e11) and (e01<e11) and (e02<e11) and
          (e10<e11) and               (e12<e11) and
          (e20<e11) and (e21<e11) and (e22<e11) and

          (f00<e11) and (f01<e11) and (f02<e11) and
          (f10<e11) and (f11<e11) and (f12<e11) and
          (f20<e11) and (f21<e11) and (f22<e11)
        ) or (
          (d00>e11) and (d01>e11) and (d02>e11) and
          (d10>e11) and (d11>e11) and (d12>e11) and
          (d20>e11) and (d21>e11) and (d22>e11) and

          (e00>e11) and (e01>e11) and (e02>e11) and
          (e10>e11) and               (e12>e11) and
          (e20>e11) and (e21>e11) and (e22>e11) and

          (f00>e11) and (f01>e11) and (f02>e11) and
          (f10>e11) and (f11>e11) and (f12>e11) and
          (f20>e11) and (f21>e11) and (f22>e11)
        )
          oppum[total] = J
          total += 1

        j = (j+1)|0; J = (J+j_step)|0
      i = (i+1)|0; I = (I+i_step)|0
    total

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

        e00 = e10; e01 = e11; e02 = e12
        e10 = e20; e11 = e21; e12 = e22
        e20 = opend1[J+j_step-i_step]
        e21 = opend1[J+j_step]
        e22 = opend1[J+j_step+i_step]

        if (((e01 < e11) == (e21 < e11)) == (e10 < e11)) == (e12 < e11)
          oppum[total] = J
          total += 1
        ###
        signs =
          sign(e01-e11) + sign(e21-e11) +
          sign(e10-e11) + sign(e12-e11) +
          sign(opend0[J]-e11) + 
          sign(opend2[J]-e11)

        if signs == -6 or signs == 6
          oppum[total] = J
          total += 1
        ###

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

        d00 = d10; d01 = d11; d02 = d12
        d10 = d20; d11 = d21; d12 = d22
        d20 = opend0[J+j_step-i_step]
        d21 = opend0[J+j_step]
        d22 = opend0[J+j_step+i_step]

        e00 = e10; e01 = e11; e02 = e12
        e10 = e20; e11 = e21; e12 = e22
        e20 = opend1[J+j_step-i_step]
        e21 = opend1[J+j_step]
        e22 = opend1[J+j_step+i_step]

        f00 = f10; f01 = f11; f02 = f12
        f10 = f20; f11 = f21; f12 = f22
        f20 = opend2[J+j_step-i_step]
        f21 = opend2[J+j_step]
        f22 = opend2[J+j_step+i_step]

        sign = 
          sign(d01-e11) + 
          sign(d10-e11) + sign(d11-e11) + sign(d12-e11) + 
          sign(d21-e11) + 

          sign(e00-e11) + sign(e01-e11) + sign(e02-e11) +
          sign(e10-e11) +                 sign(e12-e11) +
          sign(e20-e11) + sign(e21-e11) + sign(e22-e11) +

          sign(f01-e11) + 
          sign(f10-e11) + sign(f11-e11) + sign(f12-e11) + 
          sign(f21-e11)

        if signs == -18 or signs == 18
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

        d00 = d10; d01 = d11; d02 = d12
        d10 = d20; d11 = d21; d12 = d22
        d20 = opend0[J+j_step-i_step]
        d21 = opend0[J+j_step]
        d22 = opend0[J+j_step+i_step]

        e00 = e10; e01 = e11; e02 = e12
        e10 = e20; e11 = e21; e12 = e22
        e20 = opend1[J+j_step-i_step]
        e21 = opend1[J+j_step]
        e22 = opend1[J+j_step+i_step]

        f00 = f10; f01 = f11; f02 = f12
        f10 = f20; f11 = f21; f12 = f22
        f20 = opend2[J+j_step-i_step]
        f21 = opend2[J+j_step]
        f22 = opend2[J+j_step+i_step]

        signs =
          sign(d00-e11) + sign(d01-e11) + sign(d02-e11) +
          sign(d10-e11) + sign(d11-e11) + sign(d12-e11) +
          sign(d20-e11) + sign(d21-e11) + sign(d22-e11) +

          sign(e00-e11) + sign(e01-e11) + sign(e02-e11) +
          sign(e10-e11) +                 sign(e12-e11) +
          sign(e20-e11) + sign(e21-e11) + sign(e22-e11) +

          sign(f00-e11) + sign(f01-e11) + sign(f02-e11) +
          sign(f10-e11) + sign(f11-e11) + sign(f12-e11) +
          sign(f20-e11) + sign(f21-e11) + sign(f22-e11)

        if signs == -26 or signs == 26
          oppum[total] = J
          total += 1

        j = (j+1)|0; J = (J+j_step)|0
      i = (i+1)|0; I = (I+i_step)|0
    total

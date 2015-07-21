
module.exports = 
  neighbor_18: (oppum, opend0, opend1, opend2, i_count, i_step, j_count, j_step)->
    total = 0
    i_count = i_count|0; i_step = i_step|0
    j_count = j_count|0; j_step = j_step|0
    i = 0; I = 0
    while i < i_count
      j = 0; J = I
      while j < j_count

        e00 = e10; e10 = e20; e20 = opend1[J+j_step-i_step]
        e01 = e11; e11 = e21; e21 = opend1[J+j_step]
        e02 = e12; e12 = e22; e22 = opend1[J+j_step+i_step]

        sign = e11<e01
        if (sign and (
            (e11<e00) and (e11<e01) and (e11<e02) and 
            (e11<e10) and               (e11<e12) and 
            (e11<e20) and (e11<e21) and (e11<e22) and 
            (e11<opend0[J]) and 
            (e11<opend0[J-i_step]) and (e11<opend0[J+i_step]) and 
            (e11<opend0[J-j_step]) and (e11<opend0[J+j_step]) and 
            (e11<opend2[J]) and 
            (e11<opend2[J-i_step]) and (e11<opend2[J+i_step]) and 
            (e11<opend2[J-j_step]) and (e11<opend2[J+j_step])
          ) or (
            (e11>e00) and (e11>e01) and (e11>e02) and 
            (e11>e10) and               (e11>e12) and 
            (e11>e20) and (e11>e21) and (e11>e22) and 
            (e11>opend0[J]) and 
            (e11>opend0[J-i_step]) and (e11>opend0[J+i_step]) and 
            (e11>opend0[J-j_step]) and (e11>opend0[J+j_step]) and 
            (e11>opend2[J]) and 
            (e11>opend2[J-i_step]) and (e11>opend2[J+i_step]) and 
            (e11>opend2[J-j_step]) and (e11>opend2[J+j_step])
          )
        )
          oppum[total] = if sign then -J else J
          total += 1

        j = (j+1)|0; J = (J+j_step)|0
      i = (i+1)|0; I = (I+i_step)|0
    total

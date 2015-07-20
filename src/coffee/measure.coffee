fround = Math.fround

measure_constant = (oppum, opend, sigma, i_count, i_step, j_count, j_step)->
  i_count = i_count|0; i_step = i_step|0
  j_count = j_count|0; j_step = j_step|0
  i = 0; I = 0
  while i < i_count
    j = 0; J = I
    while j < j_count

      oppum[J] = opend[J]

      j = (j+1)|0; J = (J+j_step)|0
    i = (i+1)|0; I = (I+i_step)|0
  null

measure_trace = (oppum, opend, sigma, i_count, i_step, j_count, j_step)->
  i_count = i_count|0; i_step = i_step|0
  j_count = j_count|0; j_step = j_step|0
  i = 0; I = 0
  s2_1 = fround(sigma*sigma)
  s2_4 = fround(sigma*sigma/4)
  while i < i_count
    j = 0; J = I
    while j < j_count

      e00 = e10; e01 = e11; e02 = e12
      e10 = e20; e11 = e21; e12 = e22
      e20 = opend[J+j_step-i_step]
      e21 = opend[J+j_step]
      e22 = opend[J+j_step+i_step]

      _jj = fround(s2_1 * (e01 - e11 - e11 + e21))
      _ii = fround(s2_1 * (e10 - e11 - e11 + e12))

      oppum[J] = 0.5 + 1e0 * (_ii + _jj)

      j = (j+1)|0; J = (J+j_step)|0
    i = (i+1)|0; I = (I+i_step)|0
  null

measure_determinant = (oppum, opend, sigma, i_count, i_step, j_count, j_step)->
  i_count = i_count|0; i_step = i_step|0
  j_count = j_count|0; j_step = j_step|0
  i = 0; I = 0
  s2_1 = fround(sigma*sigma)
  s2_4 = fround(sigma*sigma/4)
  while i < i_count
    j = 0; J = I
    while j < j_count

      e00 = e10; e01 = e11; e02 = e12
      e10 = e20; e11 = e21; e12 = e22
      e20 = opend[J+j_step-i_step]
      e21 = opend[J+j_step]
      e22 = opend[J+j_step+i_step]

      _jj = fround(s2_1 * (e01 - e11 - e11 + e21))
      _ii = fround(s2_1 * (e10 - e11 - e11 + e12))
      _ij = fround(s2_4 * (e00 - e02 - e20 + e22))

      oppum[J] = 0.5 + 2e1 * (_ii * _jj - _ij * _ij)

      j = (j+1)|0; J = (J+j_step)|0
    i = (i+1)|0; I = (I+i_step)|0
  null

measure_gaussian = (oppum, opend, sigma, i_count, i_step, j_count, j_step)->
  i_count = i_count|0; i_step = i_step|0
  j_count = j_count|0; j_step = j_step|0
  i = 0; I = 0
  s1_2 = fround(sigma/2)
  s2_1 = fround(sigma*sigma)
  s2_4 = fround(sigma*sigma/4)
  while i < i_count
    j = 0; J = I
    while j < j_count

      e00 = e10; e01 = e11; e02 = e12
      e10 = e20; e11 = e21; e12 = e22
      e20 = opend[J+j_step-i_step]
      e21 = opend[J+j_step]
      e22 = opend[J+j_step+i_step]

      _   = e11
      _j  = fround(s1_2 * (e21 - e01))
      _i  = fround(s1_2 * (e12 - e10))
      _jj = fround(s2_1 * (e01 - e11 - e11 + e21))
      _ii = fround(s2_1 * (e10 - e11 - e11 + e12))
      _ij = fround(s2_4 * (e00 - e02 - e20 + e22))

      norm = fround(1 / (_ * _))
      _uu = fround(norm * (_ii * _ - _i * _i))
      _vv = fround(norm * (_jj * _ - _j * _j))
      _uv = fround(norm * (_ij * _ - _i * _j))

      oppum[J] = 0.5 + 1e0 * (_uu * _vv - _uv * _uv)

      j = (j+1)|0; J = (J+j_step)|0
    i = (i+1)|0; I = (I+i_step)|0
  null

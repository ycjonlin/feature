fround = Math.fround
sqrt = Math.sqrt
exp = Math.exp
log = Math.log
cos = Math.cos
sin = Math.sin
atan2 = Math.atan2
abs = Math.abs
sign = Math.sign
ceil = Math.ceil
pow = Math.pow
pi = Math.PI
tau = pi*2

module.exports =
  gaussian: (oppum, opend, opper, count0, count1)->
    total = 0
    for offset, i in opper by 2
      fields = opper[i+1]

      i0 = fields&0xfff
      i1 = (fields>>12)&0xfff
      scale = (fields>>24)&0xf
      color = (fields>>28)&0xf

      offset0 = offset-count0; offset1 = offset; offset2 = offset+count0
      e00 = opend[offset0-1]; e01 = opend[offset0]; e02 = opend[offset0+1]
      e10 = opend[offset1-1]; e11 = opend[offset1]; e12 = opend[offset1+1]
      e20 = opend[offset2-1]; e21 = opend[offset2]; e22 = opend[offset2+1]

      x0 = fround(i0<<scale)
      x1 = fround(i1<<scale)
      s1 = fround(1<<scale)
      s2 = fround(1<<scale<<scale)

      # taylerian: f(x) ~ x'[]f[,]x[]
      f00 = fround(s2*(e01+e21-e11-e11))
      f01 = fround(s2*(e00+e22-e02-e20)/4)
      f11 = fround(s2*(e10+e12-e11-e11))
      f0  = fround(s1*(e21-e01)/2)
      f1  = fround(s1*(e12-e10)/2)
      f   = fround(e11)

      # gaussian: f(x) ~ exp(1/2 x'[]g[,]x[])
      norm = fround(1/(f*f))
      g00 = fround(norm*(f00*f-f0*f0))
      g01 = fround(norm*(f01*f-f0*f1))
      g11 = fround(norm*(f11*f-f1*f1))
      g0  = fround(f0/f-g00*x0-g01*x1)
      g1  = fround(f1/f-g01*x0-g11*x1)
      g   = fround(log(f)*2-(f0/f+g0)*x0-(f1/f+g1)*x1)

      trc = (g00+g11)/2
      det = g00*g11-g01*g01
      dif = sqrt(trc*trc-det)
      l0 = trc-dif
      l1 = trc+dif

      norm = fround(1/(g01*g01-g00*g11))
      u0 = fround(norm*(g0*g11-g1*g01))
      u1 = fround(norm*(g1*g00-g0*g01))
      t = atan2(-g01-g01, g00-g11)/2
      r = s2_1*sqrt(abs(l0*l1))
      r0 = 1/sqrt(abs(l0/r))
      r1 = 1/sqrt(abs(l1/r))

      oppum[total+0] = u0
      oppum[total+1] = u1
      oppum[total+2] = t
      oppum[total+3] = r0
      oppum[total+4] = r1
      oppum[total+5] = color
      total += 6
    total

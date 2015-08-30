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
  gaussian: (oppum, opend, opper, sigma, count0, count1)->
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

      s = fround(sigma*(1<<scale))
      x0 = fround(i0<<scale)
      x1 = fround(i1<<scale)

      # taylerian: f(x) ~ x'[]f[,]x[]
      f00 = fround((e01+e21-e11-e11)/s/s)
      f01 = fround((e00+e22-e02-e20)/s/s/4)
      f11 = fround((e10+e12-e11-e11)/s/s)
      f0  = fround((e21-e01)/s/2)
      f1  = fround((e12-e10)/s/2)
      f   = fround(e11)

      # gaussian: f(x) ~ exp(1/2 x'[]g[,]x[])
      norm = fround(1/(s*s*f*f))
      g00 = fround(norm*(f*f00-f0*f0))
      g01 = fround(norm*(f*f01-f0*f1))
      g11 = fround(norm*(f*f11-f1*f1))
      norm = fround(1/(s*f))
      g0 = fround(norm*f0-(g00*x0+g01*x1))
      g1 = fround(norm*f1-(g01*x0+g11*x1))
      g = fround(log(f)-((norm*f0+g0)*x0+(norm*f1+g1)*x1)/2)

      oppum[total+0] = g00
      oppum[total+1] = g01
      oppum[total+2] = g11
      oppum[total+3] = g0
      oppum[total+4] = g1
      oppum[total+5] = g
      total += 6
    total

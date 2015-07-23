fround = Math.fround
sqrt = Math.sqrt
exp = Math.exp
log = Math.log
abs = Math.abs
sign = Math.sign
ceil = Math.ceil
pow = Math.pow
pi = Math.PI
tau = pi*2

colorList = [
  'rgba(0,0,0, 0.25)',
  'rgba(255,0,0, 0.25)',
  'rgba(0,255,0, 0.25)',
  'rgba(0,0,255, 0.25)',
  'rgba(255,255,255, 0.25)',
  'rgba(0,255,255, 0.25)',
  'rgba(255,0,255, 0.25)',
  'rgba(255,255,0, 0.25)',
]

class Matrix
  constructor: (
    @m00, @m01, @m02,
    @m10, @m11, @m12,
    @m20, @m21, @m22)->

  transpose: ()->
    new Matrix(
      @m00, @m10, @m20,
      @m01, @m11, @m21,
      @m02, @m12, @m22,
    )

  norm: (x0, x1, x2)-> (
    @m00*x0*x0+@m01*x0*x1+@m02*x0*x2+
    @m10*x1*x0+@m11*x1*x1+@m12*x1*x2+
    @m20*x2*x0+@m21*x2*x1+@m22*x2*x2)

  multiply: ($)->
    new Matrix(
      @m00*$.m00+@m01*$.m10+@m02*$.m20,
      @m00*$.m01+@m01*$.m11+@m02*$.m21,
      @m00*$.m02+@m01*$.m12+@m02*$.m22,

      @m10*$.m00+@m11*$.m10+@m12*$.m20,
      @m10*$.m01+@m11*$.m11+@m12*$.m21,
      @m10*$.m02+@m11*$.m12+@m12*$.m22,

      @m20*$.m00+@m21*$.m10+@m22*$.m20,
      @m20*$.m01+@m21*$.m11+@m22*$.m21,
      @m20*$.m02+@m21*$.m12+@m22*$.m22,
    )

  compare: ($)->
    scale = 1<<16
    error = 7000000
    if ((abs((@m00/$.m00+$.m00/@m00)-2)*scale)|0) != 0 then error += 1
    if ((abs((@m01/$.m01+$.m01/@m01)-2)*scale)|0) != 0 then error += 5
    if ((abs((@m02/$.m02+$.m02/@m02)-2)*scale)|0) != 0 then error += 10
    if ((abs((@m10/$.m10+$.m10/@m10)-2)*scale)|0) != 0 then error += 50
    if ((abs((@m11/$.m11+$.m11/@m11)-2)*scale)|0) != 0 then error += 100
    if ((abs((@m12/$.m12+$.m12/@m12)-2)*scale)|0) != 0 then error += 500
    if ((abs((@m20/$.m20+$.m20/@m20)-2)*scale)|0) != 0 then error += 1000
    if ((abs((@m21/$.m21+$.m21/@m21)-2)*scale)|0) != 0 then error += 5000
    if ((abs((@m22/$.m22+$.m22/@m22)-2)*scale)|0) != 0 then error += 10000
    if error != 7000000
      console.log 'error'

  identity: ()->
    scale = 1<<16
    error = Math.max \
      abs((@m00-1)*scale)|0,
      abs((@m01-0)*scale)|0,
      abs((@m02-0)*scale)|0,
      abs((@m10-0)*scale)|0,
      abs((@m11-1)*scale)|0,
      abs((@m12-0)*scale)|0,
      abs((@m20-0)*scale)|0,
      abs((@m21-0)*scale)|0,
      abs((@m22-1)*scale)|0
    if error != 0
      console.log 'error'

module.exports = 
  gaussian: (context, opend, opper, sigma, border, count0, count1)->
    for offset in opper

      color = 0; scale = -1
      if offset < 0 then offset = -offset; color |= 4
      i0 = (offset%count0)|0; n0 = count0
      i1 = (offset/count0)|0; n1 = count1
      while n0 >= i0 and n1 >= i1
        n0 >>= 1; n1 >>= 1; scale += 1
      if i0 >= n0 then i0 -= n0; color |= 2
      if i1 >= n1 then i1 -= n1; color |= 1

      if i0 < border or i0 >= n0-border or 
         i1 < border or i1 >= n1-border
        continue
      
      offset0 = offset-count0; offset1 = offset; offset2 = offset+count0
      e00 = opend[offset0-1]; e01 = opend[offset0]; e02 = opend[offset0+1]
      e10 = opend[offset1-1]; e11 = opend[offset1]; e12 = opend[offset1+1]
      e20 = opend[offset2-1]; e21 = opend[offset2]; e22 = opend[offset2+1]

      x0 = 0#fround(i0<<scale)
      x1 = 0#fround(i1<<scale)
      s1_1 = fround(sigma*(1<<scale))
      s1_2 = fround(s1_1/2)
      s2_1 = fround(s1_1*s1_1)
      s2_4 = fround(s2_1/4)

      # taylerian: f(x) ~ x'[]f[,]x[]
      f00 = fround(s2_1*(e01+e21-e11-e11))
      f01 = fround(s2_4*(e00+e22-e02-e20))
      f11 = fround(s2_1*(e10+e12-e11-e11))
      f0  = fround(s1_2*(e21-e01))
      f1  = fround(s1_2*(e12-e10))
      f   = fround(e11)

      # gaussian: f(x) ~ exp(1/2 x'[]g[,]x[])
      norm = fround(1/(f*f))
      g00 = fround(norm*(f00*f-f0*f0))
      g01 = fround(norm*(f01*f-f0*f1))
      g11 = fround(norm*(f11*f-f1*f1))
      g0  = fround(f0/f-g00*x0-g01*x1)
      g1  = fround(f1/f-g01*x0-g11*x1)
      g   = fround(2*log(f)-(f0/f+g0)*x0-(f1/f+g1)*x1)

      # square root: g[,] = q'[,]h[,]q[,]
      $v  = g
      h   = fround(sign($v))
      q   = fround(sqrt(abs($v)))
      q0  = fround(g0*h/q)
      q1  = fround(g1*h/q)
      $v  = fround(g00-h*q0*q0)
      h00 = fround(sign($v))
      q00 = fround(sqrt(abs($v)))
      q01 = fround((g01-h*q0*q1)*h00/q00)
      $v  = fround(g11-h*q1*q1-h00*q01*q01)
      h11 = fround(sign($v))
      q11 = fround(sqrt(abs($v)))

      # inverse: p[,]q[,] = 1[,]
      norm = fround(1/(q*q00*q11))
      p   = fround(norm*(q00*q11))
      p0  = fround(norm*(-q0*q11))
      p1  = fround(norm*( q0*q01-q1*q00))
      p00 = fround(norm*(  q*q11))
      p01 = fround(norm*( -q*q01))
      p11 = fround(norm*(  q*q00))

      _i = new Matrix(1,0,0,0,1,0,0,0,1)
      _h = new Matrix(h,0,0,0,h00,0,0,0,h11)
      _f = new Matrix(f,f0,f1,f0,f00,f01,f1,f01,f11)
      _g = new Matrix(g,g0,g1,g0,g00,g01,g1,g01,g11)
      _q = new Matrix(q,q0,q1,0,q00,q01,0,0,q11)
      _p = new Matrix(p,p0,p1,0,p00,p01,0,0,p11)
      fn = (x0,x1)-> fround(exp(_g.norm(1,x0,x1)/2))
      console.log fround((fn(x0+1e-6,x1)-F)*1e6), f0
      if offset > 1<<16 then return

      F   = fn(x0,x1)
      F0  = fround((fn(x0+1e-6,x1)-F)*1e6)
      F1  = fround((fn(x0,x1+1e-6)-F)*1e6)
      F00 = fround((fn(x0+1e-4,x1)+fn(x0-1e-4,x1)-F-F)*1e8)
      F01 = fround((fn(x0+1e-4,x1+1e-4)+F-fn(x0+1e-4,x1)-fn(x0,x1+1e-4))*1e8)
      F11 = fround((fn(x0,x1+1e-4)+fn(x0,x1-1e-4)-F-F)*1e8)
      _F = new Matrix(F,F0,F1,F0,F00,F01,F1,F01,F11)

      #_F.compare(_f)
      #_q.transpose().multiply(_h).multiply(_q).compare(_g)
      #_p.multiply(_q).identity()

      # transformation-lize
      m00 = s1_1
      m10 = 0
      m01 = 0
      m11 = s1_1
      m0 = x0
      m1 = x1

      context.save()
      context.setTransform m00, m10, m01, m11, m0, m1

      context.beginPath()
      context.arc 0, 0, 1, 0, tau
      context.fillStyle = colorList[color]
      context.fill()

      context.restore()
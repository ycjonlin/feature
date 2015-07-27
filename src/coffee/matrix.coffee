
class Matrix3
  constructor: (
    @m00, @m01, @m02,
    @m10, @m11, @m12,
    @m20, @m21, @m22)->

  transpose: ()->
    new Matrix3(
      @m00, @m10, @m20,
      @m01, @m11, @m21,
      @m02, @m12, @m22,
    )

  norm: (x0, x1, x2)-> (
    @m00*x0*x0+@m01*x0*x1+@m02*x0*x2+
    @m10*x1*x0+@m11*x1*x1+@m12*x1*x2+
    @m20*x2*x0+@m21*x2*x1+@m22*x2*x2)

  multiply: ($)->
    new Matrix3(
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
    error = Math.max \
      (abs((@m00/$.m00+$.m00/@m00)-2)*scale)|0,
      (abs((@m01/$.m01+$.m01/@m01)-2)*scale)|0,
      (abs((@m02/$.m02+$.m02/@m02)-2)*scale)|0,
      (abs((@m10/$.m10+$.m10/@m10)-2)*scale)|0,
      (abs((@m11/$.m11+$.m11/@m11)-2)*scale)|0,
      (abs((@m12/$.m12+$.m12/@m12)-2)*scale)|0,
      (abs((@m20/$.m20+$.m20/@m20)-2)*scale)|0,
      (abs((@m21/$.m21+$.m21/@m21)-2)*scale)|0,
      (abs((@m22/$.m22+$.m22/@m22)-2)*scale)|0
    if error != 0
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

class Matrix2
  constructor: (
    @m00, @m01,
    @m10, @m11)->

  transpose: ()->
    new Matrix2(
      @m00, @m10,
      @m01, @m11,
    )

  norm: (x0, x1)-> (
    @m00*x0*x0+@m01*x0*x1+
    @m10*x1*x0+@m11*x1*x1)

  multiply: ($)->
    new Matrix2(
      @m00*$.m00+@m01*$.m10, @m00*$.m01+@m01*$.m11,
      @m10*$.m00+@m11*$.m10, @m10*$.m01+@m11*$.m11,
    )

  compare: ($)->
    scale = 1<<16
    error = Math.max \
      (abs((@m00/$.m00+$.m00/@m00)-2)*scale)|0,
      (abs((@m01/$.m01+$.m01/@m01)-2)*scale)|0,
      (abs((@m10/$.m10+$.m10/@m10)-2)*scale)|0,
      (abs((@m11/$.m11+$.m11/@m11)-2)*scale)|0
    if error != 0
      console.log 'error'

  identity: ()->
    scale = 1<<16
    error = Math.max \
      abs((@m00-1)*scale)|0,
      abs((@m01-0)*scale)|0,
      abs((@m10-0)*scale)|0,
      abs((@m11-1)*scale)|0
    if error != 0
      console.log 'error'

###
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

#_q.transpose().multiply(_h).multiply(_q).compare(_g)
#_p.multiply(_q).identity()

###

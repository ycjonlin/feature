Image = require './image'
Task = require('./library') require './task'

fround = Math.fround
sqrt = Math.sqrt
exp = Math.exp
pow = Math.pow
abs = Math.abs
atan2 = Math.atan2
ceil = Math.ceil
pi = Math.PI
tau = pi*2

erf = (x)->
  t = 1/(1+0.3275911*abs(x))
  y = 1-((((1.061405429*t-1.453152027)*t+1.421413741)*t-0.284496736)*t+0.254829592)*t*exp(-x*x)
  if x > 0 then y else -y

gaussian = (sigma)->
  length = ceil(sigma*6)|1
  radius = length/2
  kernel = new Float32Array(length)
  constant = 1/sqrt(tau)/sigma
  for i in [0..length-1]
    x0 = (i-radius)/sigma/sqrt(2)
    x1 = (i+1-radius)/sigma/sqrt(2)
    y = (erf(x1)-erf(x0))/2
    kernel[i] = y
  kernel

newCanvas = (width, height)->
  canvas = document.createElement('canvas')
  context = canvas.getContext('2d')
  canvas.width = width
  canvas.height = height
  results = document.getElementById('results')
  results.appendChild canvas
  context

alpha = 1/16
colorList = [
  null,
  'rgba(255,0,0,'+alpha+')',
  'rgba(0,255,0,'+alpha+')',
  'rgba(0,0,255,'+alpha+')',
  null,
  'rgba(0,255,255,'+alpha+')',
  'rgba(255,0,255,'+alpha+')',
  'rgba(255,255,0,'+alpha+')',
]

url = 'https://farm4.staticflickr.com/3755/19651424679_aa20a63dba_b.jpg'
console.log url
Image.load url, (imageData)->
  image = Image.extract imageData
  size = image.length
  width = imageData.width
  height = imageData.height

  levels = 2
  sigmaList = (pow(2, 1+(level-1)/levels) for level in [0..levels+1])
  kernelList = (gaussian(sigmaList[level]) for level in [0..levels+1])
  imageList = (null for level in [0..levels+1])

  Task.__barrier__ null
  for level in [0..levels+1]
    context = newCanvas width, height
    Task.convolute [kernelList[level], image, width, height],
      [level, context], (image, [level, context])->
        imageData = Image.compact image, context, width, height
        context.putImageData imageData, 0, 0
        imageList[level] = image
  Task.__barrier__ null
  for method in ['trace', 'determinant', 'gaussian']
    context = newCanvas width, height
    Task.feature [method, imageList, kernelList, sigmaList, width, height],
      context, (keypoints, context)->
        console.log keypoints.length/6
        context.globalCompositeOperation = 'multiply'
        for offset in [0..keypoints.length-1] by 6

          g00 = keypoints[offset+0]
          g01 = keypoints[offset+1]
          g11 = keypoints[offset+2]
          g0  = keypoints[offset+3]
          g1  = keypoints[offset+4]
          g   = keypoints[offset+5]

          trc = (g00+g11)/2
          det = g00*g11-g01*g01
          dif = sqrt(trc*trc-det)
          l0 = trc-dif
          l1 = trc+dif

          norm = fround(1/(g01*g01-g00*g11))
          u0 = fround(norm*(g0*g11-g1*g01))
          u1 = fround(norm*(g1*g00-g0*g01))
          th = atan2(-g01-g01, g00-g11)/2
          lg = sqrt(abs(l0*l1))
          r0 = sqrt(abs(lg/l0))
          r1 = sqrt(abs(lg/l1))

          context.save()
          context.translate u0, u1
          context.rotate th
          context.scale r0, r1
          context.beginPath()
          context.arc 0, 0, 2, 0, tau
          context.fillStyle = colorList[0]
          context.fill()
          context.restore()

  Task.__barrier__ null

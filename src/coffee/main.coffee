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

url = 'https://farm1.staticflickr.com/363/19779866589_a6b28069ef_n.jpg'
Image.load url, (imageData)->
  image = Image.extract imageData
  size = image.length
  width = imageData.width
  height = imageData.height

  levels = 4
  sigmaList = (pow(2, 1+(level-1)/levels) for level in [0..levels+1])
  kernelList = (gaussian(sigmaList[level]) for level in [0..levels+1])
  imageList = (null for level in [0..levels+1])

  Task.__barrier__ null
  for level in [0..levels+1]
    Task.convolute [kernelList[level], image, width, height], level, (image, level)->
      imageList[level] = image
  Task.__barrier__ null
  for method in ['trace', 'determinant', 'gaussian']
    canvas = document.createElement('canvas')
    context = canvas.getContext('2d')
    canvas.width = width
    canvas.height = height
    results = document.getElementById('results')
    results.appendChild canvas
    Task.feature [method, imageList, kernelList, sigmaList, width, height], context, (keypoints, context)->
      context.globalCompositeOperation = 'multiply'
      for offset in [0..keypoints.length-1] by 6

        u0 = keypoints[offset+0]
        u1 = keypoints[offset+1]
        t = keypoints[offset+2]
        r0 = keypoints[offset+3]
        r1 = keypoints[offset+4]
        color = keypoints[offset+5]|0

        context.save()
        context.translate u0, u1
        context.rotate t
        context.scale r0, r1
        context.beginPath()
        context.arc 0, 0, 1, 0, tau
        context.fillStyle = colorList[color]
        context.fill()
        context.restore()

  Task.__barrier__ null

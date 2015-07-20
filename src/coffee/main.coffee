Image = require './image'
Surface = require './surface'
Measure = require './measure'
Suppress = require './suppress'

fround = Math.fround
sqrt = Math.sqrt
exp = Math.exp
abs = Math.abs
ceil = Math.ceil
pow = Math.pow
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

element = (surface, width, height)->
  canvas = document.createElement("canvas")
  context = canvas.getContext("2d")
  imageData = Image.compact surface, context, width, height
  canvas.width = imageData.width
  canvas.height = imageData.height
  context.putImageData imageData, 0, 0
  canvas

(()->
  Image.load 'https://farm1.staticflickr.com/194/505494059_426290217e.jpg', (imageData)->

    width = imageData.width
    height = imageData.height

    levels = 4
    sigmaList = (pow(2, 1+(level-1)/levels) for level in [0..levels+1])
    kernelList = (gaussian(sigmaList[level]) for level in [0..levels+1])

    surface0 = Image.extract imageData
    surface1 = new Float32Array(surface0.length)
    blurList = (new Float32Array(surface0.length) for level in [0..levels+1])
    measureList = (new Float32Array(surface0.length) for level in [0..levels+1])
    keypointList = (new Int32Array(surface0.length>>4) for level in [0..levels+1])

    for level in [0..levels+1]
      kernel = kernelList[level]
      radius = kernel.length>>1
      console.log level, kernel.length

      surface = blurList[level].subarray(radius*(width*2+1))
      Surface.convolute surface1, surface0, kernel, 
        height*2-radius*2, width*2, width*2, 1, kernel.length, width*2
      Surface.convolute surface, surface1, kernel, 
        height*2-radius*2, width*2, width*2-radius*2, 1, kernel.length, 1


    for name, measure of Measure

      console.log '---', name

      for level in [0..levels+1]
        measure measureList[level], blurList[level], sigmaList[level], 
          height*2, width*2, width*2, 1

      for level in [1..levels]
        total = Suppress.neighbor_26 keypointList[level],
          measureList[level-1], measureList[level], measureList[level+1], 
          height*2, width*2, width*2, 1
        console.log level, total

      page = document.getElementsByClassName("page")[0]
      div = document.createElement("div")
      div.className = 'container'
      for level in [0..levels]
        div.appendChild element(measureList[level], width, height)
      page.appendChild div
)()

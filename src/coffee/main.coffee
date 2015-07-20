Image = require './image'

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

(()->
  Image.load 'https://farm1.staticflickr.com/194/505494059_426290217e.jpg', (imageData)->

    width = imageData.width
    height = imageData.height

    levels = 4
    sigmaList = (pow(2, 1+level/levels) for level in [0..levels])
    kernelList = (gaussian(sigmaList[level]) for level in [0..levels])

    array0 = Image.split imageData
    array1 = new Float32Array(array0.length)
    blurList = (new Float32Array(array0.length) for level in [0..levels])
    measureList = (new Float32Array(array0.length) for level in [0..levels])

    for level in [0..levels]
      kernel = kernelList[level]
      radius = kernel.length>>1
      console.log level, kernel.length

      array = blurList[level].subarray(radius*(width*2+1))
      array_convolute array1, array0, kernel, 
        height*2-radius*2, width*2, width*2, 1, kernel.length, width*2
      array_convolute array, array1, kernel, 
        height*2-radius*2, width*2, width*2-radius*2, 1, kernel.length, 1


    for measure in [measure_constant, measure_trace, measure_determinant, measure_gaussian]

      console.log '---'

      for level in [0..levels]
        measure measureList[level], blurList[level], sigmaList[level], 
          height*2, width*2, width*2, 1

      for level in [1..levels-1]
        total = suppress_6_neighbor null,
          measureList[level-1], measureList[level], measureList[level+1], 
          height*2, width*2, width*2, 1
        console.log level, total

      for level in [1..levels-1]
        total = suppress_18_neighbor null,
          measureList[level-1], measureList[level], measureList[level+1], 
          height*2, width*2, width*2, 1
        console.log level, total

      for level in [1..levels-1]
        total = suppress_26_neighbor null,
          measureList[level-1], measureList[level], measureList[level+1], 
          height*2, width*2, width*2, 1
        console.log level, total

      page = document.getElementsByClassName("page")[0]
      div = document.createElement("div")
      div.className = 'container'
      for level in [0..levels]
        div.appendChild image_element(measureList[level], width, height)
      page.appendChild div
)()

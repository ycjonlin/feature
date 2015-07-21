Image = require './image'
Surface = require './surface'
Measure = require './measure'
Suppress = require './suppress'

fround = Math.fround
sqrt = Math.sqrt
exp = Math.exp
log = Math.log
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

    count1 = height*2
    count0 = width*2

    levels = 4
    sigmaList = (pow(2, 1+(level-1)/levels) for level in [0..levels+1])
    kernelList = (gaussian(sigmaList[level]) for level in [0..levels+1])

    surface0 = Image.extract imageData
    surface1 = new Float32Array(surface0.length)
    surfaceList = (new Float32Array(surface0.length) for level in [0..levels+1])
    measureList = (new Float32Array(surface0.length) for level in [0..levels+1])
    extremeList = (new Int32Array(surface0.length>>4) for level in [0..levels+1])
    countList = (0 for level in [0..levels+1])

    for level in [0..levels+1]
      kernel = kernelList[level]
      radius = kernel.length>>1
      console.log level, kernel.length

      surface = surfaceList[level].subarray(radius*(count0+1))
      Surface.convolute surface1, surface0, kernel, 
        count1-radius*2, count0, count0, 1, kernel.length, count0
      Surface.convolute surface, surface1, kernel, 
        count1-radius*2, count0, count0-radius*2, 1, kernel.length, 1

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

    for name, measure of Measure
      console.log name

      for level in [0..levels+1]
        measure measureList[level], surfaceList[level], sigmaList[level], 
          count1, count0, count0, 1

      for level in [1..levels]
        countList[level] = Suppress.neighbor_18 extremeList[level],
          measureList[level-1], measureList[level], measureList[level+1], 
          count1, count0, count0, 1
        console.log level, countList[level]

      canvas = document.createElement("canvas")
      canvas.width = width
      canvas.height = height

      context = canvas.getContext("2d")
      context.globalCompositeOperation = "multiply"

      for level in [0..levels]
        continue if countList[level] == 0
        surface = surfaceList[level]
        extreme = extremeList[level]
        border = (kernelList[level].length>>1)+1
        sigma = sigmaList[level]

        s1_2 = fround(sigma/2)
        s2_1 = fround(sigma*sigma)
        s2_4 = fround(sigma*sigma/4)

        for index in [0..countList[level]-1]
          k = extreme[index]

          color = 0; scale = -1
          if k < 0 then k = -k; color |= 4
          i0 = (k%count0)|0; n0 = count0
          i1 = (k/count0)|0; n1 = count1
          while n0 >= i0 and n1 >= i1
            n0 >>= 1; n1 >>= 1; scale += 1
          if i0 >= n0 then i0 -= n0; color |= 2
          if i1 >= n1 then i1 -= n1; color |= 1

          if i0 < border or i0 >= n0-border or 
             i1 < border or i1 >= n1-border
            continue

          i0 <<= scale
          i1 <<= scale
          ###
          k0 = k-i_count; k1 = k; k2 = k+i_count
          e00 = surface[k0-1]; e01 = surface[k0]; e02 = surface[k0+1]
          e10 = surface[k1-1]; e11 = surface[k1]; e12 = surface[k1+1]
          e20 = surface[k2-1]; e21 = surface[k2]; e22 = surface[k2+1]

          f00 = fround(s2_1*(e01+e21-e11-e11))
          f01 = fround(s2_4*(e00+e22-e02-e20))
          f11 = fround(s2_1*(e10+e12-e11-e11))
          f0  = fround(s1_2*(e21-e01))
          f1  = fround(s1_2*(e12-e10))
          f   = e11

          norm = 1/(f*f)
          g00 = (f00*f-f0*f0)*norm
          g01 = (f01*f-f0*f1)*norm
          g11 = (f11*f-f1*f1)*norm
          g0  = (f0/f-g00*i0-g01*i1)
          g1  = (f1/f-g01*i0-g11*i1)
          g   = 2*log(f)-(f0/f-g0)*i0-(f1/f-g1)*i1
          ###
          h00 = 1<<scale
          h01 = 0
          h10 = 0
          h11 = 1<<scale
          h0  = i0
          h1  = i1

          context.beginPath()
          context.setTransform h00, h01, h0, h10, h11, h1
          context.arc 0, 0, 2, 0, tau
          context.fillStyle = colorList[color]
          context.fill()

      page = document.getElementsByClassName("page")[0]
      slide = document.createElement("div")
      slide.className = 'slide'
      container = document.createElement("div")
      container.className = 'container'
      page.appendChild slide
      slide.appendChild container
      container.appendChild canvas
)()

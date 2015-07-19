###
sigma = 2
kernel = new Float32Array(Math.ceil(sigma*8)|1)
radius = (kernel.length-1)/2
for i in [0..kernel.length-1]
  x = (i-radius)/sigma
  kernel[i] = Math.exp(-x*x/2)

feature = require('./nacl') 'feature', 'nacl/feature.nmf', (data)->
  url = 'https://farm1.staticflickr.com/194/505494059_ed850a8b0a_o_d.jpg'
  feature.image_import [url], (image)->
    feature.split_cie_xyz [url], (raw)->
      feature.image_export [raw, image.width, image.height], (data)->
        canvas = document.createElement "canvas"
        canvas.width = image.width
        canvas.height = image.height

        context = canvas.getContext "2d"
        imageData = context.createImageData image.width, image.height
        pixel = imageData.data
        for i in [0..data.length-1]
          pixel[i] = data[i]
        context.putImageData(imageData, 0, 0)

        document.appendChild(canvas)

      args = [array, kernel, image.height*2, image.width*2, image.width*2, 1, kernel.length, 1]
      feature.calculus_convolute args, (array_u)->
        args = [array_u, kernel, image.height*2, image.width*2, image.width*2, 1, kernel.length, image.width*2]
        feature.calculus_convolute args, (array_uv)->
###

(()->
  url = 'https://farm1.staticflickr.com/194/505494059_ed850a8b0a_o_d.jpg'

  image = new Image
  canvas = document.createElement("canvas")
  document.body.appendChild(canvas)
  context = canvas.getContext("2d")

  image.crossOrigin = "Anonymous"

  image.onload = ()->
    canvas.width = image.width
    canvas.height = image.height
    context.drawImage(image, 0, 0)
  image.src = url
)()

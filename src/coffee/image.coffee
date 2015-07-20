
image_load = (url, callback)->
  image = new Image
  image.crossOrigin = "Anonymous"
  image.onload = (event)->
    canvas = document.createElement("canvas")
    canvas.width = image.width
    canvas.height = image.height
    context = canvas.getContext "2d"
    context.drawImage image, 0, 0
    imageData = context.getImageData 0, 0, image.width, image.height
    callback imageData
    null
  image.src = url
  null

image_split = (image)->
  array = new Float32Array(image.width * image.height * 4)
  width = image.width
  height = image.height
  stribe = width * 2
  halfpage = height * stribe
  array_diverge array, image.data, 
    width, halfpage, width+halfpage, 
    height, stribe, width, 1
  while width >= 1 and height >= 1
    array_downsize array, array,
      height, stribe, width, 1
    width >>= 1; height >>= 1
  array

image_merge = (array, context, width, height)->
  image = context.createImageData width, height
  size = width * height
  array_converge image.data, array, 
    width, size*2, width+size*2, 
    height, width*2, width, 1
  image

image_press = (array, context, width, height)->
  image = context.createImageData width*2, height*2
  size = width * height
  array_flatten image.data, array, 
    height*2, width*2, width*2, 1
  image

image_element = (array, width, height)->
  canvas = document.createElement("canvas")
  context = canvas.getContext("2d")
  imageData = image_merge array, context, width, height
  canvas.width = imageData.width
  canvas.height = imageData.height
  context.putImageData imageData, 0, 0
  canvas

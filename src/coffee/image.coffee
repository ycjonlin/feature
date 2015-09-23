# Image library provides functions that retrieve and manipulate ImageData object.

Surface = require './surface'

module.exports =

  # load
  # --
  # Load image data from a url address. Turn it into an ImageData object.
  # Then, send it to a callback function.

  load: (url, callback)->
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

  # extract
  # --
  # Convert a ImageData object into a 4-times-as-big Float32Array object.
  # For more detail, see Surface.extract() and Surface.downsize().

  extract: (image, x, y, width, height)->
    array = new Float32Array(width*height*4)
    size = width*height
    Surface.extract \
      array.subarray(width),
      array.subarray(size*2),
      array.subarray(width+size*2),
      image.data,
      height, width*2, width, 1
    stride = width*2
    while width >= 1 and height >= 1
      Surface.downsize array, array,
        height, stride, width, 1
      width >>= 1; height >>= 1
    array

  # compact
  # --
  # Map the 3 major color planes of a Float32Array object into 3 color channels of a 1/4-sized ImageData object.
  # For more detail, see Surface.compact().

  compact: (array, context, width, height)->
    image = context.createImageData width, height
    size = width*height
    Surface.compact \
      image.data,
      array.subarray(width),
      array.subarray(size*2),
      array.subarray(width+size*2),
      height, width*2, width, 1
    image

  # flatten
  # --
  # Map a Float32Array object into a same-sized grayscale ImageData object.
  # For more detail, see Surface.flatten().

  flatten: (array, context, width, height)->
    image = context.createImageData width*2, height*2
    size = width * height
    Surface.flatten image.data, array,
      height*2, width*2, width*2, 1
    image

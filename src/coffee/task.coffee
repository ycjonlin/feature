Surface = require './surface'
Measure = require './measure'
Suppress = require './suppress'
Feature = require './feature'

module.exports =
  convolute: (kernel, image, width, height)->
    count1 = height*2
    count0 = width*2
    radius = kernel.length>>1
    image0 = image
    image1 = new Float32Array(image.length)
    image2 = new Float32Array(image.length)

    Surface.convolute image1, image0, kernel,
      count1-radius*2, count0, count0, 1, kernel.length, count0
    Surface.convolute image2.subarray((count0+1)*radius), image1, kernel,
      count1-radius*2, count0, count0-radius*2, 1, kernel.length, 1

    image2

  feature: (method, imageList, kernelList, sigmaList, width, height)->
    count1 = height*2
    count0 = width*2
    levels = imageList.length-2
    size = imageList[0].length

    # measure
    measureList = (new Float32Array(size) for level in [0..levels+1])
    for level in [0..levels+1]
      measure = measureList[level]
      image = imageList[level]
      sigma = sigmaList[level]
      Measure[method] measure, image, sigma, count1, count0, count0, 1

    # suppress
    countTotal = 0
    countList = (0 for level in [0..levels])
    extremeList = (new Int32Array(size>>2) for level in [0..levels])
    for level in [1..levels]
      measure0 = measureList[level-1]
      measure1 = measureList[level]
      measure2 = measureList[level+1]
      extreme = extremeList[level]
      border = (kernelList[level].length>>1)+1
      count = Suppress.neighbor_6 extreme,
        measure0, measure1, measure2, border, count1, count0, count0, 1
      countTotal += count
      countList[level] = count

    # describe
    featureList = new Float32Array(countTotal*3)
    feature = featureList
    for level in [0..levels]
      continue if countList[level] == 0
      image = imageList[level]
      extreme = extremeList[level].subarray(0, countList[level])
      border = (kernelList[level].length>>1)+1
      sigma = sigmaList[level]
      offset = Feature.gaussian feature,
        image, extreme, sigma, border, count0, count1
      feature = feature.subarray(offset)

    featureList.subarray(0, featureList.length-feature.length)

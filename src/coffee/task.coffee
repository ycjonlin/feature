Surface = require './surface'
Measure = require './measure'
Extreme = require './extreme'
Feature = require './feature'
Match = require './match'

colorList = [0..5]

module.exports =

  # convolute
  # --
  # Convolute a Float32Array object with a Float32Array kernel both lengthwise and crosswise.
  # Return a new Float32Array with result. For more detail, see Surface.convolute().

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


  # detect
  # --
  # Detect keypoints from 3 consective Float32Array objects of a filter pyramid.

  detect: (method, imageList, kernelList, sigmaList, width, height)->
    count1 = height*2
    count0 = width*2
    size   = imageList[0].length
    levels = imageList.length-1
    levelListWithoutCeiling = [1..levels-1]
    levelListWithCeiling = [0..levels]
    borderList = ((kernel.length>>1)+1 for kernel in kernelList)

    #### surface measurement
    # Use the specified measuring function
    measureList = []
    for level in levelListWithCeiling
      measure = new Float32Array(size)
      image   = imageList[level]
      sigma   = sigmaList[level]
      Measure[method] measure, image, sigma, count1, count0, count0, 1
      measureList.push measure

    #### non-extremum suppression
    extremeListList = []
    extremeOffsetListList = []
    extremeOffsetTotalList = (0 for color in colorList)
    for level in levelListWithoutCeiling
      extremeList = (new Int32Array(size>>4) for color in colorList)
      measure0    = measureList[if level == 0 then 1 else level-1]
      measure1    = measureList[level]
      measure2    = measureList[level+1]
      border      = borderList[level]
      offsetList  = Extreme.neighbor_6 extremeList, measure0, measure1, measure2, border, count1, count0, count0, 1
      extremeListList[level] = extremeList
      extremeOffsetListList[level] = offsetList
      for color in colorList
        extremeOffsetTotalList[color] += offsetList[color]

    #### keypoint description
    featureList = (new Float32Array(extremeOffsetTotalList[color]*3) for color in colorList)
    for color in colorList
      feature = featureList[color]
      for level in levelListWithoutCeiling
        image   = imageList[level]
        border  = borderList[level]
        extreme = extremeListList[level][color].subarray(0, extremeOffsetListList[level][color])
        offset  = Feature.gaussian feature, image, extreme, count0, count1
        feature = feature.subarray(offset)
      featureList[color] = featureList[color].subarray(0, featureList[color].length-feature.length)
    featureList


  # match
  # --
  # Match keypoints from 2 Float32Array objects.
  match: (keypoint0, keypoint1)->
    partition0 = Match.partition keypoint0
    partition1 = Match.partition keypoint1
    match = Match.match partition0, partition1

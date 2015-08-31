Surface = require './surface'
Measure = require './measure'
Extreme = require './extreme'
Feature = require './feature'

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


  # feature
  # --
  # Retrieve feature points from an Float32Array sandwidth slice of an filter pyramid.
  
  feature: (method, imageList, kernelList, sigmaList, width, height)->
    count1 = height*2
    count0 = width*2
    size   = imageList[0].length
    levels = imageList.length-1
    levelListWithoutTop = [0..levels-1]
    levelListWithTop = [0..levels]
    borderList = ((kernel.length>>1)+1 for kernel in kernelList)

    #### surface measurement
    # Use the specified measuring function
    measureList = []
    for level in levelListWithTop
      measure = new Float32Array(size)
      image   = imageList[level]
      sigma   = sigmaList[level]
      Measure[method] measure, image, sigma, count1, count0, count0, 1
      measureList.push measure

    #### non-extremum suppression
    extremeListList = []
    extremeOffsetListList = []  
    extremeOffsetTotalList = (0 for color in colorList)
    for level in levelListWithoutTop
      extremeList = (new Int32Array(size>>4) for color in colorList)
      measure0    = measureList[if level == 0 then 1 else level-1]
      measure1    = measureList[level]
      measure2    = measureList[level+1]
      border      = borderList[level]
      offsetList  = Extreme.neighbor_6 extremeList, measure0, measure1, measure2, border, count1, count0, count0, 1
      extremeOffsetListList[level] = offsetList
      for color in colorList
        extremeOffsetTotalList[color] += offsetList[color]

    #### keypoint description
    featureList = (new Float32Array(extremeOffsetTotalList[color]*3) for color in colorList)
    for level in levelListWithoutTop
      image  = imageList[level]
      border = borderList[level]
      for color in colorList
        extreme = extremeList[level][color].subarray(0, extremeCountList[level][color])
        feature = featureList[color]
        offset  = Feature.gaussian feature, image, extreme, count0, count1
        featureList[color] = feature.subarray(offset)
    for feature, color in featureList
      feature.subarray(0, featureList.length-feature.length)

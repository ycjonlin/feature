describe 'Surface', ->

  Surface = require '../../src/coffee/surface'

  surfaceTestData = require '../data/surfaceTestData'

  testWidth = surfaceTestData.constant.width
  testHeight = surfaceTestData.constant.height
  testSize = surfaceTestData.constant.size
  testKernelSize = surfaceTestData.constant.kernelSize

  describe '.extract', -> it 'should ...', ->

    testBefore = surfaceTestData.data[surfaceTestData.test.extract.before]
    testAfter = surfaceTestData.data[surfaceTestData.test.extract.after]

    before = new Uint8ClampedArray(testBefore)
    after = new Float32Array(testAfter.length)
    Surface.extract \
      after.subarray(testWidth),
      after.subarray(testSize*2),
      after.subarray(testSize*2+testWidth),
      before,
      testHeight, testWidth*2, testWidth, 1

    expect(Array.prototype.slice.call after).toEqual(testAfter)

  describe '.compact', -> it 'should ...', ->

    testBefore = surfaceTestData.data[surfaceTestData.test.compact.before]
    testAfter = surfaceTestData.data[surfaceTestData.test.compact.after]

    before = new Float32Array(testBefore)
    after = new Uint8ClampedArray(testAfter.length)
    Surface.compact \
      after,
      before.subarray(testWidth),
      before.subarray(testSize*2),
      before.subarray(testSize*2+testWidth),
      testHeight, testWidth*2, testWidth, 1

    expect(Array.prototype.slice.call after).toEqual(testAfter)

  describe '.flatten', -> it 'should ...', ->

    testBefore = surfaceTestData.data[surfaceTestData.test.flatten.before]
    testAfter = surfaceTestData.data[surfaceTestData.test.flatten.after]

    before = new Float32Array(testBefore)
    after = new Uint8ClampedArray(testAfter.length)
    Surface.flatten after, before,
      testHeight*2, testWidth*2, testWidth*2, 1

    expect(Array.prototype.slice.call after).toEqual(testAfter)

  describe '.downsize', -> it 'should ...', ->

    testBefore = surfaceTestData.data[surfaceTestData.test.downsize.before]
    testAfter = surfaceTestData.data[surfaceTestData.test.downsize.after]

    after = new Float32Array(testBefore)
    width = testWidth
    height = testHeight

    while width >= 1 and height >= 1
      Surface.downsize after, after,
        height, testWidth*2, width, 1
      width >>= 1; height >>= 1

    expect(Array.prototype.slice.call after).toEqual(testAfter)
  
  describe '.convolute', -> it 'should ...', ->

    testBefore = surfaceTestData.data[surfaceTestData.test.convolute.before]
    testAfter = surfaceTestData.data[surfaceTestData.test.convolute.after]
    testKernel = surfaceTestData.data[surfaceTestData.test.convolute.kernel]
    testRadius = testKernelSize>>1

    during = new Float32Array(testBefore)
    after = new Float32Array(testBefore)
    kernel = new Float32Array(testKernel)
    Surface.convolute during, after, kernel, 
      (testHeight-testRadius)*2, testWidth*2, testWidth*2, 1, testKernelSize, testWidth*2
    Surface.convolute after, during, kernel, 
      (testHeight-testRadius)*2, testWidth*2, (testWidth-testRadius)*2, 1, testKernelSize, 1

    expect(Array.prototype.slice.call after).toEqual(testAfter)


describe 'Measure', ->

  Measure = require '../../src/coffee/measure'

  measureTestData = require '../data/measureTestData'

  testWidth = measureTestData.constant.width
  testHeight = measureTestData.constant.height
  testSigma = measureTestData.constant.sigma
  
  describe '.trace', -> it 'should ...', ->

    testBefore = measureTestData.data[measureTestData.test.trace.before]
    testAfter = measureTestData.data[measureTestData.test.trace.after]

    before = new Float32Array(testBefore)
    after = new Float32Array(testAfter.length)
    Measure.trace after, before,
      testSigma, testHeight, testWidth, testWidth, 1

    expect(Array.prototype.slice.call after).toEqual(testAfter)
  
  describe '.determinant', -> it 'should ...', ->

    testBefore = measureTestData.data[measureTestData.test.determinant.before]
    testAfter = measureTestData.data[measureTestData.test.determinant.after]

    before = new Float32Array(testBefore)
    after = new Float32Array(testAfter.length)
    Measure.determinant after, before,
      testSigma, testHeight, testWidth, testWidth, 1

    expect(Array.prototype.slice.call after).toEqual(testAfter)
  
  describe '.gaussian', -> it 'should ...', ->

    testBefore = measureTestData.data[measureTestData.test.gaussian.before]
    testAfter = measureTestData.data[measureTestData.test.gaussian.after]

    before = new Float32Array(testBefore)
    after = new Float32Array(testAfter.length)
    Measure.gaussian after, before,
      testSigma, testHeight, testWidth, testWidth, 1

    expect(Array.prototype.slice.call after).toEqual(testAfter)


describe 'Extreme', ->

  Extreme = require '../../src/coffee/extreme'

  describe '.neighbor_6', -> it 'should ...', ->
  
  describe '.neighbor_18', -> it 'should ...', ->


describe 'Feature', ->

  Feature = require '../../src/coffee/feature'

  describe '.gaussian', -> it 'should ...', ->
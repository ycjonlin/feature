describe 'Surface', ->

  Surface = require '../../src/coffee/surface'

  surfaceTestData = require '../data/surfaceTestData'

  testWidth = surfaceTestData.constant.width
  testHeight = surfaceTestData.constant.height
  testSize = surfaceTestData.constant.size
  testKernelSize = surfaceTestData.constant.kernelSize

  describe '.extract', ->

    it 'should ...', ->

      testBefore = surfaceTestData.data[surfaceTestData.test.extract.before]
      testAfter = surfaceTestData.data[surfaceTestData.test.extract.after]

      before = new Uint8Array(testBefore)
      after = new Float32Array(testAfter.length)
      Surface.extract \
        after.subarray(testWidth),
        after.subarray(testSize*2),
        after.subarray(testSize*2+testWidth), 
        before,
        testHeight, testWidth*2, testWidth, 1

      expect(Array.prototype.slice.call after).toEqual(testAfter)

  ###
  describe '.compact', ->
    it 'should ...', ->
      expect(true).toBe(true)
  describe '.flatten', ->
    it 'should ...', ->
      expect(true).toBe(true)
  ###

  describe '.downsize', ->

    it 'should ...', ->

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
  ###
  describe '.convolute', ->

    it 'should ...', ->

      testBefore = surfaceTestData.data[surfaceTestData.test.convolute.before]
      testAfter = surfaceTestData.data[surfaceTestData.test.convolute.after]
      testKernel = surfaceTestData.data[surfaceTestData.test.convolute.kernel]
      testRadius = testKernelSize>>1

      before = new Float32Array(testBefore)
      kernel = new Float32Array(testKernel)
      after = new Float32Array(testBefore.length)
      Surface.extract after, before, kernel, 
        (testHeight-testRadius)*2, testWidth*2, testWidth*2, 1, testKernelSize, testWidth*2
      Surface.extract after, before, kernel, 
        (testHeight-testRadius)*2, testWidth*2, (testWidth-testRadius)*2, 1, testKernelSize, 1

      expect(Array.prototype.slice.call after).toEqual(testAfter)
  ###
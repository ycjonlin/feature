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
  describe '.downsize', ->
    it 'should ...', ->
      expect(true).toBe(true)
  ###
  describe '.convolute', ->

    it 'should ...', ->

      testBefore = surfaceTestData.data[surfaceTestData.test.extract.before]
      testKernel = surfaceTestData.data[surfaceTestData.test.extract.kernel]
      testAfter = surfaceTestData.data[surfaceTestData.test.extract.after]

      before = new Uint8Array(testBefore)
      kernel = new Float32Array(testKernel)
      after = new Float32Array(testBefore.length)
      Surface.extract \
        after.subarray(testWidth),
        after.subarray(testSize*2),
        after.subarray(testSize*2+testWidth), 
        before,
        testHeight, testWidth*2, testWidth, 1

      expect(Array.prototype.slice.call after).toEqual(testAfter)

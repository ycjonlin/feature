describe 'Surface', ->

  Surface = require '../../src/coffee/surface'

  surfaceTestData = require '../data/surfaceTestData'

  testWidth = surfaceTestData.width
  testHeight = surfaceTestData.height
  testSize = surfaceTestData.size
  testKernelSize = surfaceTestData.kernelSize

  describe '.extract', ->

    it 'should do its thing', ->

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
  describe '.convolute', ->
    it 'should ...', ->
      expect(true).toBe(true)
  ###

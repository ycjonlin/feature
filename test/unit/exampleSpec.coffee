Surface = require '../../src/coffee/surface'

imageData = {}

describe 'Surface', ->
  describe '.extract', ->
    it 'should do its thing', ->
      size = imageData.width*imageData.height
      image = new Uint8Array(imageData.data)
      surface = new Float32Array(size*4)
      Surface.extract \
        surface.subarray(imageData.width),
        surface.subarray(size*2),
        surface.subarray(size*2+imageData.width), 
        imageData,
        imageData.height, imageData.width*2, imageData.width, 1
      console.log surface
      expect(true).toBe(true)
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

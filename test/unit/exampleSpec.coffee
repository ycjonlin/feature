Surface = require '../../src/coffee/surface'

imageData = require '../data/imageData'

describe 'Surface', ->
  describe '.extract', ->
    it 'should do its thing', ->
      image = new Uint8Array(imageData.data)
      surface = new Float32Array(imageData.size*4)
      Surface.extract \
        surface.subarray(imageData.width),
        surface.subarray(imageData.size*2),
        surface.subarray(imageData.size*2+imageData.width), 
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

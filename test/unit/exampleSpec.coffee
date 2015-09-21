Surface = require '../../src/coffee/surface'

imageData = require '../data/imageData'

describe 'Surface', ->
  describe '.extract', ->
    it 'should do its thing', ->
      size = imageData.width*imageData.height
      image = new Uint8ClampArray(imageData.data)
      surface = new Float32Array(size*4)
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

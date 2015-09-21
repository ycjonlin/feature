Surface = require '../../src/coffee/surface'

imageData = require '../data/imageData'

describe 'Surface', ->
  describe '.extract', ->
    it 'should do its thing', ->
      image = new Uint8ClampArray(imageData.data)
      surface = new Float32Array()
      Surface.extract(, imageData)
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

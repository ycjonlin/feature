Surface = require '../../src/coffee/surface'

imageData = require '../data/imageData'

describe 'Surface', ->
  describe '.extract', ->
    it 'should do its thing', ->
      extractedData = new Array(imageData.size*4)
      Surface.extract \
        extractedData.subarray(imageData.width),
        extractedData.subarray(imageData.size*2),
        extractedData.subarray(imageData.size*2+imageData.width), 
        imageData.data,
        imageData.height, imageData.width*2, imageData.width, 1
      expect(extractedData).toBe(imageData.extractedData)
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

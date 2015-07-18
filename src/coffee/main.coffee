feature = require('./nacl') 'feature', 'nacl/feature.nmf', ()->
  dst = new ArrayBuffer(32)
  src = new ArrayBuffer(32)
  feature.array_integral dst, src, 1, 1, 1, 1
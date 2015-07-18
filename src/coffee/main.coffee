feature = require('./nacl') 'feature', 'nacl/feature.nmf', ()->
  console.log feature
  dst = new ArrayBuffer(32)
  src = new ArrayBuffer(32)
  feature.array_integral dst, src, 1, 1, 1, 1
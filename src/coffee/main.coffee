feature = require('./nacl') 'feature', 'nacl/feature.nmf', ()->
  console.log feature
  dst = new Float32Array(32)
  src = new Float32Array(32)
  for i in [0..31]
    src[i] = i
  feature.array_integral [dst.buffer, src.buffer, 1, 32, 32, 1]
  console.log src
  console.log dst
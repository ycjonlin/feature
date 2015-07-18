feature = require('./nacl') 'feature', 'nacl/feature.nmf', (data)->
  console.log feature
  dst = new Float32Array(16)
  src = new Float32Array(16)
  for i in [0..15]
    src[i] = i
  feature.array_integral [dst.buffer, src.buffer, 4, 4, 4, 1], (data)->
    console.log data
    console.log src
    console.log dst
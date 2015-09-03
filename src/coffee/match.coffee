module.exports = 

  # partition
  # --
  # Partition

  partition: (oppum, scale, translate)->
    totalBucket = new Int32Array()
    indexBucket = new Int32Array()

    s   = scale[0]
    s0  = scale[1]
    s1  = scale[2]
    s00 = scale[3]
    s01 = scale[4]
    s11 = scale[5]

    t   = translate[0]
    t0  = translate[1]
    t1  = translate[2]
    t00 = translate[3]
    t01 = translate[4]
    t11 = translate[5]

    for g, i in oppum by 6
      g0  = oppum[i+1]
      g1  = oppum[i+2]
      g00 = oppum[i+3]
      g01 = oppum[i+4]
      g11 = oppum[i+5]

      n   = ((g  -t  )/s  )|0
      n0  = ((g0 -t0 )/s0 )|0
      n1  = ((g1 -t1 )/s1 )|0
      n00 = ((g00-t00)/s00)|0
      n01 = ((g01-t01)/s01)|0
      n11 = ((g11-t11)/s11)|0

      offset = i
      bucket = n|(n0<<p0)|(n1<<p1)|(n00<<p00)|(n01<<p01)|(n11<<p11)

      total = totalList[bucket]
      totalBucket[bucket] = total+1
      indexBucket[bucket] = 

  # match
  # --
  # Match 

  match: (oppum0, oppum1)->
    



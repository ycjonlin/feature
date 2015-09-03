module.exports = 

  # partition
  # --
  # Partition

  partition: (oppum, scale, translate)->
    totalBucket = new Int32Array()
    indexBucket = new Int32Array()

    s0 = scale[0]
    s1 = scale[1]
    s2 = scale[2]
    s3 = scale[3]
    s4 = scale[4]
    s5 = scale[5]

    t0 = translate[0]
    t1 = translate[1]
    t2 = translate[2]
    t3 = translate[3]
    t4 = translate[4]
    t5 = translate[5]

    p0 = 
    p1 = +p0
    p2 = +p1
    p3 = +p2
    p4 = +p3
    p5 = +p4

    for g0, i in oppum by 6
      g1 = oppum[i+1]
      g2 = oppum[i+2]
      g3 = oppum[i+3]
      g4 = oppum[i+4]
      g5 = oppum[i+5]

      n0  = ((g0-t0)/s0)|0
      n1  = ((g1-t1)/s1)|0
      n2  = ((g2-t2)/s2)|0
      n3  = ((g3-t3)/s3)|0
      n4  = ((g4-t4)/s4)|0
      n5  = ((g5-t5)/s5)|0

      bucket = (n0<<p1)|(n1<<p2)|(n2<<p3)|(n3<<p4)|(n4<<p5)|n5
      offset = totalList[bucket]

      totalBucket[bucket] = offset+1
      indexBucket[offset<<p0] = i

    totalBucket, indexBucket

  # match
  # --
  # Match 

  match: (oppum0, oppum1)->
    



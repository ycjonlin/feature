max = Math.max
min = Math.min

module.exports = 

  # partition
  # --
  # Partition

  partition: (oppum, unitLength, minValue, maxValue)->

    t0 = minValue[0]
    t1 = minValue[1]
    t2 = minValue[2]
    t3 = minValue[3]
    t4 = minValue[4]
    t5 = minValue[5]

    s0 = maxValue[0]-t0
    s1 = maxValue[1]-t1
    s2 = maxValue[2]-t2
    s3 = maxValue[3]-t3
    s4 = maxValue[4]-t4
    s5 = maxValue[5]-t5

    p5 = 
    p4 = +p5
    p3 = +p4
    p2 = +p3
    p1 = +p2
    p0 = +p1

    totalBucket = new Int32Array(1<<p0)
    indexBucket = new Int32Array()

    for g0, i in oppum by 6
      g1 = oppum[i+1]
      g2 = oppum[i+2]
      g3 = oppum[i+3]
      g4 = oppum[i+4]
      g5 = oppum[i+5]

      i0  = ((g0-t0)/s0)|0
      i1  = ((g1-t1)/s1)|0
      i2  = ((g2-t2)/s2)|0
      i3  = ((g3-t3)/s3)|0
      i4  = ((g4-t4)/s4)|0
      i5  = ((g5-t5)/s5)|0

      bucket = ((((i0*n1+i1)*n2+i2)*n3+i3)*n4+i4)*n5+i5
      offset = totalList[bucket]

      totalBucket[bucket] = offset+1
      indexBucket[offset<<p0] = i

    totalBucket, indexBucket

  # match
  # --
  # Match 

  match: (oppum0, oppum1)->
    



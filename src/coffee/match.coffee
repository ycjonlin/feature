max = Math.max
min = Math.min
floor = Math.floor

module.exports = 

  # partition
  # --
  # Partition

  partition: (oppum, unitList, minList, maxList)->

    unit0 = unitList[0]
    unit1 = unitList[1]
    unit2 = unitList[2]
    unit3 = unitList[3]
    unit4 = unitList[4]
    unit5 = unitList[5]

    min0 = minList[0]
    min1 = minList[1]
    min2 = minList[2]
    min3 = minList[3]
    min4 = minList[4]
    min5 = minList[5]

    max0 = maxList[0]
    max1 = maxList[1]
    max2 = maxList[2]
    max3 = maxList[3]
    max4 = maxList[4]
    max5 = maxList[5]

    max(min(g0, minValue[0]), maxValue[0])/unitLength[0]

    n0 = ((minValue[0]/unitLength[0])|0) - ((minValue[0]/unitLength[0])|0) + 1

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
    



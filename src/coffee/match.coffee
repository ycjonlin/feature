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

    min0 = (minList[0]/unit0)|0
    min1 = (minList[1]/unit1)|0
    min2 = (minList[2]/unit2)|0
    min3 = (minList[3]/unit3)|0
    min4 = (minList[4]/unit4)|0
    min5 = (minList[5]/unit5)|0

    max0 = (maxList[0]/unit0)|0
    max1 = (maxList[1]/unit1)|0
    max2 = (maxList[2]/unit2)|0
    max3 = (maxList[3]/unit3)|0
    max4 = (maxList[4]/unit4)|0
    max5 = (maxList[5]/unit5)|0

    n0 = max0-min0+1
    n1 = max1-min1+1
    n2 = max2-min2+1
    n3 = max3-min3+1
    n4 = max4-min4+1
    n5 = max5-min5+1

    totalBucket = new Int32Array(n0*n1*n2*n3*n4*n5)
    indexBucket = new Int32Array()

    for g0, i in oppum by 6
      g1 = oppum[i+1]
      g2 = oppum[i+2]
      g3 = oppum[i+3]
      g4 = oppum[i+4]
      g5 = oppum[i+5]

      i0 = g0 < min0 ? 0 : g0 > max0 ? n0-1 : ((g0/unit0)|0)-min0
      i1 = g1 < min1 ? 0 : g1 > max1 ? n1-1 : ((g1/unit1)|0)-min1
      i2 = g2 < min2 ? 0 : g2 > max2 ? n2-1 : ((g2/unit2)|0)-min2
      i3 = g3 < min3 ? 0 : g3 > max3 ? n3-1 : ((g3/unit3)|0)-min2
      i4 = g4 < min4 ? 0 : g4 > max4 ? n4-1 : ((g4/unit4)|0)-min4
      i5 = g5 < min5 ? 0 : g5 > max5 ? n5-1 : ((g5/unit5)|0)-min5

      bucket = ((((i0*n1+i1)*n2+i2)*n3+i3)*n4+i4)*n5+i5
      offset = totalList[bucket]

      totalBucket[bucket] = offset+1
      indexBucket[offset] = i

    totalBucket, indexBucket

  # match
  # --
  # Match 

  match: (oppum0, oppum1)->
    



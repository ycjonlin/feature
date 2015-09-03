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

    totalBucket = new Int32Array(n0*n1*n2*n3*n4*n5)
    indexBucket = new Int32Array()

    for g0, i in oppum by 6
      g1 = oppum[i+1]
      g2 = oppum[i+2]
      g3 = oppum[i+3]
      g4 = oppum[i+4]
      g5 = oppum[i+5]

      i0 = g0 < min0 ? 0 : g0 > max0 ? n0-1 : ((g0/unit0)|0)-min0
      i1 = g0 < min0 ? 0 : g0 > max0 ? n0-1 : ((g0/unit0)|0)-min0
      i2 = g0 < min0 ? 0 : g0 > max0 ? n0-1 : ((g0/unit0)|0)-min0
      i3 = g0 < min0 ? 0 : g0 > max0 ? n0-1 : ((g0/unit0)|0)-min0
      i4 = g0 < min0 ? 0 : g0 > max0 ? n0-1 : ((g0/unit0)|0)-min0
      i5 = g0 < min0 ? 0 : g0 > max0 ? n0-1 : ((g0/unit0)|0)-min0

      bucket = ((((i0*n1+i1)*n2+i2)*n3+i3)*n4+i4)*n5+i5
      offset = totalList[bucket]

      totalBucket[bucket] = offset+1
      indexBucket[offset] = i

    totalBucket, indexBucket

  # match
  # --
  # Match 

  match: (oppum0, oppum1)->
    



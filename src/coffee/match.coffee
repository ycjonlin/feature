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

    count0 = max0-min0+1
    count1 = max1-min1+1
    count2 = max2-min2+1
    count3 = max3-min3+1
    count4 = max4-min4+1
    count5 = max5-min5+1

    totalBucket = new Int32Array(count0*count1*count2*count3*count4*count5)
    indexBucket = new Int32Array()

    for value0, i in oppum by 6
      value1 = oppum[i+1]
      value2 = oppum[i+2]
      value3 = oppum[i+3]
      value4 = oppum[i+4]
      value5 = oppum[i+5]

      index0 = value0 < min0 ? 0 : value0 >= max0 ? count0-1 : ((value0/unit0)|0)-min0
      index1 = value1 < min1 ? 0 : value1 >= max1 ? count1-1 : ((value1/unit1)|0)-min1
      index2 = value2 < min2 ? 0 : value2 >= max2 ? count2-1 : ((value2/unit2)|0)-min2
      index3 = value3 < min3 ? 0 : value3 >= max3 ? count3-1 : ((value3/unit3)|0)-min2
      index4 = value4 < min4 ? 0 : value4 >= max4 ? count4-1 : ((value4/unit4)|0)-min4
      index5 = value5 < min5 ? 0 : value5 >= max5 ? count5-1 : ((value5/unit5)|0)-min5

      bucket = (((((index0*count1+index1)*count2+index2)*count3+index3)*count4+index4)*count5+index5)

      offset = totalList[bucket]
      totalBucket[bucket] = offset+1
      indexBucket[offset] = i

    #totalBucket, indexBucket

  # match
  # --
  # Match

  match: (oppum0, oppum1)->

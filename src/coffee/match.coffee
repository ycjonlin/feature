module.exports = 

  # partition
  # --
  # Partition

  partition: (oppum, unit, range)->
    total = 0

    u   = grid[0]
    u0  = grid[1]
    u1  = grid[2]
    u00 = grid[3]
    u01 = grid[4]
    u11 = grid[5]
    for g, i in oppum by 6
      g0  = oppum[i+1]
      g1  = oppum[i+2]
      g00 = oppum[i+3]
      g01 = oppum[i+4]
      g11 = oppum[i+5]

      n   = (g/u)|0
      n0  = (g0/u0)|0
      n1  = (g1/u1)|0
      n00 = (g00/u00)|0
      n01 = (g01/u01)|0
      n11 = (g11/u11)|0

      offset = n|n0|n1|n00|n01|n11

  # match
  # --
  # Match 

  match: (oppum0, oppum1)->
    for grid0 in space0



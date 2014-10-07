class Color
  randomColors: (quantity) ->
    a = []
    for index in [0...quantity]
      c = {}
      c.h = 360/quantity * index
      c.s = 50 + Math.random() * 10
      c.l = 50 + Math.random() * 10
      a.push { color: tinycolor(c).toHexString() }
    return a

window.color = new Color

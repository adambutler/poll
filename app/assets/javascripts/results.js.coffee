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

# $ ->
#   if $("#myChart").length > 0
#     # Get the context of the canvas element we want to select
#     ctx = $("#myChart")[0].getContext("2d")
#     $.ajax
#       url: "/8uRC7FnV-7zOVyvxkgSO7Q/results.json"
#       success: (data) ->
#         colors = color.randomColors(data.length)
#         $.extend true, data, colors
#         new Chart(ctx).Doughnut data

$ ->
  console.log 'hello'

  $canvas = $('#3-wheel-canvas')
  canvas_size = new paper.Size $canvas.width(), $canvas.height()
  paper.setup $canvas[0]
  paper.view.viewSize = canvas_size

  point_on_circle = (center, rad, angle) -> center.add new paper.Point(rad * Math.cos(angle), rad * Math.sin(angle))

  rad = 40
  center_init = new paper.Point(canvas_size.width / 2, 70)
  center = center_init.clone()
  angle = (x) -> (x - center_init.x) / rad
  red   = (center) -> point_on_circle center, rad, angle(center.x) + -Math.PI /2
  green = (center) -> point_on_circle center, rad, angle(center.x) + Math.PI
  blue  = (center) -> point_on_circle center, rad, angle(center.x) + Math.PI /2

  g_circle = new paper.Shape.Circle center, rad
  g_circle.strokeColor = 'black'
  g_circle.fillColor = 'white'
  g_red = paper.Shape.Circle red(center), 5
  g_red.strokeColor = 'red'
  g_green = paper.Shape.Circle green(center), 5
  g_green.strokeColor = 'green'
  g_blue = paper.Shape.Circle blue(center), 5
  g_blue.strokeColor = 'blue'

  # draw streaks

  mouse_drag_latch = on

  paper.view.onFrame = (event) ->
    # center.x = center.x + 2
    g_circle.position = center
    g_red.position   = red(center)
    g_green.position = green(center)
    g_blue.position  = blue(center)

  paper.tool.attach 'mousemove', (event) ->
    if mouse_drag_latch
      startx = center_init.x
      diffx = event.point.x - startx
      scaler = 30.0
      center.x = startx + scaler * Math.atan(diffx / scaler)

  # g_circle.attach 'mouseenter', (event) ->
  #   mouse_drag_latch = on

  # g_circle.attach 'mouseleave', (event) ->
  #   mouse_drag_latch = off

# path = new paper.Path()
# path.strokeColor = 'black'
# start = new paper.Point(20, 20)
# path.moveTo start
# path.lineTo start.add [59, 30]
$ ->
  console.log 'hello'

  $canvas = $('#3-wheel-canvas')
  canvas_size = new paper.Size $canvas.width(), $canvas.height()
  paper.setup $canvas[0]
  paper.view.viewSize = canvas_size

  point_on_circle = (center, rad, angle) -> center.add new paper.Point(rad * Math.cos(angle), rad * Math.sin(angle))

  rad = 40
  center_init = new paper.Point(canvas_size.width / 2, 70)
  center = (x) -> center_init.add new paper.Point(x - center_init.x, 0)
  current_x = center_init.x
  angle = (x) -> (x - center_init.x) / rad
  red   = (x) -> point_on_circle center(x), rad, angle(x) + -Math.PI /2
  green = (x) -> point_on_circle center(x), rad, angle(x) + Math.PI
  blue  = (x) -> point_on_circle center(x), rad, angle(x) + Math.PI /2

  # draw streaks
  do ->
    for [path_fn, path_color] in [[red, 'red'], [green, 'green'], [blue, 'blue']]
      [xrange_start, xrange_stop] = [center_init.x-50, center_init.x+50]
      path = new paper.Path()
      path.strokeColor = path_color
      path.moveTo path_fn(xrange_start)
      for x in [xrange_start..xrange_stop] by 0.2
        path.lineTo path_fn(x)

  g_circle = new paper.Shape.Circle center(current_x), rad
  g_circle.strokeColor = 'black'
  g_circle.strokeWidth = 1.5
  # g_circle.fillColor = 'white'
  g_red = paper.Shape.Circle red(current_x), 5
  g_red.fillColor = 'red'
  g_green = paper.Shape.Circle green(current_x), 5
  g_green.fillColor = 'green'
  g_blue = paper.Shape.Circle blue(current_x), 5
  g_blue.fillColor = 'blue'

  mouse_drag_latch = on

  paper.view.onFrame = (event) ->
    # center.x = center.x + 2
    g_circle.position = center(current_x)
    g_red.position   = red(current_x)
    g_green.position = green(current_x)
    g_blue.position  = blue(current_x)

  paper.tool.attach 'mousemove', (event) ->
    if mouse_drag_latch
      diffx = event.point.x - center_init.x
      scaler = 30.0
      # current_x = center_init.x + scaler * Math.atan(diffx / scaler)
      current_x = center_init.x + scaler * Math.atan(diffx / scaler)

  # g_circle.attach 'mouseenter', (event) ->
  #   mouse_drag_latch = on

  # g_circle.attach 'mouseleave', (event) ->
  #   mouse_drag_latch = off

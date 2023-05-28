extends Control

var start_position = Vector2()
var touching = false
var direction = Vector2()

func _process(_delta):
	queue_redraw()

func _draw():
	if touching and not G.snake.dead:
		direction = start_position.direction_to(get_global_mouse_position())
		
		draw_circle(start_position, 5.0, Color.WHITE)
		draw_line(start_position, get_global_mouse_position(), Color.WHITE, 5.0)
		draw_circle(get_global_mouse_position(), 20, Color.WHITE)

func _unhandled_input(event):
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		if event.pressed and not G.ui.get_node("map_ui").in_map:
			touching = true
			start_position = get_global_mouse_position()
		else:
			touching = false
			direction = Vector2()

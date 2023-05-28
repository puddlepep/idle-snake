extends Node2D

signal swipe
var swipe_start = null
var minimum_drag = 100

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			swipe_start = get_global_mouse_position()
		else:
			_calculate_swipe(get_global_mouse_position())
		
func _calculate_swipe(swipe_end):
	if swipe_start == null: 
		return
	var swipe = swipe_end - swipe_start
	if abs(swipe.x) > minimum_drag:
		if swipe.x > 0:
			emit_signal("swipe", "right")
		else:
			emit_signal("swipe", "left")

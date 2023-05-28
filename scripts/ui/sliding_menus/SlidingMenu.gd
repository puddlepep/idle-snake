extends Panel
class_name SlidingMenu

@export var invert_direction = false
var shown = false
var default_anchors = {}

func _init():
	default_anchors.top = anchor_top
	default_anchors.bottom = anchor_bottom
	default_anchors.left = anchor_left
	default_anchors.right = anchor_right
	
	anchor_top = default_anchors.top - (1.0 * get_dir())
	anchor_bottom = default_anchors.bottom - (1.0 * get_dir())

func get_dir(): 
	return -1.0 if invert_direction else 1.0

func toggle_menu():
	if shown:
		hide_menu()
	else:
		show_menu()

func show_menu():
	if shown: return
	shown = true
	
	var window_size = get_viewport().get_window().size
	var tween = get_tree().create_tween()
	if window_size.x >= window_size.y:
		anchor_left = default_anchors.left
		anchor_right = default_anchors.right
		anchor_top = default_anchors.top - (1.0 * get_dir())
		anchor_bottom = default_anchors.bottom - (1.0 * get_dir())
		
		tween.parallel().tween_property(self, "anchor_top", default_anchors.top, 0.5).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
		tween.parallel().tween_property(self, "anchor_bottom", default_anchors.bottom, 0.5).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	else:
		anchor_left = default_anchors.left - (1.0 * get_dir())
		anchor_right = default_anchors.right - (1.0 * get_dir())
		anchor_top = default_anchors.top
		anchor_bottom = default_anchors.bottom
		
		tween.parallel().tween_property(self, "anchor_left", default_anchors.left, 0.5).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
		tween.parallel().tween_property(self, "anchor_right", default_anchors.right, 0.5).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)

func hide_menu():
	if not shown: return
	shown = false
	
	var window_size = get_viewport().get_window().size
	var tween = get_tree().create_tween()
	if window_size.x >= window_size.y:
		tween.parallel().tween_property(self, "anchor_top", default_anchors.top - (1.0 * get_dir()), 0.5).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
		tween.parallel().tween_property(self, "anchor_bottom", default_anchors.bottom - (1.0 * get_dir()), 0.5).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	else:
		tween.parallel().tween_property(self, "anchor_left", default_anchors.left - (1.0 * get_dir()), 0.5).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
		tween.parallel().tween_property(self, "anchor_right", default_anchors.right - (1.0 * get_dir()), 0.5).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	

extends Area2D

var tweening = false
func bounce():
	if not tweening:
		var old_scale = scale
		var old_rotation = rotation
		
		scale *= Vector2(1.1,1.1)
		rotation = rotation + randf_range(-PI/16.0, PI/16.0)
		var tween = get_tree().create_tween()
		tween.parallel().tween_property(self, "scale", old_scale, 1.0).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
		tween.parallel().tween_property(self, "rotation", old_rotation, 1.0).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
		
		tween.tween_callback(func a(): tweening = false)
		tweening = true

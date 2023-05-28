extends Water

var x_in = -100.0
var y_in = -100.0
var x_out = -1000.0
var y_out = -250.0

@onready var wet_sand = get_node("../wet_sand")
@onready var sand_tween: Tween = create_tween()

func _ready():
	super()
	
	position.x = x_in
	position.y = y_in
	
	while true:
		await go_out()
		await get_tree().create_timer(2.0).timeout
		await go_in()

func go_in() -> Signal:
	if sand_tween.is_running(): sand_tween.kill()
	
	var tween = create_tween()
	tween.parallel().tween_property(self, "position:x", x_in, 5.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property(self, "position:y", y_in, 5.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(wet_sand, "modulate:a", 1.0, 0.1)
	
	return tween.finished

func go_out() -> Signal:
	var tween = create_tween()
	tween.parallel().tween_property(self, "position:x", x_out, 5.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property(self, "position:y", y_out, 5.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	if sand_tween.is_running(): sand_tween.kill()
	sand_tween = create_tween()
	sand_tween.tween_property(wet_sand, "modulate:a", 0.0, 10.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	return tween.finished

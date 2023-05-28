extends Sprite2D

var time_alive = 0.0
var sway_mult = 0.0

func _ready():
	time_alive = randf_range(0.0, 1000.0)
	sway_mult = randf_range(0.1, 1.0)

func _physics_process(delta):
	time_alive += delta
	rotation = sin(time_alive * sway_mult * 0.5) * 0.2

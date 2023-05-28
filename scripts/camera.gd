extends Camera2D

enum Mode { STATIC, FOLLOW }
var mode = Mode.STATIC

var target_position = Vector2()
var target_zoom = 1.0

func _ready():
	G.camera = self

func _process(_delta):
	if mode == Mode.FOLLOW:
		
		# snake should only move when at the bounds of the screen, make that happen pls
		var screen_size = get_viewport_rect().size
		
		var origin = G.snake.get_global_transform_with_canvas().get_origin()
		target_position = G.snake.global_position
	
	position = lerp(position, target_position, 0.1)
	zoom = lerp(zoom, Vector2(1.0,1.0) * target_zoom, 0.1)
	

extends Area2D

var velocity = Vector2()

func _physics_process(_delta):
	position += velocity
	velocity *= 0.9

func _on_area_entered(area):
	if area.is_in_group("snake"):
		var snake_dir = Vector2.from_angle(G.snake.angle)
		var dir_to_snake = global_position.direction_to(area.global_position)
		var dot = abs(snake_dir.dot(dir_to_snake))
		
		velocity = ((-dir_to_snake * 5.0) * dot) + snake_dir

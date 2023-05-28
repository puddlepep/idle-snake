extends Node2D

var snake_scn = preload("res://scenes/snake.tscn")

func _ready():
	G.game = self
	G.ui = get_node("UI")
	
	G.current_level = get_node("lands/forest")
	G.current_level._on_land_entered()
	
	G.current_level.enabled = true
	for l in get_node("lands").get_children():
		l.modulate.a = 0.0
	
	G.current_level.modulate.a = 1.0
	spawn_snake()

func respawn():
	spawn_snake()
	Numbers.score = 0

func spawn_snake():
	if G.snake != null:
		G.snake.queue_free()
	
	G.snake = snake_scn.instantiate()
	G.current_level.get_node("snake_area").add_child(G.snake)
	G.snake.controlled = true

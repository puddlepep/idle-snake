@tool
extends CollisionShape2D
class_name ScatterExclusion

func _ready():
	if shape == null:
		shape = RectangleShape2D.new()
		shape.size = Vector2(10, 10)
	
	debug_color = Color("f400114a")

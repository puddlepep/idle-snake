extends Polygon2D
class_name Water

func _ready():
	var area = Area2D.new()
	add_child(area)
	
	var collider = CollisionPolygon2D.new()
	collider.polygon = polygon
	area.add_child(collider)
	
	area.connect("area_entered", _on_area_entered)
	area.connect("area_exited", _on_area_exited)

func _on_area_entered(area):
	if area.is_in_group("snake"):
		G.snake.swimming = true

func _on_area_exited(area):
	if area.is_in_group("snake"):
		G.snake.swimming = false

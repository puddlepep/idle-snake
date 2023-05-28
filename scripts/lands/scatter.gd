@tool
extends CollisionShape2D
class_name Scatter

@onready var rng = RandomNumberGenerator.new()

@export var scatter_object: PackedScene = null
@export var seed = 0
@export var count = 50
@export var scale_range = Vector2(1.0, 1.0)
@export var rotation_range = Vector2(0.0, 0.0)
@export var brightness_range = Vector2(0.0, 0.0)
var current_seed = 0

func _ready():
	debug_color = Color.TRANSPARENT
	
	if shape == null:
		shape = RectangleShape2D.new()
		shape.size = Vector2(10,10)

func get_seed() -> int:
	
	var s = seed
	
	for c in get_children():
		if c is ScatterExclusion:
			s += c.shape.size.x + c.shape.size.y
			s += c.position.x + c.position.y
	
	s += shape.size.x + shape.size.y
	s += (scale_range.x + scale_range.y) * 1000.0
	s += (rotation_range.x + rotation_range.y) * 1000.0
	s += (brightness_range.x + brightness_range.y) * 1000.0
	s += count
	return s

func _process(_delta):
	if scatter_object != null:
		if current_seed != get_seed():
			current_seed = get_seed()
			scatter() 

func scatter():
	
	var exclusions = []
	var c = 0
	for i in range(get_child_count()):
		var child = get_child(c)
		if not child is ScatterExclusion:
			remove_child(child)
			child.queue_free()
		else:
			c += 1
			exclusions.append(child)
	
	rng.seed = current_seed
	for i in range(count):
		
		var rpos = Vector2()
		var good_pos = false
		while not good_pos:
			rpos = Vector2(
				rng.randf_range(-shape.size.x/2.0, shape.size.x/2.0),
				rng.randf_range(-shape.size.y/2.0, shape.size.y/2.0)
			)
			
			good_pos = true
			for e in exclusions:
				if rpos.x >= -e.shape.size.x/2.0 + e.position.x and rpos.x <= e.shape.size.x/2.0 + e.position.x:
					if rpos.y >= -e.shape.size.y/2.0 + e.position.y and rpos.y <= e.shape.size.y/2.0 + e.position.y:
						good_pos = false
		
		var obj = scatter_object.instantiate()
		obj.position = rpos
		obj.scale = Vector2(1.0, 1.0) * rng.randf_range(scale_range.x, scale_range.y)
		obj.rotation = rng.randf_range(rotation_range.x, rotation_range.y)
		obj.modulate = obj.modulate.darkened(-rng.randf_range(brightness_range.x, brightness_range.y))
		add_child(obj)

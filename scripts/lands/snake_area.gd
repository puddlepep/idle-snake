@tool
extends Polygon2D
class_name SnakeArea

enum AreaType { SQUARE, POLYGON }
@export var type = AreaType.SQUARE
@export var square_size = Vector2(10,10)

var time_til_spawn = 0.0
var collider: Area2D = null

func _ready():
	if collider == null:
		collider = Area2D.new()
		collider.name = "wall_collider"
		collider.add_to_group("wall")
		collider.collision_mask = 0
		collider.collision_layer = 4
		add_child(collider)
	
	update_shape()


func get_polygon_bounds():
	
	var min = { "x": null, "y": null }
	var max = { "x": null, "y": null }
	for p in polygon:
		if min.x == null or p.x < min.x: min.x = p.x
		if min.y == null or p.y < min.y: min.y = p.y
		if max.x == null or p.x > max.x: max.x = p.x
		if max.y == null or p.y > max.y: max.y = p.y
	
	var size = Vector2(
		max.x - min.x,
		max.y - min.y,
	)
	var center = Vector2(
		(min.x + max.x) / 2.0,
		(min.y + max.y) / 2.0,
	)
	return { "size": size, "center": center }


func generate_point_in_bounds() -> Vector2:
	
	if type == AreaType.SQUARE:
		var pt = Vector2(
			randi_range(-square_size.x, square_size.x) / 2.0,
			randi_range(-square_size.y, square_size.y) / 2.0,
		)
		return pt
	
	else:
		var bounds = get_polygon_bounds()
		
		var pt = Vector2()
		var is_in_bounds = false
		while not is_in_bounds:
			pt = Vector2(
				randi_range(-bounds.size.x, bounds.size.x) / 2.0,
				randi_range(-bounds.size.y, bounds.size.y) / 2.0,
			) + bounds.center
			
			if Geometry2D.is_point_in_polygon(pt, polygon):
				is_in_bounds = true
		
		return pt


func is_point_spawnable(point: Vector2) -> bool:
	
	var item = Numbers.spawn("apples")
	
	var params = PhysicsShapeQueryParameters2D.new()
	params.collision_mask = 5
	params.collide_with_areas = true
	params.transform = item.transform.translated(to_global(point))
	params.shape = item.get_node("collider").shape
	var hits = get_world_2d().direct_space_state.intersect_shape(params)
	
	if len(hits) == 0:
		var is_ok = true
		for c in hits:
			if not c is Fruit:
				is_ok = false
				break
		
		if is_ok: return true
		else: return false
	else:
		return false


func update_shape():
	# update shape
	if type == AreaType.SQUARE:
		var sz = square_size / 2.0
		polygon = PackedVector2Array([
			Vector2(-sz.x, -sz.y),
			Vector2(sz.x, -sz.y),
			Vector2(sz.x, sz.y),
			Vector2(-sz.x, sz.y)
		])
	
	# update collision
	for c in collider.get_children():
		c.queue_free()
	
	for pi in range(len(polygon)):
		var pi2 = wrapi(pi + 1, 0, len(polygon))
		
		var cs = CollisionShape2D.new()
		cs.shape = SegmentShape2D.new()
		
		cs.shape.a = polygon[pi]
		cs.shape.b = polygon[pi2]
		collider.add_child(cs)


func spawn_item(item_name: String):
	
	var fallback_point = Vector2()
	for c in get_children():
		if c.is_in_group("item"): fallback_point = c.position
	
	var point = null
	var tries = 0
	while tries < 100:
		tries += 1
		
		point = generate_point_in_bounds()
		if is_point_spawnable(point): break
		else: point = null
	
	if point == null:
		point = fallback_point
	
	var item = Numbers.spawn(item_name)
	item.position = point
	return item


var old_type = type 
var old_sz = square_size
func _physics_process(delta):
	
	if old_type != type or old_sz != square_size: update_shape()
	old_type = type
	old_sz = square_size
	
	if not Engine.is_editor_hint() and get_parent().enabled:
		
		var item_count = 0
		for c in get_children():
			if c.is_in_group("item"):
				item_count += 1
		
		var item_max_upgrade = get_parent().get_upgrade("item max")
		var item_spawn_speed_upgrade = get_parent().get_upgrade("item spawn speed")
		
		if item_count < item_max_upgrade.value:
			if time_til_spawn >=item_spawn_speed_upgrade.initial_value * (1.0 / item_spawn_speed_upgrade.get_linear_multiplier()):
				
				var rn = randi_range(0, len(get_parent().resources) - 1)
				var r = get_parent().resources[rn]
				
				var item_name = get_parent().resources[rn]
				var item = spawn_item(item_name)
				add_child(item)
				
				time_til_spawn = 0.0
			else:
				time_til_spawn += delta

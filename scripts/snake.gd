extends Node2D
class_name Snake

var path = []

var segment_distance = 10
var starting_segments = 5

var target_dir = Vector2():
	set(new):
		if target_dir == Vector2() and new != Vector2():
			get_tree().create_tween().tween_property(self, "speed", G.current_level.get_upgrade("speed").value, 0.2)
		if new == Vector2():
			get_tree().create_tween().tween_property(self, "speed", 0.0, 0.2)
		target_dir = new

var angle = -PI/2.0  

var controlled = false
var dead = false
var swimming = false
var speed = 0.0

var breath_max = 2.0
var breath = breath_max

@onready var bounce_tween = get_tree().create_tween()

func _ready():
	$body.points = PackedVector2Array()
	for i in range(starting_segments):
		path.push_front(Vector2(0, i*segment_distance))
	
	increase_size(starting_segments)
	
	# disable the first x colliders, to prevent self-collision w/ the head
	for i in range(5):
		$collider.get_child(i).disabled = true
	
	G.snake = self

func _physics_process(delta):
	if dead or not controlled: return
	
	target_dir = Vector2()
	match G.control_scheme:
		G.ControlScheme.FOLLOW_TOUCH:
			target_dir = $body.get_point_position(0).direction_to(get_global_mouse_position() - global_position)
		G.ControlScheme.JOYSTICK:
			target_dir = G.ui.get_node("joystick").direction
	
	if speed > 0.0:
		var dir = Vector2(cos(angle), sin(angle))
		position += dir * speed
		
		var speed_upgrade = G.current_level.get_upgrade("speed")
		var turn_speed_upgrade = G.current_level.get_upgrade("turn speed")
		var speed_max = speed_upgrade.value
		var turn_speed = turn_speed_upgrade.value * speed_upgrade.get_linear_multiplier()
		
		var target_angle = wrapf(target_dir.angle() - angle, -PI, PI)
		if target_angle > 0.0: angle += turn_speed * (speed / speed_max)
		elif target_angle < 0.0: angle -= turn_speed * (speed / speed_max)
		
		if abs(target_angle) < turn_speed * (speed / speed_max):
			angle = target_dir.angle()
	
	var pos = position
	if path.back() != position:
		path.push_back(position)
	
	var i = update_tail()
	var tp = path.duplicate()
	tp.resize(i)
	$trail.points = tp.map(func(v): return v - position)
	
	$head.position = $body.get_point_position(0)
	$head.rotation = angle + PI/2
	
	if swimming:
		breath -= delta
	else:
		breath += delta
	
	if breath <= 0:
		breath = 0
		die()
	if breath > breath_max:
		breath = breath_max
	queue_redraw()

# returns the index of the last point of the tail
func update_tail() -> int:
	var r = 0;
	
	# place tail properly , code sucks , hate it, think its ok though
	var s = 1
	var distance_travelled = 0.0
	
	for i in range(len(path)-1, 0, -1):
		if s >= $body.get_point_count(): break
		r = i
		
		var next = path[i - 1] - position
		var pt = path[i] - position
		
		var diff = next - pt
		var length = diff.length()
		
		distance_travelled += length
		if distance_travelled > segment_distance:
			distance_travelled -= length
			
			var distance_needed = segment_distance - distance_travelled
			var perc = distance_needed / length
			var pos = pt + diff * perc
			
			$body.set_point_position(s, pos)
			$collider.get_child(s).position = pos
			
			s += 1
			distance_travelled = length - distance_needed
	
	# if the length of the body is somehow longer than the path, just keep extending in one dir
	if s < $body.get_point_count() and s > 3:
		var dir = ($body.get_point_position(s - 1) - $body.get_point_position(s - 2)).normalized()
		for i in range(s, $body.get_point_count()):
			var prev = $body.get_point_position(i-1)
			var pos = prev + dir * segment_distance
			
			$body.set_point_position(i, pos)
			$collider.get_child(i).position = pos
	
	# trim the path :thumbs_up:
	distance_travelled = 0.0
	for i in range(len(path)):
		if i+1 >= len(path): break
		
		var pt = path[i]
		var next = path[i+1]
		var length = (next - pt).length()
		
		distance_travelled += length
		
		if distance_travelled > $body.get_point_count() * segment_distance + (segment_distance*20):
			path.reverse() # lol
			path.resize(i)
			path.reverse()
			break
	
	return r

func increase_size(amt: int):
	for i in amt:
		$body.add_point(Vector2())
		
		var col = CollisionShape2D.new()
		col.shape = CircleShape2D.new()
		col.shape.radius = 16
		col.name = "shape"
		$collider.add_child(col)
		
		update_tail()
	
	$body.width = 38
	bounce_tween.stop()
	bounce_tween = get_tree().create_tween()
	bounce_tween.tween_property($body, "width", 32, 1.0).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)

func die():
	if dead: return
	dead = true
	G.emit_signal("snake_died")
	Input.vibrate_handheld(50)

func _on_head_collided(area):
	if area is Fruit:
		area.eat()
		call_deferred("increase_size", 4)
	
	if area.is_in_group("cactus"):
		area.bounce()
	
	if area.is_in_group("wall") or area.is_in_group("snake"):
		die()

func _draw():
	if breath < breath_max and not dead:
		var max_angle_span = PI/2.0;
		var breath_left_percent = breath / breath_max
		var angle_span = max_angle_span * breath_left_percent
		
		draw_arc($body.points[0], 24, angle-angle_span-0.1, angle+angle_span+0.1, 24, Color.BLACK, 3.0)
		draw_arc($body.points[0], 24, angle-angle_span, angle+angle_span, 24, Color.DEEP_SKY_BLUE, 3.0)

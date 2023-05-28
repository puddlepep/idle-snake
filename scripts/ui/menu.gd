extends Panel

var dragging = false
var velocity = Vector2()
var up = false
var selection = 0

var default_y_offset = 90
var y_offset = default_y_offset

@onready var vp_size = get_viewport_rect().size

func _process(_delta):
	if get_viewport_rect().size != vp_size:
		vp_size = get_viewport_rect().size
		
		if vp_size.x > 1080:
			size.x = vp_size.x / 3.0
			y_offset = (90.0 / 1080.0) * size.x
		else:
			size.x = 1080
			y_offset = 90
		size.y = size.x * 2.0
		
		position.x = 0
		if not up:
			position.y = vp_size.y - y_offset
			swipe_down()
		else:
			swipe_up()

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed: dragging = true

func _input(event):
	var viewport_size = get_viewport_rect().size
	
	if event is InputEventMouseButton and not event.pressed:
		dragging = false
		
		if velocity != Vector2():
			if abs(velocity.y) > abs(velocity.x):
				if velocity.y < 0: swipe_up()
				else: swipe_down()
			else:
				if velocity.x < 0: swipe_category(selection + 1)
				else: swipe_category(selection - 1)
		else:
			if up: swipe_up()
			else: swipe_down()
		
		velocity = Vector2()
	
	if event is InputEventMouseMotion and dragging:
		velocity = event.relative
		
		if abs(velocity.y) > abs(velocity.x):
			position.y += event.relative.y
			if viewport_size.y - position.y > size.y:
				position.y = viewport_size.y - size.y
		else:
			$content.position.x += event.relative.x

func swipe_up():
	up = true
	var viewport_size = get_viewport_rect().size
	var tween = create_tween()
	
	var new_y = viewport_size.y * 0.1
	var distance = viewport_size.y - new_y
	if distance > size.y:
		new_y = viewport_size.y - size.y
	
	tween.parallel().tween_property(self, "position:y", new_y, 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)

func swipe_down():
	up = false
	var viewport_size = get_viewport_rect().size
	var tween = create_tween()
	tween.parallel().tween_property(self, "position:y", viewport_size.y - y_offset, 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)

func swipe_category(category: int):
	if category >= 0 and category < 3:
		selection = category
	
	match selection:
		0:
			$category_names/shop.label_settings.font_color = "#ffffff"
			$category_names/bag.label_settings.font_color = "#01b8f3"
			$category_names/options.label_settings.font_color = "#ffffff"
		1:
			$category_names/shop.label_settings.font_color = "#01b8f3"
			$category_names/bag.label_settings.font_color = "#ffffff"
			$category_names/options.label_settings.font_color = "#ffffff"
		2:
			$category_names/shop.label_settings.font_color = "#ffffff"
			$category_names/bag.label_settings.font_color = "#ffffff"
			$category_names/options.label_settings.font_color = "#01b8f3"
	
	var viewport_size = get_viewport_rect().size
	var panel_size = $content.size.x / 3.0
	var tween = create_tween()
	tween.tween_property($content, "position:x", panel_size * -selection + 24, 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)

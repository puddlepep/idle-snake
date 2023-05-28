extends Control

var map_selection = 0
var in_map = false

func _ready():
	visible = false
	Swipe.connect("swipe", swiped)

func update():
	var land = G.lands.get_child(map_selection)
	
	$description/name.text = land.name
	$description/desc.text = land.description
	for c in $resources/margin/container.get_children():
		c.queue_free()
	
	if land.cost != {}:
		$resources/title.text = "cost"
		for p in land.cost.keys():
			
			var container = HBoxContainer.new()
			
			var icon = TextureRect.new()
			icon.texture = Numbers.items[p].icon
			icon.expand_mode = TextureRect.EXPAND_FIT_WIDTH
			
			var label = Label.new()
			label.text = str(land.cost[p])
			
			$resources/margin/container.add_child(container)
			container.add_child(icon)
			container.add_child(label)
	else:
		$resources/title.text = "available resources"
		for p in land.resources:
			var icon = TextureRect.new()
			icon.texture = Numbers.items[p].icon
			icon.expand_mode = TextureRect.EXPAND_FIT_WIDTH
			$resources/margin/container.add_child(icon)

func get_land():
	return G.lands.get_child(map_selection)

func swiped(dir: String):
	if not in_map: return
	
	var tween = get_tree().create_tween()
	if dir == "left":
		tween.parallel().tween_property(get_land(), "modulate:a", 0.0, 0.1)
		map_selection += 1
		if map_selection >= G.lands.get_child_count(): map_selection = G.lands.get_child_count() - 1
		
		tween.parallel().tween_property(get_land(), "modulate:a", 1.0, 0.1)
		G.camera.target_position = get_land().position
		update()
	
	if dir == "right":
		tween.parallel().tween_property(get_land(), "modulate:a", 0.0, 0.1)
		map_selection -= 1
		if map_selection < 0: map_selection = 0
		
		tween.parallel().tween_property(get_land(), "modulate:a", 1.0, 0.1)
		G.camera.target_position = get_land().position
		update()

func _process(_delta):
	if in_map:
		if Input.is_action_just_pressed("left"):
			swiped("right")
		if Input.is_action_just_pressed("right"):
			swiped("left")
	
	if Input.is_action_just_pressed("toggle_map"):
		toggle_map()

func toggle_map():
	if in_map:
		close_map()
	else:
		open_map()

func open_map():
	update()
	
	G.camera.target_zoom = 1.0
	G.camera.mode = G.camera.Mode.STATIC
	in_map = true
	visible = true
	
	G.snake.controlled = false
	G.ui.get_node("upgrade_panel").hide_menu()
	G.ui.get_node("inventory_panel").hide_menu()

func close_map():
	var land = G.lands.get_child(map_selection)
	if land.cost != {}:
		
		if not Input.is_action_pressed("free_buy"):
			for r in land.cost.keys():
				if Numbers.items[r].count < land.cost[r]:
					return
			
			for r in land.cost.keys():
				Numbers.items[r].count -= land.cost[r]
		
		land.cost = {}
		land._on_level_unlocked()
		land.enabled = true
	
	if G.current_level != land:
		G.current_level = land
		G.game.respawn()
	
	land._on_land_entered()
	in_map = false
	visible = false
	
	await get_tree().create_timer(0.05).timeout
	G.snake.controlled = true

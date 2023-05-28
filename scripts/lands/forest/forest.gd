@tool
extends Land

var area_size = Vector2(300, 300):
	set(new_area_size):
		area_size = new_area_size
		update_area_size()

func _init():
	get_upgrade("speed").cost = { "apples": 20 }
	get_upgrade("speed").percentage_increment = 15
	
	get_upgrade("turn speed").cost = { "apples": 30, "blueberries": 30 }
	
	get_upgrade("item spawn speed").name = "fruit spawn speed"
	get_upgrade("item spawn speed").cost = { "apples": 20 }
	
	get_upgrade("item max").name = "fruit max"
	get_upgrade("item max").cost = { "apples": 15 }
	
	var apple_value_upgrade = Upgrade.custom("apple value", "apples are worth 1", "+1", 1, {"blueberries": 30})
	apple_value_upgrade.connect("upgraded", _on_apple_value_upgraded)
	add_upgrade(apple_value_upgrade)
	
	var area_upgrade = Upgrade.linear("area size", 1.0, 15, { "apples": 20, "blueberries": 20 })
	area_upgrade.connect("upgraded", _on_area_size_upgraded)
	add_upgrade(area_upgrade)
	
	var fruit_upgrade = Upgrade.custom("new fruit", "blueberries will now spawn", "", 1, {"apples": 50})
	fruit_upgrade.connect("upgraded", _on_new_fruit_upgraded)
	add_upgrade(fruit_upgrade)

func update_area_size():
	$snake_area.square_size = area_size
	$snake_area/leaf_scatter.shape.size = area_size
	$bg_leaf_scatter/exclusion.shape.size = area_size + Vector2(250,250)
	$tree_scatter/exclusion.shape.size = area_size

func _on_land_entered():
	G.camera.mode = G.camera.Mode.STATIC
	G.camera.target_zoom = 2.0

func _on_area_size_upgraded(upgrade: Upgrade):
	area_size = Vector2(300, 300) * upgrade.value
	if upgrade.level > 3:
		upgrade.cost = {}

func _on_new_fruit_upgraded(upgrade: Upgrade):
	resources.append("blueberries")
	upgrade.cost = {}
	Numbers.activate_item("blueberries")

func _on_apple_value_upgraded(upgrade: Upgrade):
	upgrade.value += 1
	for c in upgrade.cost.keys():
		upgrade.cost[c] = round(upgrade.cost[c] * 1.5)
	
	Numbers.items.apples.value = upgrade.value
	upgrade.description = "apples are worth %d" % (upgrade.level + 1)

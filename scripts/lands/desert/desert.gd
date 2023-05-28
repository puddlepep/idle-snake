extends Land

func _init():
	cost = {
		"apples": 100,
		"blueberries": 100,
	}
	
	resources = ["bones"]
	
	get_upgrade("speed").cost = { "bones": 20, "blueberries": 20 }
	get_upgrade("turn speed").cost = { "bones": 50, "blueberries": 50 }
	
	get_upgrade("item spawn speed").set_initial_value(3.0)
	get_upgrade("item spawn speed").percentage_increment = 15
	get_upgrade("item spawn speed").cost = { "bones": 1 }
	
	get_upgrade("item max").cost = { "bones": 15 }
	
	var bone_value_upgrade = Upgrade.custom("bone value", "bones are worth 1", "+1", 1, {"bones": 50})
	bone_value_upgrade.connect("upgraded", _on_bone_value_upgraded)
	add_upgrade(bone_value_upgrade)
	
	var expansion = Upgrade.custom("expansion", "oasis", "", 0, { "bones": 100, "blueberries": 100, "apples": 200 })
	expansion.connect("upgraded", _on_expansion_upgraded)
	add_upgrade(expansion)

func _on_land_entered():
	G.camera.mode = G.camera.Mode.STATIC
	G.camera.target_zoom = 1.5

func _on_level_unlocked():
	Numbers.items.bones.active = true

func _on_bone_value_upgraded(upgrade: Upgrade):
	upgrade.value += 1
	upgrade.description = "bones are worth %d" % (upgrade.level + 1)
	for i in upgrade.cost.keys():
		upgrade.cost[i] = round(upgrade.cost[i] * 1.5)
	
	Numbers.items.bones.value = upgrade.value

func _on_expansion_upgraded(upgrade: Upgrade):
	if upgrade.level == 1:
		upgrade.cost = { "bones": 100 }
		upgrade.description = "expansion 2"
		
		var polygon = Geometry2D.merge_polygons($snake_area.polygon, $snake_area/oasis.polygon)[0]
		$snake_area.polygon = polygon
		$snake_area.update_shape()
		$snake_area/oasis/water.visible = true
	
	if upgrade.level == 2:
		upgrade.cost = {}
		
		var polygon = Geometry2D.merge_polygons($snake_area.polygon, $snake_area/expansion_2.polygon)[0]
		$snake_area.polygon = polygon
		$snake_area.update_shape()

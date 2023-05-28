extends SlidingMenu

var inventory_resource_scn = preload("res://scenes/inventory_resource.tscn")

func _ready():
	visible = true
	for c in $tab_container.get_children():
		c.queue_free()

func _process(delta):
	if Input.is_action_just_pressed("toggle_inventory_menu"):
		toggle_menu()
	
	for r in Numbers.items.keys():
		if not Numbers.items[r].active: continue
		
		var area = Numbers.items[r].level
		if not $tab_container.has_node(area):
			var mc = MarginContainer.new()
			mc.name = area
			$tab_container.add_child(mc)
			
			var container = VBoxContainer.new()
			container.name = "container"
			mc.add_child(container)
		
		var container = get_node("tab_container/%s/container" % area)
		if not container.has_node(r):
			
			var rc = inventory_resource_scn.instantiate()
			rc.name = r
			rc.get_node("icon").texture = Numbers.items[r].icon
			container.add_child(rc)
		
		var label = container.get_node(r).get_node("label")
		label.text = "%s - %d" % [r, Numbers.items[r].count]

func show_menu():
	super()
	G.ui.get_node("upgrade_panel").hide_menu()
	G.ui.get_node("map_ui").close_map()

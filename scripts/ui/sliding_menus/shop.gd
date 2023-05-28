extends SlidingMenu

var upgrade_button_scn = preload("res://scenes/upgrade_button.tscn")

func _ready():
	visible = true
	G.connect("current_level_changed", reload)

func _process(delta):
	if Input.is_action_just_pressed("toggle_upgrade_menu"):
		toggle_menu()

func reload():
	for child in $upgrades/scroll_container/vbox_container.get_children():
		child.queue_free()
	
	var upgrades = Upgrades.current
	if upgrades != null:
		for u in upgrades.keys():
			
			var button = upgrade_button_scn.instantiate()
			button.upgrade = upgrades[u]
			$upgrades/scroll_container/vbox_container.add_child(button)

func show_menu():
	super()
	G.ui.get_node("inventory_panel").hide_menu()
	G.ui.get_node("map_ui").close_map()

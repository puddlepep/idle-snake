extends Panel

var upgrade_button_scn = preload("res://scenes/upgrade_button.tscn")

func _ready():
	visible = true
	G.connect("current_level_changed", reload)

func reload():
	var upgrade_container = $content/scroll/upgrade_container
	for child in upgrade_container.get_children():
		child.queue_free()
	
	var upgrades = Upgrades.current
	if upgrades != null:
		for u in upgrades.keys():
			
			var button = upgrade_button_scn.instantiate()
			button.upgrade = upgrades[u]
			upgrade_container.add_child(button)

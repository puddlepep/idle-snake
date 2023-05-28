extends Button


func _on_pressed():
	G.ui.get_node("map_ui").toggle_map()

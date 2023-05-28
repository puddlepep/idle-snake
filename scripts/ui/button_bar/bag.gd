extends Button


func _on_pressed():
	G.ui.get_node("inventory_panel").toggle_menu()

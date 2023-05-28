extends Button


func _on_pressed():
	G.ui.get_node("upgrade_panel").toggle_menu()

extends Button


func _ready():
	connect("pressed", func(): G.ui.get_node("map_ui").toggle_map())

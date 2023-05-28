extends Land

func _ready():
	resources = ["bones"]

func _on_land_entered():
	G.camera.mode = G.camera.Mode.FOLLOW
	G.camera.target_zoom = 1.25

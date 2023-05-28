extends ColorRect

func _process(_delta):
	position = G.camera.position - size / 2.0

extends Label

func _physics_process(delta):
	text = "score: %d" % Numbers.score

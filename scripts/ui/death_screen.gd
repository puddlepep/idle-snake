extends Panel

var shown = false
var mouse_inside = false

@onready var tween: Tween = get_tree().create_tween()

func _ready():
	hide_screen()
	visible = true
	
	G.connect("snake_died", show_screen)
	connect("mouse_entered", func(): mouse_inside = true)
	connect("mouse_exited", func(): mouse_inside = false)

func show_screen():
	if tween.is_running(): tween.stop()
	shown = true
	
	mouse_filter = Control.MOUSE_FILTER_STOP
	tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.2)

func hide_screen():
	if tween.is_running(): tween.stop()
	shown = false
	
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.05)

func _process(_delta):
	if shown and mouse_inside and Input.is_action_just_pressed("tap"):
		hide_screen()
		G.game.respawn()

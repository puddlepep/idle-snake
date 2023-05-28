@tool
extends Area2D
class_name Fruit

@export var resource: String = ""
@export var texture: Texture2D = null 

var time_alive = 0.0

func _ready():
	$sprite.texture = texture
	
	if not Engine.is_editor_hint():
		scale = Vector2()
		var scale_tween = get_tree().create_tween()
		scale_tween.tween_property(self, "scale", Vector2(1.0, 1.0), 1.0).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)

func _physics_process(delta):
	if not Engine.is_editor_hint():
		time_alive += delta
		rotation = sin(time_alive * 1.5) * 0.2

func eat():
	Numbers.add(resource, Numbers.items[resource].value)
	Numbers.score += 1
	
	Input.vibrate_handheld(10)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(), 0.05)
	tween.tween_callback(func(): queue_free())

extends Sprite2D

@export var target: Sprite2D

func follow_target():
	position = target.global_position
	rotation = target.global_rotation
	scale = target.global_scale

func _ready():
	texture = target.texture
	follow_target()
	
	visible = false

func _physics_process(delta):
	follow_target()
	visible = true

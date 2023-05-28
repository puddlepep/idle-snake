extends Node

signal current_level_changed

enum ControlScheme { FOLLOW_TOUCH, JOYSTICK }
var control_scheme: ControlScheme = ControlScheme.JOYSTICK

signal snake_died

var game = null
var snake: Snake = null
var ui: CanvasLayer = null
var camera: Camera2D = null

var lands = null:
	get:
		return game.get_node("lands")

var current_level: Land = null:
	set(new_level):
		current_level = new_level
		emit_signal("current_level_changed")

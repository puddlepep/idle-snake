extends Node

signal item_added
signal item_activated

var score = 0
var items = {
	"apples": {"count": 0, "value": 1, "active": true, "level": "forest", "scene": preload("res://scenes/resources/apple.tscn"), "icon": preload("res://apple.png")},
	"blueberries": {"count": 0, "value": 1, "active": false, "level": "forest", "scene": preload("res://scenes/resources/blueberry.tscn"), "icon": preload("res://blueberry.png")},
	"bones": {"count": 0, "value": 1, "active": false, "level": "desert", "scene": preload("res://scenes/resources/bone.tscn"), "icon": preload("res://bone.png")},
}

func add(name: String, count: int):
	items[name].count += count
	emit_signal("item_added", name, count)

func spawn(name: String):
	return items[name].scene.instantiate()

func activate_item(item: String):
	items[item].active = true
	G.ui.get_node("upgrade_panel").reload()
	emit_signal("item_activated", item)

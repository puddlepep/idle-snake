extends Node2D
class_name Land

@export var description = "a cool land :D"

var enabled = false
var cost = {}

signal area_size_changed
signal land_entered

var resources = ["apples"]
var upgrades = {
	"speed": Upgrade.linear("speed", 3.0, 25, {}),
	"turn speed": Upgrade.linear("turn speed", 0.05, 25, {}),
	"item spawn speed": Upgrade.linear("item spawn speed", 1.0, 25, {}),
	"item max": Upgrade.increment("item max", 1, 1, {})
}

func get_upgrade(name: String) -> Upgrade:
	return upgrades[name]

func add_upgrade(upgrade: Upgrade):
	upgrades[upgrade.name] = upgrade

func _on_level_unlocked():
	print("unlocked " + name)

func _on_land_entered():
	print("entered " + name)

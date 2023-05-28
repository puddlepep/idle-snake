extends Object
class_name Upgrade

enum Type { CUSTOM, LINEAR, INCREMENT }
signal upgraded

var name: String
var description: String
var next_upgrade_addition: String
var type: Type

var level: int

var value
var initial_value
var cost: Dictionary
var cost_multiplier: float = 1.5

var percentage_increment: int:
	set(new):
		percentage_increment = new
		if type == Type.LINEAR:
			next_upgrade_addition = "+%d%%" % abs(new)

var integer_increment: int:
	set(new):
		integer_increment = new
		if type == Type.INCREMENT:
			next_upgrade_addition = "+%d" % new

static func linear(name: String, value, percentage_increment: int, cost: Dictionary) -> Upgrade:
	var upgrade = Upgrade.new()
	
	upgrade.name = name
	upgrade.description = "100%"
	upgrade.next_upgrade_addition = "+%d%%" % abs(percentage_increment)
	upgrade.percentage_increment = percentage_increment
	upgrade.type = Type.LINEAR
	upgrade.value = value
	upgrade.initial_value = value
	upgrade.cost = cost
	upgrade.level = 0
	
	return upgrade

static func increment(name: String, value, increment: int, cost: Dictionary) -> Upgrade:
	var upgrade = Upgrade.new()
	
	upgrade.name = name
	upgrade.description = str(value)
	upgrade.next_upgrade_addition = "+%d" % increment
	upgrade.integer_increment = increment
	upgrade.type = Type.INCREMENT
	upgrade.value = value
	upgrade.initial_value = value
	upgrade.cost = cost
	upgrade.level = 0
	
	return upgrade

static func custom(name: String, description: String, next_upgrade_addition: String, value, cost) -> Upgrade:
	var upgrade = Upgrade.new()
	
	upgrade.name = name
	upgrade.description = description
	upgrade.next_upgrade_addition = next_upgrade_addition
	upgrade.type = Type.CUSTOM
	upgrade.value = value
	upgrade.initial_value = value
	upgrade.cost = cost
	upgrade.level = 0
	
	return upgrade

func set_initial_value(value):
	self.value = value
	self.initial_value = value

func get_linear_multiplier():
	return 1.0 + ((level * percentage_increment) / 100.0)

func _update_cost():
	for c in cost.keys():
		cost[c] = round(cost[c] * cost_multiplier)

func upgrade():
	level += 1
	match type:
		Type.LINEAR:
			value = initial_value * get_linear_multiplier()
			description = "%d%%" % (100 + (level * percentage_increment))
			_update_cost()
		
		Type.INCREMENT:
			value += integer_increment
			description = "%d" % value
			_update_cost()
	
	upgraded.emit(self)

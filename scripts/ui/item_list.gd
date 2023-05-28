extends MarginContainer

var item_scn = preload("res://scenes/inventory_resource.tscn")

func _ready():
	G.connect("current_level_changed", reload)
	Numbers.connect("item_added", update)
	Numbers.connect("item_activated", func(item): reload())

func reload():
	for c in $container.get_children():
		c.name = "deleting" # need to do because queue_free keeps them around for a minute
		c.queue_free()
	
	for i in Numbers.items.keys():
		var item = Numbers.items[i]
		if item.level != G.current_level.name: continue
		if not item.active: continue
		
		var item_ui = item_scn.instantiate()
		item_ui.get_node("label").text = str(item.count)
		item_ui.get_node("icon").texture = item.icon
		item_ui.name = i
		$container.add_child(item_ui)

func update(name, count):
	$container.get_node(name).get_node("label").text = str(Numbers.items[name].count)

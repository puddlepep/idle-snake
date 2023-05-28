extends Panel

var inventory_resource_scn = preload("res://scenes/inventory_resource.tscn")

func _process(delta):
	for i in Numbers.items.keys():
		if Numbers.items[i].active:
			if not $content/container.has_node(i):
				var inventory_resource = inventory_resource_scn.instantiate()
				inventory_resource.name = i
				inventory_resource.get_node("icon").texture = Numbers.items[i].icon
				inventory_resource.get_node("label").text = "%s - %d" % [i, Numbers.items[i].count]
				$content/container.add_child(inventory_resource)
			else:
				var inventory_resource = $content/container.get_node(i)
				inventory_resource.get_node("label").text = "%s - %d" % [i, Numbers.items[i].count]

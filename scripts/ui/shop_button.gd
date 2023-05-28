extends Control

var upgrade: Upgrade

func _ready():
	$button.connect("pressed", try_upgrade)
	$container/separator/upgrade_description/addition.connect("draw", 
		func(): $container/separator/upgrade_description/addition.position.x = $container/separator/upgrade_description.size.x + 5
	)
	
	update()

func update():
	
	$container/separator/upgrade_name.text = upgrade.name
	$container/separator/upgrade_description.text = upgrade.description
	$container/separator/upgrade_description/addition.text = upgrade.next_upgrade_addition
	
	for child in $container/separator/costs.get_children():
		child.queue_free()
	
	if upgrade.cost.is_empty():
		visible = false
		return
	else:
		visible = true
	
	for c in upgrade.cost.keys():
		
		if Numbers.items[c].active == false:
			visible = false
			return
		
		var container = HBoxContainer.new()
		container.name = "cost"
		container.mouse_filter = Control.MOUSE_FILTER_IGNORE
		
		var icon = TextureRect.new()
		icon.name = "icon"
		icon.expand_mode = TextureRect.EXPAND_FIT_WIDTH
		icon.texture = Numbers.items[c].icon
		icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
		
		var count = Label.new()
		count.name = "count"
		count.text = str(upgrade.cost[c])
		count.mouse_filter = Control.MOUSE_FILTER_IGNORE
		
		container.add_child(icon)
		container.add_child(count)
		$container/separator/costs.add_child(container)

func try_upgrade():
	if not Input.is_action_pressed("free_buy"):
		for c in upgrade.cost.keys():
			var v = upgrade.cost[c]
			
			if Numbers.items[c].count < v:
				return
		
		for c in upgrade.cost.keys():
			var v = upgrade.cost[c]
			Numbers.add(c, -v)
	
	upgrade.upgrade()
	update()

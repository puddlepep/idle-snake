extends Node

var current:
	get:
		if G.current_level and is_instance_valid(G.current_level):
			return G.current_level.upgrades
		else:
			return null

extends Node

var world




func get_data():
	var map = world.map
	var data = {
		"mouse_position":map.mouse_position,
		"world_position":map.world_position,
		"hex_position":map.hex_position,
		"hex_id":map.hex_tile,
		"cell_position":map.cell_position,
		"biome":map.biome,
		"local_id":map.local_tile,
		"feature":map.feature
	}
	return data

func load_world(world):
	if self.world != null: self.world.queue_free()
	self.world = world
	world.map.active = true
	add_child(world)

func refresh(camera):
	world.map.refresh(camera.position, camera.zoom_level)

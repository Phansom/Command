extends Node2D

onready var toolkit = get_node("/root/Program/View/GUI/Toolbar/Toolkit")

signal structure_built(structure, tile)
signal tool_used(used_tool)
signal feature_placed(feature, tile)
signal feature_cleared(tile)

var selected_tool
var selected_item
var active = false
var start_tile
var end_tile
var map



func load_map(map):
	self.map = map

func select_tool(selected_tool):
	self.selected_tool = selected_tool

func select_item(selected_item):
	self.selected_item = selected_item

func use_tool():
	if selected_tool == null: return
	match selected_tool:
		"examine" : _examine()
		"build"	 : _build()
		"command": _command()


func _activate_tool():
	pass

func _examine():
	pass

func _build():
	var structure = toolkit.selected_item
	var tile = map.local_map.local_tile
	emit_signal("structure_built", structure, tile)

func _command():
	pass



func _get_tile(mouse_position):
	var world_position = map.mouse_to_world(mouse_position)
	var hex = map.hex_map.hovered_hex
	var local_coords = map.local_map.get_local_coords(world_position, map.hex_map.world_position)
	var tile = map.local_map.get_local_tile(hex, local_coords)

	return tile


func _on_mouse_pressed(position):
	if !active: return
	if !map.local_map.hovered_tile: return
	start_tile = _get_tile(position)
	
func _on_mouse_released(position):
	if !active: return
	if !map.local_map.hovered_tile: return
	end_tile = _get_tile(position)
	
	if start_tile == end_tile and end_tile > -1:
		use_tool()

func _on_mouse_right_click(position):
	if !active: return
	if !map.local_map.hovered_tile: return
	start_tile = _get_tile(position)

func _on_mouse_right_released(position):
		if !active: return
		if !map.local_map.hovered_tile: return
		end_tile = _get_tile(position)
	
		if start_tile == end_tile:
			emit_signal("feature_cleared", end_tile)

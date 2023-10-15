extends Node2D



###############################################################################
###############################################################################

const BIOMES = ["water", "cool_desert", "scrubland", "hot_desert", "cold_parkland", "grassland", "savanna", "boreal_forest", "temperate_forest", "tropical_forest", "mountain"]

###############################################################################

onready var hex_map = $HexMap
onready var local_map = $LocalMap
onready var pawn_map = $PawnMap
onready var local_outline = $LocalOutline
onready var local_outline_blueprint = $LocalOutline/Blueprint

###############################################################################

var rng = RandomNumberGenerator.new()

onready var exists = true
onready var active = true
var mouse_position
var world_position
var hex_position
var cell_position
var hex_tile
var camera_position
var camera_zoom
var biome
var feature
var local_tile


###############################################################################
###############################################################################

func _ready():
	rng.randomize()


func refresh(camera_position, camera_zoom):
	self.camera_position = camera_position
	self.camera_zoom = camera_zoom
	
	mouse_position = get_viewport().get_mouse_position() - get_viewport_rect().size/2
	world_position = mouse_to_world(mouse_position)
	hex_position = hex_map.world_to_hex(world_position)
	
	var local_position = hex_map.to_local(world_position)
	local_tile = local_map.local_tile
	cell_position = hex_map.world_to_map(local_position)
	hex_tile = hex_map.hovered_hex
	biome = BIOMES[hex_map.biome]
	feature = local_map.features[local_tile]
	
	hex_map.refresh(world_position)
	local_map.refresh(world_position, hex_map.world_position, hex_map.hovered_hex)
	pawn_map.refresh()


###############################################################################

func clear():
	hex_map.clear()
	local_map.clear()
	exists = false
	active = false

func build_map(positions, biomes, features):
	clear()
	for i in positions.size():
		hex_map.add_hex(positions[i], biomes[i])
	local_map.add_locals(hex_map.world_positions, features)
	exists = true
	active = true

func mouse_to_world(mouse_position):
	var world_position = (camera_position + mouse_position * camera_zoom)
	world_position.x = round(world_position.x)
	world_position.y = round(world_position.y)
	return world_position

func add_tile(hex_position):
	hex_map.add_hex(hex_position)
	local_map.add_locals(hex_map.world_positions[-1], hex_map.biomes[-1])

func load_local_outline(texture):
	local_outline_blueprint.texture = texture

###############################################################################

func _on_feature_placed(feature, tile):
	var hex = hex_map.get_hex_from_local_tile(tile)
	local_map.add_feature(feature, tile)

###############################################################################
###############################################################################

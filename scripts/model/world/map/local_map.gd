class_name LocalMap

extends Node2D

################################################################################
################################################################################

const local_size = Vector2(16,16)
const hex_local_tiles = [
	Vector2(-1,-2),  Vector2(0,-2),  Vector2(1,-2),
	Vector2(-1,-1),  Vector2(0,-1),  Vector2(1,-1),  Vector2(2,-1),
	Vector2(-2,0),   Vector2(-1,0),  Vector2(0,0),   Vector2(1,0),  Vector2(2,0),
	Vector2(-1,1),   Vector2(0,1),   Vector2(1,1),   Vector2(2,1),
	Vector2(-1,2),   Vector2(0,2),   Vector2(1,2) ]
const local_positions = [
	Vector2(-16,-32), Vector2(0,-32),  Vector2(16,-32),
	Vector2(-24,-16), Vector2(-8,-16), Vector2(8,-16),  Vector2(24,-16),
	Vector2(-32,0),   Vector2(-16,0),  Vector2(0,0),    Vector2(16,0),   Vector2(32,0),
	Vector2(-24,16),  Vector2(-8,16),  Vector2(8,16),   Vector2(24,16),
	Vector2(-16,32),  Vector2(0,32),   Vector2(16,32) ]
const feature_textures = {
	"hut":"res://assets/textures/features/hut.png",
	"tree":"res://assets/textures/features/tree.png",
	"vegetation":"res://assets/textures/features/vegetation.png",
	"grass":"res://assets/textures/features/grass.png",
	"lodge":"res://assets/textures/features/lodge.png",
	"hall":"res://assets/textures/features/hall.png",
	"post": "res://assets/textures/features/post.png"
	
}
const HEIGHTS = [0,1,1,1,1,1,1,1,1,1,2]
const MOISTURES = [2,0,0,0,1,1,1,2,2,2,0]
const TEMPERATURES = [2,0,1,2,0,1,2,0,1,2,0]
const MOISTURE_TREE_RATES = [0.1, 0.4, 0.7]

################################################################################

onready var local_outline = $LocalOutline

################################################################################

var world_positions = []
var features = []
var feature_tiles = []
var feature_sprites = []

var hovered_tile = false
var local_tile = 0
var local_position


################################################################################
################################################################################

func refresh(world_position, hex_position, hex_id):
	var local_coords = get_local_coords(world_position, hex_position)
	
	if (!hex_local_tiles.has(local_coords)) or hex_id == -1:
		local_outline.visible = false
		hovered_tile = false
		return
	
	hovered_tile = true
	local_tile = get_local_tile(hex_id, local_coords)
	local_outline.visible = true
	local_position = local_coords * 16 + hex_position
	local_outline.position = local_position
	
	if abs(local_coords.y) == 1:
		local_outline.position.x -= 8

func clear():
	world_positions.clear()
	features.clear()
	feature_tiles.clear()
	for object in feature_sprites:
		object.queue_free()
	feature_sprites.clear()


################################################################################


func add_locals(world_positions, features):
	self.features = features
	var hex_tally = 0
	for hex_world_position in world_positions:
		for i in 19:
			var tile_position = hex_world_position + local_positions[i]
			_add_local_tile(tile_position, features[hex_tally + i])
		hex_tally += 19

func _add_local_tile(tile_position, feature):
	var tile = world_positions.size()
	world_positions.append(tile_position)
	if feature != null:
		add_feature(feature, tile)

func generate_feature(biome):
	if HEIGHTS[biome] != 1: return
	var tree_rate = MOISTURE_TREE_RATES[MOISTURES[biome]]
	
	var roll = rand_range(0,1)
	if roll < tree_rate:
		return "tree"

func add_structures(structures):
	
	for structure in structures:
		var tiles = structures[structure]
		
		for tile in tiles:
			features[tile] = structure

func add_feature(feature, local_tile):
	features.append(feature)
	feature_tiles.append(local_tile)
	_init_feature(feature, world_positions[local_tile])

func _init_feature(feature, position):
	var sprite = Sprite.new() 
	sprite.position = position
	if feature_textures.has(feature):
		sprite.texture = load(feature_textures[feature])

	add_child(sprite)
	feature_sprites.append(sprite)

func remove_feature(local_tile):
	var index = feature_tiles.find(local_tile)
	var sprite = feature_sprites[index]
	
	features.remove(index)
	feature_tiles.remove(index)
	feature_sprites.remove(index)
	
	sprite.queue_free()

func get_local_tile(hex_id, local_coords):
	var local_id = hex_local_tiles.find(local_coords)
	return hex_id * 19 + local_id


################################################################################


func _on_feature_placed(feature, tile):
	if feature_tiles.has(tile):
		remove_feature(tile)
	add_feature(feature, tile)

func _on_feature_cleared(tile):
	if feature_tiles.has(tile):
		remove_feature(tile)


################################################################################


static func get_local_coords(world_position, hex_position):
	var local_position = world_position - hex_position
	
	var y = round(local_position.y/16)
	
	if abs(y) == 1: local_position.x += 8
	
	var x = round(local_position.x/16)
	
	return Vector2(x,y)

static func get_local_tiles(hex_id):
	var local_tiles = []
	for i in 19:
		local_tiles.append(19 * hex_id + i)
	return local_tiles


################################################################################
################################################################################

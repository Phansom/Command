extends Node

onready var individual_generator = get_node("../IndividualGenerator")

var world
var civ
var env
var map
var tribe_scene = preload("res://scenes/Tribe.tscn")
var tribe
var rng

const TRIBE_STARTING_DENSITY = 15
const BIOME_SETTLEMENT_SUITABILITIES = [0, 1, 1, 1, 5, 25, 5, 1, 1, 1, 0]
const INDIVIDUAL_NAMES = ["Asa", "Brok", "Cal", "Din", "Erin", "Fob", "Grax", "Hok", "Ira", "Jon", "Kru", "Lim", "Mag", "Nino", "Oka", "Pit", "Quan", "Reva", "Sik", "Tun", "Uko", "Von", "Wan", "Xi", "Yun", "Zan"]


func _init():
	rng = RandomNumberGenerator.new()


func generate_tribe(size):
	randomize()
	tribe = tribe_scene.instance()
	civ.add_child(tribe)
	tribe._initialize()
	
	var spawn_tiles = _get_spawn_tiles(size)
	var local_tiles = _get_local_tiles(spawn_tiles)
	
	tribe.identity.tiles = spawn_tiles
	tribe.identity.structures = _generate_structures(size, local_tiles)
	tribe.identity.individuals = individual_generator.spawn_starting_individuals(size)
	
	return tribe

func _load_world(_world):
	world = _world
	civ = world.civilization
	env = world.environment
	map = world.map

func _generate_structures(size, available_locals):
	var structures = []
	
	var center_tile = available_locals[9]
	available_locals.erase(center_tile)
	structures.append(Structure.new("hall",center_tile))
	
	for struct in STRUCTURE_RATES:
		var rate = STRUCTURE_RATES[struct]
		var count = floor(rate * size)
		if count == 0: count = 1
		
		for i in count:
			var roll = rng.randi_range(0, available_locals.size() - 1)
			var tile = available_locals[roll]
			available_locals.erase(tile)
			var structure = Structure.new(struct,tile)			
			structures.append(structure)
	
	return structures

func _get_spawn_tiles(size):
	var spawn_hex = _get_spawn_hex()
	# var num_hexes = ceil(size / TRIBE_STARTING_DENSITY)
	var tiles = _get_tiles([spawn_hex])
	
	return tiles

func _get_tiles(hexes):
	var tiles = {}
	for hex in hexes:
		var locals = _get_hex_locals(hex)
		tiles[hex] = locals
	return tiles

func _get_spawn_hex():
	var hex
	var biomes = env.biomes
	var size = biomes.size()
	
	var max_suitability = 0
	var suitability = []
	for biome in biomes:
		var ts = BIOME_SETTLEMENT_SUITABILITIES[biome]
		suitability.append(ts)
		max_suitability += ts
	
	var counter = 0
	var roll = rand_range(0, max_suitability)
	for i in size:
		counter += suitability[i]
		
		if counter >= roll:
			hex = i
			break
	
	
	return hex

static func _get_local_tiles(tiles):
	var locals = []
	for tile in tiles:
		for local in tiles[tile]:
			locals.append(local)
	return locals

static func _get_hex_locals(hex):
	var locals = []
	var base = hex * 19
	
	for i in 19:
		locals.append(i + base)
		
	return locals

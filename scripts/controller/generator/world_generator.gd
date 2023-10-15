extends Node2D

signal world_generated()

onready var settings = get_node("/root/Program/Settings")
onready var world_controller = $WorldController

var world_scene = preload("res://scenes/World.tscn")
var world
var env
var civ
var map
var rng
var open_simplex_noise

const DEFAULT_MAP_SCALE = 5
const DEFAULT_NUM_TRIBES = 1
const DEFAULT_TRIBE_SIZE = 10

const ELEVATION_THRESHOLDS 	 = [0.25, 0.85]
const MOISTURE_THRESHOLDS  	 = [0.2, 0.7]
const TEMPERATURE_THRESHOLDS = [0.3, 0.7]

const MOISTURE_LATITUDE_WEIGHT = 0.7
const MOISTURE_NOISE_WEIGHT = 0.3
const TEMPERATURE_LATITUDE_WEIGHT = 0.7
const TEMPERATURE_NOISE_WEIGHT = 0.3

const GRASS_RATES =      [0, 0.1,  0.15, 0.1,  0.8, 1,    1,   0.8, 1,   1,   0.1 ]
const VEGETATION_RATES = [0, 0.05, 0.07, 0.08, 0.4, 0.4,  0.3, 0.8, 0.8, 0.8, 0.1 ]
const TREE_RATES = 		 [0, 0.05, 0.04, 0.03, 0.3, 0.25, 0.2, 0.7, 0.7, 0.7, 0.15]
const NATURA_RATES = { "tree":TREE_RATES, "vegetation":VEGETATION_RATES, "grass":GRASS_RATES }


const STARTING_BIRTHTICK_RANGE = [-1352, -936]
const STRUCTURE_RATES = {"hut":1,"post":0.15,"lodge":0.1}

var map_scale
var hex_positions
var map_size

func _init():
	rng = RandomNumberGenerator.new()
	open_simplex_noise = OpenSimplexNoise.new()
	
	open_simplex_noise.octaves = 4
	open_simplex_noise.period = 50
	open_simplex_noise.lacunarity = 2.5
	open_simplex_noise.persistence = 0.4

func refresh():
	randomize()
	open_simplex_noise.seed = randi()

func quick_start():
	var scale = DEFAULT_MAP_SCALE
	var num_tribes = DEFAULT_NUM_TRIBES
	var tribe_size = DEFAULT_TRIBE_SIZE
	
	generate_world(scale, num_tribes, tribe_size)


func generate_world(scale, num_tribes, tribe_size):
	refresh()
	
	world = world_scene.instance()
	get_tree().root.get_child(0).add_child(world)
	civ = world.civilization
	env = world.environment
	map = world.map
	
	map_scale = scale	
	hex_positions = get_hex_positions(scale, false)
	map_size = hex_positions.size()
	
	generate_environment()
	generate_civilization()

	var features = _insert_structures_into_features(civ.identity.structures, env.natura)
	world.map.build_map(hex_positions, env.biomes, features)
	
	emit_signal("world_generated", world)


func generate_environment():
	env.elevation = generate_elevation(map_scale, hex_positions)
	env.temperature = generate_temperature(map_scale, hex_positions)
	env.moisture = generate_moisture(map_scale, hex_positions)
	env.biomes = get_biomes(env.elevation, env.temperature, env.moisture)
	env.natura = generate_natura(env.biomes)

func generate_civilization():
	var names = ["enkadu"]
	var sizes = [10]
	var cultures = ["enka"]
	var hexes = [ 0 ]
	
	generate_identity(names, sizes, cultures, hexes)
	generate_society()
	
	
	# IDENTITY
	#	SETTLEMENTS
	#	INDIVIDUALS
	#	STRUCTURES
	
	# SOCIETY
	#	COMMUNITIES
	#	FAMILIES
	#	CLANS
	
	# ECONOMY
	#	MARKETS
	#	AGENTS
	#	RESOURCES
	
	# POLITICS
	#	TRIBES
	#	ACTORS
	#	FACTIONS
	





func generate_elevation(scale, positions):
	var elevation = []
	var noise = []
	var size = positions.size()
	
	for i in size:
		var position = hex_positions[i]
		noise.append(open_simplex_noise.get_noise_2d(float(position.x), float(position.y)))
	
	elevation = normalize_array(noise)
	return elevation

func generate_temperature(scale, positions):
	var temperature = []
	
	for position in positions: 
		
		var noise = rand_range(0,1)
		var lat = get_latitude(scale, position)
		var temp = noise * TEMPERATURE_NOISE_WEIGHT + temperature_from_latitude(lat) * TEMPERATURE_LATITUDE_WEIGHT 
		temperature.append(temp)
		
	return temperature

func generate_moisture(scale, positions):
	var moisture = []
	
	for position in positions:
		
		var noise = rand_range(0,1)
		var lat = get_latitude(scale, position)
		var mois = noise * MOISTURE_NOISE_WEIGHT + moisture_from_latitude(lat) * MOISTURE_LATITUDE_WEIGHT
		moisture.append(mois)
		
	return moisture

func generate_natura(biomes):
	var natura = []
	for biome in biomes:
		for i in 19:
			natura.append(roll_tile_natura(biome))
	return natura

func roll_tile_natura(biome):
	var features = []
	
	if biome == 0: return features
	
	for natura_key in NATURA_RATES:
		
		var roll = rand_range(0,1)		
		var natura_rates = NATURA_RATES[natura_key]
		var rate = natura_rates[biome]
		
		if roll <= rate:
			return natura_key
			
	return "none"




func generate_identity(names, sizes, cultures, hexes):
	var settlements = []
	for i in names.size():
		var settlement = generate_settlement(names[i], sizes[i], cultures[i], hexes[i])
		settlements.append(settlement)

	civ.identity._load(settlements)

func generate_settlement(name, size, culture, hex):
	var individuals = generate_individuals(size, culture)
	var structures = generate_structures(size, hex)
	var settlement = Settlement.new(name, individuals, structures)
	
	return Settlement.new(name, individuals, structures)

func generate_individuals(size, culture):
	var individuals = []
	for i in size:
		var female = generate_individual("female", culture)
		var male = generate_individual("male", culture)
		
		female.partner = male
		male.partner = female
		
		individuals.append(female)
		individuals.append(male)
		
	return individuals

func generate_individual(sex, culture):
	var name = Individual.NAMES[Util.roll(Individual.NAMES.size())]
	var birthtick = rng.randi_range(STARTING_BIRTHTICK_RANGE[0], STARTING_BIRTHTICK_RANGE[1])
	var birthturn = Turn.new(birthtick)
	var attributes = {"name":name,"sex":sex,"age":Age.new(Individual.get_age_val(birthtick, 0)), "birthturn":birthturn}
	return Individual.new(attributes)

func generate_structures(size, hex_id):
	var structure_data = {}
	for key in STRUCTURE_RATES:
		var count = ceil(size * STRUCTURE_RATES[key])
		structure_data[key] = count
	
	var available_tiles = LocalMap.get_local_tiles(hex_id)
	
	var structures = []
	structures.append(Structure.new("hall", available_tiles[9]))
	available_tiles.erase(available_tiles[9])
	for key in structure_data:
		
		for i in structure_data[key]:
			
			var tile = available_tiles[Util.roll(available_tiles.size())]
			var structure = Structure.new(key, tile)
			structures.append(structure)
			available_tiles.erase(tile)
	
	return structures




func generate_society():
	var communities = []
	for settlement in civ.identity.settlements:
		var families = generate_families(settlement)
		var community = Community.new(settlement, families)
		communities.append(community)
		
	civ.society.load_communities(communities)

func generate_families(settlement):
	var inds = settlement.individuals
	var pairs = inds.size()/2
	var families = []
	for i in pairs:
		var parents = [inds[i * 2], inds[i * 2 + 1]]
		var family = Family.new(parents)
		families.append(family)
		parents[0].partner = parents[1]
		parents[1].partner = parents[0]
	return families





static func normalize_array(array):
	var minVal = array.min()
	var maxVal = array.max()
	for i in range(0, array.size()):
		array[i] = range_lerp(array[i], minVal, maxVal, 0.0, 1.0)
	return array

static func get_latitude(scale, position):
	return abs(position.y + 0.5 * position.x)/scale

static func moisture_from_latitude(latitude):
	var l = latitude * 3
	if l >= 2:
		l -= 2

	return abs(l - 1)

static func temperature_from_latitude(latitude):
	return 1 - latitude

static func get_biomes(elevation, temperature, moisture):
	var biomes = []
	
	for i in elevation.size():
		
		if elevation[i] <= ELEVATION_THRESHOLDS[0]:
			biomes.append(0)
			
		elif elevation[i] >= ELEVATION_THRESHOLDS[1]:
			biomes.append(10)
			
		else:
			var temp = get_id(temperature[i], TEMPERATURE_THRESHOLDS)
			var mois = get_id(moisture[i], MOISTURE_THRESHOLDS)
			biomes.append(get_biome_id(temp, mois))
	
	biomes[0] = 5
	return biomes

static func get_hex_positions(scale, wrap):
	var positions = []
	positions.append(Vector2(0,0))
	for i in range(1, scale + 1):
		var last_position = Vector2(0,-i)
		var ring_size = 6 * i
		for j in ring_size:
			var direction = floor(j/i)
			var position = translate_positions(last_position, HexMap.DIRECTIONS[direction])
			last_position = position
			position = Vector2(position.x, floor(position.y))
			positions.append(position)
	
	if wrap:
		var position = Vector2(scale + 1, -scale - 1)
		
		for i in scale + 2:
			positions.append(position)
			position -= Vector2(0, -1)
	
	return positions

static func translate_positions(pos, dir):
	pos.x += dir.x
	pos.y += dir.y
	return pos

static func get_biome_id(temp, mois):
	return 1 + temp + (mois * 3)

static func get_id(value, thresholds):
	var i = 0
	for threshold in thresholds:

		if value >= threshold:
			i += 1
	
	return i

static func _insert_structures_into_features(structures, natura):
	var features = natura.duplicate()
	for structure in structures:
		features[structure.local_tile] = structure.key
	return features




extends TileMap
class_name HexMap

onready var rng = RandomNumberGenerator.new()
onready var hex_outline = $HexOutline


const CUBE_DIRECTION_VECTORS = [
	Vector3(+1, 0, -1), Vector3(+1, -1, 0), Vector3(0, -1, +1), 
	Vector3(-1, 0, +1), Vector3(-1, +1, 0), Vector3(0, +1, -1) ]
const DIRECTIONS_DICT = {
	"SE":Vector2(1,0),	
	"S":Vector2(0,1),
	"SW":Vector2(-1,1),
	"NW":Vector2(-1,0),
	"N":Vector2(0,-1),
	"NE":Vector2(1,-1) }
const DIRECTIONS = [
	DIRECTIONS_DICT["SE"],
	DIRECTIONS_DICT["S"],
	DIRECTIONS_DICT["SW"],
	DIRECTIONS_DICT["NW"],
	DIRECTIONS_DICT["N"],
	DIRECTIONS_DICT["NE"], ]
const TILE_DIRECTIONS = [
	Vector2(1,0.5),	
	Vector2(0,1),
	Vector2(-1,0.5),
	Vector2(-1,-0.5),
	Vector2(0,-1),
	Vector2(1,-0.5) ]
const ORIENTATION = [3.0/2.0, 0.0, sqrt(3.0)/2.0, sqrt(3.0),
					 2.0/3.0, 0.0, -1.0/3.0, sqrt(3.0)/3.0, 
					 0.0]
const HEX_SIZE = Vector2(50, 49.6521231503)
const ORIGIN = Vector2(0,0)
const HEIGHTS = [0,1,1,1,1,1,1,1,1,1,2]
const MOISTURES = [2,0,0,0,1,1,1,2,2,2,0]
const TEMPERATURES = [2,0,1,2,0,1,2,0,1,2,0]


var size
var biomes = []

var map_positions = []
var world_positions = []
var cell_positions = []

var hovered_hex
var map_position
var world_position
var biome = 0


func _ready():
	rng.randomize()


func refresh(global_world_position):
	map_position = world_to_hex(global_world_position)
	world_position = (hex_to_world(map_position))
	hovered_hex = map_positions.find(map_position)
	hex_outline.position = world_position
	biome = biomes[hovered_hex]
	
	if hovered_hex == -1:
		hex_outline.hide()
	else:
		hex_outline.show()



func init_hex(cell_position, tile):
	set_cellv(cell_position, 0, false, false, false, Vector2(tile, 0))

func hex_to_cell_position(hex_position):
	var world_position = hex_to_world(hex_position)
	var cell_position = world_to_map(world_position)
	return cell_position

func hex_to_cell_positions(map_positions):
	var cell_positions = []
	for hex_position in map_positions:
		var cell_position = hex_to_cell_position(hex_position)
		cell_positions.append(cell_position)
	return cell_positions

func add_hex(map_position, biome):
	biomes.append(biome)
	map_positions.append(map_position)
	cell_positions.append(hex_to_cell_position(map_position))
	world_positions.append(hex_to_world(map_position))
	init_hex(cell_positions[-1], biomes[-1])

func generate_biome(map_position):
	var neighbors = get_neighbors(map_position)
	
	var height_weights = [1,2,1]
	var moisture_weights = [1,3,1]
	var temperature_weights = [1,3,1]
	
	for neighbor in neighbors:
		var nb = biomes[neighbor]
		
		height_weights[HEIGHTS[nb]] += 2
		if HEIGHTS[nb] == 0: height_weights[HEIGHTS[nb]] += 2
		moisture_weights[MOISTURES[nb]] += 2
		temperature_weights[TEMPERATURES[nb]] += 2
	
	var height = roll_array(height_weights)
	var moisture = roll_array(moisture_weights)
	var temperature = roll_array(temperature_weights)
	
	return get_biome(height, moisture, temperature)

func get_biome(height, moisture, temperature):
	if height == 0: return 0
	elif height == 2: return 10
	else: return height + moisture * 3 + temperature 

func get_neighbors(map_position):
	var neighbors = []
	var neighbor_positions = get_neighbor_positions(map_position)
	for position in neighbor_positions:
		if map_positions.has(position):
			neighbors.append(map_positions.find(position))
	return neighbors

func get_empty_neighbors(map_position):
	var empty_neighbors = []
	var neighbor_positions = get_neighbor_positions(map_position)
	for neighbor_position in neighbor_positions:
		if !map_positions.has(neighbor_position):
			empty_neighbors.append(neighbor_position)
	return empty_neighbors

func roll_array(array):
	var weight = add_array(array)
	var roll = rng.randi_range(0, weight - 1)
	var count = 0
	var total = 0
	for val in array:
		total += val
		if total > roll:
			return count
		count += 1

func add_array(array):
	var count = 0
	for entry in array:
		count += entry
	return count

static func mouse_to_world(mouse_position, camera_position, camera_zoom):
	var world_position = (camera_position + mouse_position * camera_zoom)
	return world_position

static func hex_to_world(hex):
	var x = (ORIENTATION[0] * hex.x + ORIENTATION[1] * hex.y) * HEX_SIZE.x
	var y = (ORIENTATION[2] * hex.x + ORIENTATION[3] * hex.y) * HEX_SIZE.y
	return Vector2(x,y)

static func world_to_hex(pos):
	var pt = Vector2( (pos.x - ORIGIN.x) / HEX_SIZE.x, (pos.y - ORIGIN.y) / HEX_SIZE.y )
	var q = ORIENTATION[4] * pt.x + ORIENTATION[5] * pt.y
	var r = ORIENTATION[6] * pt.x + ORIENTATION[7] * pt.y
	return axial_round(Vector2(q,r))

static func cube_round(cube_pos):
	var q = round(cube_pos.x)
	var r = round(cube_pos.y)
	var s = round(cube_pos.z)
	
	var q_diff = abs(q - cube_pos.x)
	var r_diff = abs(r - cube_pos.y)
	var s_diff = abs(s - cube_pos.z)
	
	if q_diff > r_diff and q_diff > s_diff:
		q = -r - s
	elif r_diff > s_diff:
		r = -q - s
	else:
		s = -q - r
	return Vector3(q,r,s)	

static func axial_round(hex):
	return cube_to_axial(cube_round(axial_to_cube(hex)))

static func cube_to_axial(cube):
	var q = cube.x
	var r = cube.y
	return Vector2(q,r)

static func axial_to_cube(hex):
	var q = hex.x
	var r = hex.y
	var s = -q-r
	return Vector3(q,r,s)

static func cube_subtract(a, b):
	return Vector3(a.x - b.x, a.y - b.y, a.z - b.z)

static func cube_distance(a, b):
	var vec = cube_subtract(a,b)
	return (abs(vec.x) + abs(vec.y) + abs(vec.z)) / 2

static func axial_distance(a,b):
	return (abs(a.x - b.x)
		  + abs(a.x + a.y - b.x - b.y)
		  + abs(a.y - b.y)) / 2

static func cube_add(hex, vec):
	return Vector3(hex.x + vec.x, hex.y + vec.y, hex.z + vec.z)

static func cube_neighbor(cube, direction):
	return cube_add(cube, cube_direction(direction))

static func cube_ring(center, radius):
	var results = []
	var hex = cube_add(axial_to_cube(center), cube_scale(cube_direction(4), radius))
	
	for i in range(6):
		for j in range(radius):
			results.append(hex)
			hex = cube_neighbor(hex, i)
	return results

static func cube_direction(direction):
	return CUBE_DIRECTION_VECTORS[direction]

static func cube_scale(hex, factor):
	return Vector3(hex.x * factor, hex.y * factor, hex.z * factor)

static func get_map_positions(hex_coordinates):
	var map_positions = []
	for hex_coord in hex_coordinates:
		var hex_position = hex_to_world(hex_coord)
		map_positions.append(hex_position)
	return map_positions

static func hex_to_world_positions(map_positions):
	var world_positions = []
	for hex_position in map_positions:
		world_positions.append(hex_to_world(hex_position))	
	return world_positions

static func get_hex_from_local_tile(local_tile):
	return floor(local_tile/19)

static func get_neighbor_positions(map_position):
	var neighbor_positions = []
	for direction in DIRECTIONS:
		neighbor_positions.append(map_position + direction)
	return neighbor_positions

	
	

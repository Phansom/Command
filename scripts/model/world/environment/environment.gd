extends Node

###############################################################################
###############################################################################


###############################################################################

const BIOME_KEYS = ["water","cool_desert","scrubland","hot_desert","cold_parkland","grassland","savanna","boreal_forest","temperate_forest","tropical_forest","mountains"]

const BIOME_ELEVATIONS =	[ 0,    1,    1,    1,    1,    1,    1,    1,    1,    1,    2    ]
const BIOME_MOISTURES = 	[ 0,    0,    0,    0,    1,    1,    1,    2,    2,    2,    2    ]
const BIOME_TEMPERATURES = 	[ 2,    0,    1,    2,    0,    1,    2,    0,    1,    2,    0    ]

const BIOME_ROCKS =			[ 0,    1,    1,    1,    1,    1,    1,    1,    1,    1,    2    ]
const BIOME_SOILS =			[ 0,    0.8,  0.8,  0.8,  1,    1,    1,    1,    1,    1,    0.2  ]
const BIOME_GRASSES =		[ 0,    0.3,  0.3,  0.3,  0.8,  0.9,  1,    0.8,  0.9,  1,    0.15 ]
const BIOME_VEGETATIONS =	[ 0,    0.1,  0.1,  0.1,  0.5,  0.55, 0.6,  0.75, 0.8,  0.9,  0.1  ]
const BIOME_TREES =			[ 0,    0.05, 0.05, 0.05, 0.3,  0.3,  0.3,  0.7,  0.7,  0.7,  0.05 ]


###############################################################################

const NATURA_TYPES = ["rock", "soil", "flora"]
const FLORA_TYPES = ["grass", "vegetation", "woods"]
const ROCK_TYPES = ["stone", "ore", "sediment"]
const SOIL_TYPES = ["sand", "silt", "clay"] # AKA "soil minerals".
# The percentages of particles in these size classes is called SOIL TEXTURE.
# LOAMY soil ranges from roughly 40-40-20 or equal parts of each type of dirt
# The soil organic matter is plant, animal, and microbial residues in various states of decomposition, and is a strong indicator of agricultural soil quality


onready var BIOME_NATURA_RATES = [BIOME_ROCKS, BIOME_SOILS, BIOME_GRASSES, BIOME_VEGETATIONS, BIOME_TREES]

###############################################################################

var elevation = []
var temperature = []
var moisture = []
var biomes = []
var natura = []

###############################################################################
###############################################################################

func turn():
	pass

###############################################################################
###############################################################################

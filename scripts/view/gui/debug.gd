extends Panel


onready var mouse_text = $Data/Mouse/Text
onready var world_text = $Data/World/Text
onready var hex_pos_text = $Data/HexPos/Text
onready var cell_text = $Data/Cell/Text
onready var hex_id_text = $Data/HexID/Text 
onready var biome_text = $Data/Biome/Text
onready var local_text = $Data/LocalID/Text
onready var feature_text = $Data/Feature/Text

const DATA_KEYS = ["local_id","feature"]
onready var texts = {
	"mouse_position":mouse_text,
	"world_position":world_text,
	"hex_position":hex_pos_text,
	"hex_id":hex_id_text,
	"cell_position":cell_text,
	"biome":biome_text,
	"local_id":local_text,
	"feature":feature_text
}


func load_data(data):
	for key in data:
		load_entry(data[key], texts[key])
	


func load_entry(data, node):
	node.text = str(data)

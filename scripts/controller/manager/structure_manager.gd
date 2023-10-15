extends Node

onready var civilization = get_node("/root/Program/World/Civilization")



const STRUCTURES = [ "hut", "lodge", "post", "hall" ]


func _on_feature_placed(feature, tile):
	if STRUCTURES.has(feature):
		civilization.add_structure(feature, tile)


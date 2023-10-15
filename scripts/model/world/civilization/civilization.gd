extends Node

onready var identity = $Identity
onready var society = $Society
onready var economy = $Economy
onready var politics = $Politics



func _update(turn):
	identity._update(turn)
	society._update(turn)
	# economy._update(turn)
	# politics._update(turn)

static func get_local_tiles(hex):
	var tiles = []
	
	var global = hex * 19
	for local in 19:
		tiles.append(global + local)
		
	return tiles





extends Node2D

onready var pawn_texture = preload("res://assets/textures/objects/pawn.png")

var pawns = []
var positions = []


func refresh():
	pass


func place_pawn(world_position):
	var sprite = Sprite.new()
	sprite.position = world_position
	sprite.texture = pawn_texture
	pawns.append(sprite)

func remove_pawn(id):
	var pawn = pawns[id]
	pawns.remove(id)
	pawn.queue_free()

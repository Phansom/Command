extends Node


onready var view = get_node("/root/Program/View")

const DEATH_RATES = []

var turn
var world
var civ
var env


func load_world(_world):
	world = _world
	civ = world.civilization
	env = world.environment

func _on_turn(turn):
	world._update(turn)
	view._update(world)
	


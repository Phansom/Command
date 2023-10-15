extends Node


const INDIVIDUAL_ATTRIBUTES = ["name","sex","age"]

signal load_data(window_key, keys, data)

onready var databar = get_node("/root/Program/View/GUI/Toolbar/Databar")

var world


func _on_update():
	databar.load_settlement(world.civilization.identity.settlements[0])

func load_world(_world):
	world = _world

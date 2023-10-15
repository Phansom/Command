extends Node

onready var input_controller = $InputController
onready var mouse_controller = $MouseController
onready var time_controller = $TimeController
onready var tool_controller = $ToolController
onready var turn_controller = $TurnController
onready var world_controller = $WorldController

onready var world_generator = $WorldGenerator
onready var tribe_generator = $TribeGenerator
onready var individual_generator = $IndividualGenerator

var world


func load_world(_world):
	world = _world
	tool_controller.load_map(world.map)
	tool_controller.active = true
	time_controller.game_speed = 1
	time_controller.on_new_game()


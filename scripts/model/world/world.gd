extends Node

onready var map = $Map
onready var civilization = $Civilization
onready var environment = $Environment


func _update(turn):
	civilization._update(turn)


extends Node


const WORLD_EVENT_KEYS = ["birth", "death", "coupling"]

onready var event_log = get_node("/root/Program/View/GUI/")

class Event:
	var key
	var message
	var date
	
	func _init(key, message, date):
		self.key = key
		self.message = message
		self.date = date



func connect_event_signals(world):
	pass

func log_event(key, message, date):
	var event = Event.new(key, message, date)
	event_log.add_event(event)




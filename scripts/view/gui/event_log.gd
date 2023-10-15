extends Panel

const EVENT_LIMIT = 30

onready var item_list = $ItemList



var events = []

func add_event(event):
	events.push_front(event)
	if events.size() > EVENT_LIMIT:
		events.remove(EVENT_LIMIT)
	load_events()

func load_events():
	item_list.clear()	
	var items = []
	for event in events:
		item_list.add_item(event.key)
		item_list.add_item(event.message)
		item_list.add_item(event.date)

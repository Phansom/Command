extends Node


const TOOLS = ["examine","build","command"]
const ITEM_POSITIONS = [Vector2(5,4),Vector2(44,4),Vector2(83,4),Vector2(122,4),Vector2(5,43),Vector2(44,43),Vector2(83,43),Vector2(122,43),Vector2(5,82),Vector2(44,82),Vector2(83,82),Vector2(122,82)]

const EXAMINE_ITEMS = ["selected_tile"]
const COMMAND_ITEMS = ["settle","attack","defend","exploit","develop","clear","grow","adopt","transact"]
const BUILD_ITEMS = ["hut","lodge","farm","workshop","smokehouse","mine","kiln"]
const ITEM_ARRAYS = {"examine": EXAMINE_ITEMS, "command":COMMAND_ITEMS, "build":BUILD_ITEMS}

onready var item_display = $ItemDisplay
onready var item_overlay = $ItemDisplay/ItemOverlay
onready var examine_item = $ItemDisplay/ExamineItem
onready var command_items = $ItemDisplay/CommandItems
onready var build_items = $ItemDisplay/BuildItems
onready var tool_items = {"examine":examine_item,"command":command_items,"build":build_items}

onready var command_settle = $ItemDisplay/CommandItems/Item
onready var command_attack = $ItemDisplay/CommandItems/Item2
onready var command_defend = $ItemDisplay/CommandItems/Item3
onready var command_exploit = $ItemDisplay/CommandItems/Item4
onready var command_develop = $ItemDisplay/CommandItems/Item5
onready var command_clear = $ItemDisplay/CommandItems/Item6
onready var command_grow = $ItemDisplay/CommandItems/Item7
onready var command_adopt = $ItemDisplay/CommandItems/Item8
onready var command_transact = $ItemDisplay/CommandItems/Item9
onready var command_item_buttons = {"settle":command_settle,"attack":command_attack,"defend":command_defend,"exploit":command_exploit,"develop":command_develop,"clear":command_clear,"grow":command_grow,"adopt":command_adopt,"transact":command_transact}

onready var build_hut = $ItemDisplay/BuildItems/Item
onready var build_lodge = $ItemDisplay/BuildItems/Item2
onready var build_farm = $ItemDisplay/BuildItems/Item3
onready var build_shed = $ItemDisplay/BuildItems/Item4
onready var build_smokehouse = $ItemDisplay/BuildItems/Item5
onready var build_mine = $ItemDisplay/BuildItems/Item6
onready var build_item_buttons = {"hut":build_hut,"lodge":build_lodge,"farm":build_farm,"shed":build_shed,"smokehouse":build_smokehouse,"mine":build_mine}

onready var tool_overlay = $ToolOverlay
onready var button_examine = $Examine
onready var button_command = $Command
onready var button_build = $Build
onready var tool_buttons = { "examine": button_examine, "command": button_command, "build": button_build }


signal tool_selected(_selected_tool)
signal item_selected(_selected_item)

var selected_tool = "none"
var selected_item = "none"


func select_tool(_selected_tool):
	
	if !TOOLS.has(_selected_tool): return
	
	if _selected_tool == selected_tool:
		tool_items[selected_tool].hide()
		selected_tool = "none"
	else:
		if selected_tool != "none": 
			tool_items[selected_tool].hide()
		selected_tool = _selected_tool
		tool_items[selected_tool].show()
		
	emit_signal("tool_selected", selected_tool)
	_place_selected_tool_overlay(selected_tool)
	load_item_display()

func select_item(_selected_item):
	emit_signal("item_selected", _selected_item)
	selected_item = _selected_item
	_place_selected_item_overlay(selected_item)

func load_item_display():
	if selected_tool == "none":
		item_display.hide()
		return
	
	item_display.show()
	_place_selected_item_overlay(selected_item)

func _place_selected_tool_overlay(_selected_tool):
	if _selected_tool == "none": 
		tool_overlay.hide()
		
	else: 
		tool_overlay.show()
		tool_overlay.set_position(tool_buttons[_selected_tool].get_position() + Vector2(17,17))

func _place_selected_item_overlay(selected_item):
	if selected_tool == "none" || selected_tool == "select" || selected_item == "none":
		item_overlay.hide()
		
	else:
		var item_array = ITEM_ARRAYS[selected_tool]
		var item_id = item_array.find(selected_item)
		item_overlay.show()
		item_overlay.set_position(ITEM_POSITIONS[item_id] + Vector2(17,17))



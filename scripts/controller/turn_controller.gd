extends Node

const TURN_SCALES = ["week", "month", "season", "year"]

signal next_turn(turn)
var turn

func _on_tick(tick):
	turn = Turn.new(tick)
	emit_signal("next_turn", turn)



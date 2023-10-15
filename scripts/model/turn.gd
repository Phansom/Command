class_name Turn

var tick
var week
var month
var month_week
var season
var season_week
var year

func _init(_tick):
	tick = _tick
	_tick = abs(tick)
	week = _tick % 52
	month = floor((_tick % 52)/4)
	month_week = week % 4
	season = floor((_tick % 52)/13)
	season_week = week % 13
	year = floor(tick/52)

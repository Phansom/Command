class_name Age

const AGE_KEYS = ["infant", "youth", "juvenile", "young adult", "adult", "old adult", "senior", "elder", "ancient"]
const AGE_VALS = [0, 4, 12, 18, 30, 45, 60, 75, 90, 1000]

var id
var key
var val
var milestone


func _init(val):
	self.val = val
	
	id = -1
	for val in AGE_VALS:
		if self.val >= val:
			id += 1
			
	key = AGE_KEYS[id]
	milestone = AGE_VALS[id + 1]

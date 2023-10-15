class_name Settlement


var community
var market
var tribe


var name
var individuals
var structures


func _init(name, individuals, structures):
	self.name = name
	self.individuals = individuals
	self.structures = structures
	for individual in individuals:
		individual.settlement = self



func get_housing():
	var housing = 0
	for structure in structures:
		if structure.key == "hut":
			housing += 1
	return housing

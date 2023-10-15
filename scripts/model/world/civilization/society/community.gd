class_name Community


var settlement
var families


func _init(settlement, families):
	self.settlement = settlement
	self.families = families
	settlement.community = self



func get_bachelors():
	var bachelors = []
	for family in families:
		for ind in family.individuals:
			if ind.age_val >= 15 && ind.age_val < 45:
				if ind.partner == null:
					bachelors.append(ind)
	return bachelors


static func get_eligible_partner(bachelors, bachelor):
	var eligible = []
	for ind in bachelors:
		if ind.sex != bachelor.sex:
			eligible.append(ind)
	if eligible.size() == 0: return null
	return eligible[Util.roll(eligible.size())]
	

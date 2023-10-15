extends Node


class Agent:
	var key
	var type
	var members

var households = []
var businesses = []
var agents = {
	"households":households,
	"businesses":businesses
}
var buildsites = []

func add_agent(key, type, members):
	var agent = Agent.new()
	agent.key = key
	agent.type = type
	agent.members = members
	agents[type].append(agent)

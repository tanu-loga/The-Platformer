extends Node2D

var current_state: State
var previous_state: State
# Called when the node enters the scene tree for the first time.
func _ready():
	current_state = get_child(0) as State
	previous_state = current_state
	current_state.enter()
	print("entered")
	#print(current_state)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func change_state(state_name):
	#print("changed state %s" %state_name)
	var new_state = find_child(state_name) as State
	
	if new_state and current_state != new_state:
		current_state.exit() 
		previous_state = current_state
		
		current_state = new_state
		current_state.enter()




var abcdddd = """current_state = find_child(state) as State
	current_state.enter()
	
	previous_state.exit()
	previous_state = current_state
	var new_state = find_child(state) as State
	if new_state:
		current_state = new_state
		current_state.enter()
	#print(current_state)"""

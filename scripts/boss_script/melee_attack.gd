extends State

signal player_died_golem
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func enter():
	super.enter()
	animation_player.play("melee_attack")
	get_tree().create_timer(1)
	get_parent().change_state("Idle")


func transition():
	if owner.direction.length() > 30:
		get_parent().change_state("Follow")

extends State


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func enter():
	super.enter()
	animation_player.play("melee_attack")

func transition():
	if owner.direction.length() > 30:
		get_parent().change_state("Follow")

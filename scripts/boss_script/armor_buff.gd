extends State

var can_transition: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func enter():
	super.enter()
	animation_player.play("armor_buff")
	await animation_player.animation_finished
	can_transition = true

func transition():
	if can_transition:
		can_transition = false
		get_parent().change_state("Follow")

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
	animation_player.play("glowing")
	await dash()
	can_transition = true

func dash():
	var tween = create_tween()
	tween.tween_property(owner, "position", player.position, 0.8)
	await tween.finished

func transition():
	if can_transition:
		can_transition = false
		get_parent().change_state("Follow")

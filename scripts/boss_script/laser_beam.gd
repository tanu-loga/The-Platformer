extends State

@onready var pivot: Node2D = $"../../Pivot"
var can_transition: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func enter():
	super.enter()
	await play_animation("laser_cast")
	await play_animation("laser")
	can_transition = true

func play_animation(anim_name):
	animation_player.play(anim_name)
	await animation_player.animation_finished

func set_target():
	pivot.rotation = (owner.direction - pivot.position).angle()

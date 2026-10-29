extends State

@export var bullet_node: PackedScene
var can_transition: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not player:
		print("cant find player - homing missle")

func enter():
	super.enter()
	animation_player.play("ranged_attack")
	await animation_player.animation_finished
	shoot()
	can_transition = true

func shoot():
	var bullet = bullet_node.instantiate()
	bullet.position = owner.position
	get_tree().current_scene.add_child(bullet)

func transition():
	if can_transition:
		can_transition = false
		get_parent().change_state("Dash")

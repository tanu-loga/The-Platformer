extends State

@export var bullet_node: PackedScene
var can_transition: bool = false
signal player_died_golem
#signal player_died
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

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
	bullet.player_died_by_bullet.connect(emit_died)

func transition():
	if can_transition:
		can_transition = false
		get_parent().change_state("Dash")
func emit_died():
	owner.player_died_golem.emit()

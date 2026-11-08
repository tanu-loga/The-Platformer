extends State
#@onready var laser_detection: Area2D = $"../../LaserDetection"
#@onready var laser_collision: CollisionShape2D = $"../../LaserDetection/laser_collision"
@onready var laser_detection: Area2D = $"../../Pivot/LaserDetection"
@onready var laser_collision: CollisionShape2D = $"../../Pivot/LaserDetection/laser_collision"


@onready var pivot: Node2D = $"../../Pivot"
var can_transition: bool = false
signal player_died_golem
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	laser_collision.set_deferred("disabled", true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	transition()

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

func transition():
	if can_transition:
		can_transition = false
		get_parent().change_state("Dash")


func _on_laser_detection_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		owner.player_died_golem.emit()
		laser_collision.set_deferred("disabled", true)
		#laser_collision.rotation = pivot.rotation
	else:
		pass

func laser_damage():
	#laser_collision.global_rotation = pivot.global_rotation
	laser_collision.set_deferred("disabled", false)

func _on_laser_collision_hidden() -> void:
	pass # Replace with function body.

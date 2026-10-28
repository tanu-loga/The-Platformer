extends State
@onready var collision: CollisionShape2D = $"../../PlayerDetection/CollisionShape2D"
@onready var progress_bar = owner.find_child("ProgressBar")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

var player_entered: bool = false:
	set(value):
		player_entered = value
		collision.set_deferred("disabled", value)
		progress_bar.set_deferred("visible", value)
		print("toggled")

func transition():
	print("transitioned")
	if player_entered:
		print("state changed to follow")
		get_parent().change_state("Follow")
		return
	else:
		print("didnt transition")

func _on_player_detection_body_entered(body: Node2D) -> void:
	if body.name == "Player" and body.alive:
		player_entered = true

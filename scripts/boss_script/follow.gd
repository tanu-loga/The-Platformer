extends State


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func enter():
	super.enter()
	owner.set_physics_process(true)
	animation_player.play("idle")

func exit():
	super.exit()
	owner.set_physics_process(false)

func transition():
	var distance = owner.direction.length()
	if distance < 30:
		get_parent().change_state("MeleeAttack")
		return
	elif distance > 130:
		var chance = randi() % 2
		match chance:
			0:
				get_parent().change_state("HomingMissle")
				return
			1:
				get_parent().change_state("LaserBeam")
				return

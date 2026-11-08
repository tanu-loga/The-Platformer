extends State


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func enter():
	super.enter()
	owner.set_physics_process(false)
	owner.set_process(false)
	owner.velocity = Vector2.ZERO 
	var collision = owner.find_child("CollisionShape2D")
	if collision:
		collision.queue_free()
		print("collision removed")
	animation_player.play("death")
	await animation_player.animation_finished
	owner.set_physics_process(false)
	owner.set_process(false)
	print("died")
	owner.velocity = Vector2.ZERO 
	animation_player.play("you_defeated_it")
	

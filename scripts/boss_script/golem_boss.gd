extends CharacterBody2D

@onready var player = owner.get_parent().find_child("player")
@onready var sprite = $Sprite2D

var direction: Vector2

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func ready():
	set_physics_process(false)

func _process(delta: float):
	direction = player.position - position
	if direction.x < 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false

func _physics_process(delta: float):
	velocity = direction.normalized() * 40
	move_and_collide(velocity * delta)

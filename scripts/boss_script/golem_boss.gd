extends CharacterBody2D

#@onready var player = owner.get_parent().find_child("Player")
#@onready var player = get_node("/root/Main/LevelRoot/Player") 
@onready var player: CharacterBody2D = $"../Player"
#@onready var sprite = $Sprite2D
@onready var sprite: Sprite2D = $Sprite2D

var direction: Vector2

const speed = 300.0
const JUMP_VELOCITY = -400.0

func _ready():
	set_physics_process(false)
	

func _process(delta):
	if not player:
		print("player aint found")
		return
	direction = player.position - position
	if direction.x < 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false

func _physics_process(delta):
	print("moving")
	velocity = direction.normalized() * 400
	move_and_collide(velocity * delta)

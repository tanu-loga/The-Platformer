extends CharacterBody2D

#@onready var player = owner.get_parent().find_child("Player")
#@onready var player = get_node("/root/Main/LevelRoot/Player") 
@onready var player: CharacterBody2D = $"../Player"
#@onready var sprite = $Sprite2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var progress_bar: ProgressBar = $UI/ProgressBar
@onready var idle: State = $FiniteStateMachine/Idle
@onready var death: State = $FiniteStateMachine/Death

signal player_died_golem
var direction: Vector2
var DEF = 0
var is_dead: bool = false
const speed = 300.0
const JUMP_VELOCITY = -400.0

var health = 100:
	set(value):
		var dead =  death.is_dead
		if dead:
			return
		health = value
		progress_bar.value = value
		if value <= 0:
			progress_bar.visible = false
			find_child("FiniteStateMachine").change_state("Death")
			return
		elif value <= progress_bar.max_value / 2 and DEF == 0:
			DEF = 5
			find_child("FiniteStateMachine").change_state("ArmorBuff")



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
	velocity = direction.normalized() * 400
	move_and_collide(velocity * delta)

func take_damage():
	var entered_collision =  idle.entered_col_idle
	var dead =  death.is_dead
	if dead:
		print(dead)
		return
	if entered_collision:
		if dead:
			return
		health -= 10 - DEF
	else:
		pass

extends State

@onready var melee_collision: CollisionShape2D = $"../../MeleeDetection/melee_collision"
@onready var collision_x: float = abs(melee_collision.position.x)
@onready var golem_boss: CharacterBody2D = $"../.."
@onready var sprite_2d: Sprite2D = $"../../Sprite2D"

var attack_finished: bool = false
var can_attack: bool = true
var can_transition: bool = true
var done: bool = false

signal player_died_golem
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("abcdddddddd")
	melee_collision.set_deferred("disabled", true)
	melee_collision.global_rotation = player.global_rotation


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	transition()
	#pass

func enter():
#enter doesnt get called
	super.enter()
	attack_finished = false
	await play_animation("melee_attack")
	can_transition = true
	#can_transition = true


func transition():
#if owner.direction.length() > 10 and attack_finished:
	if owner.direction.length() > 30 and attack_finished:
		if can_transition:
			can_transition = false
			get_parent().change_state("Follow")
			return
	elif done:
		get_parent().change_state("LaserBeam")


func attack_player():
#if you cant attack, attack finished is true
	if not can_attack:
		attack_finished = true
		return
	can_attack = false
	#play_animation("melee_attack")
	#player_died_golem.emit()
	owner.player_died_golem.emit()
	print("player got hurt by melee attack")
	await owner.get_tree().create_timer(1.0).timeout

	can_attack = true
	attack_finished = true

func play_animation(anim_name):
	animation_player.play(anim_name)
	#await animation_player.animation_finished
	attack_finished = true
	print("done")
	done = true



func _on_melee_detection_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		owner.player_died_golem.emit()
		melee_collision.set_deferred("disabled", true)
		attack_finished = true

func change_dir():
	if sprite_2d.flip_h:
		melee_collision.position.x = -collision_x
	else:
		melee_collision.position.x = collision_x

extends State

#@onready var melee_collision: CollisionShape2D = $"../../Melee/MeleeDetection/melee_collision"
@onready var melee: Node2D = $"../../Melee"
@onready var melee_collision: CollisionShape2D = $"../../Melee/MeleeDetection/melee_collision"
@onready var sprite_2d: Sprite2D = $"../../Sprite2D"


var attack_finished: bool = false
var can_attack: bool = true
var can_transition: bool = true
var done: bool = false
signal player_died_golem
signal melee_done
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	melee_collision.set_deferred("disabled", true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	transition()
	#pass

func enter():
	#enter doesnt get called
	super.enter()
	done = false
	attack_finished = true
	can_transition = false
	can_attack = true
	play_animation("melee_attack")
	print("abcddd")


func transition():
	#if owner.direction.length() > 10 and attack_finished:
	if owner.direction.length() > 10 and attack_finished:
		if can_transition:
			can_transition = false
			get_parent().change_state("Follow")
			return
	#else:
		#print("player is close")


func attack_player():
	#if you cant attack, attack finished is true
	if not can_attack:
		attack_finished = true
		return
		
	can_attack = false
	play_animation("melee_attack")
	owner.player_died_golem.emit()
	print("player got hurt by melee attack")
	#await owner.get_tree().create_timer(1.0).timeout
	
	can_attack = true
	attack_finished = true

func play_animation(anim_name):
	animation_player.play("melee_attack")
	print("gonna play")
	await animation_player.animation_finished
	print("played aniamtion")


func melee_damage():
	melee_collision.position.x = -abs(melee_collision.position.x) if sprite_2d.flip_h else abs(melee_collision.position.x)

	melee_collision.set_deferred("disabled", false)
	await get_tree().create_timer(1).timeout
	
	melee_collision.set_deferred("disabled", true)
	can_transition = true
	attack_finished = true
	#done = true
	#if done:
		#melee_collision.set_deferred("disabled", true)
		#can_transition = true
		#attack_finished = true
		#can_attack = true
		#print("cycle done")

func _on_melee_detection_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		attack_finished = false
		attack_player()
		can_transition = true
		print("player got hittttt")
		done = true
		#owner.player_died_golem.emit()
		#melee_collision.set_deferred("disabled", true)
	else:
		pass

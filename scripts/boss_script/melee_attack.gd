extends State

@onready var melee_collision: CollisionShape2D = $"../../Sprite2D/MeleeDetection/melee_collision"


var attack_finished: bool = false
var can_attack: bool = true
var can_transition: bool = true

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
	attack_finished = false
	can_transition = true
	can_attack = true
	play_animation("melee_attack")


func transition():
	#if owner.direction.length() > 10 and attack_finished:
	if owner.direction.length() > 30 and attack_finished:
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
	await play_animation("melee_attack")
	owner.player_died_golem.emit()
	print("player got hurt by melee attack")
	await owner.get_tree().create_timer(1.0).timeout
	
	can_attack = true
	attack_finished = true

func play_animation(anim_name):
	animation_player.play("melee_attack")
	await animation_player.animation_finished
	print("played aniamtion")


func melee_damage():
	#print("damaged")
	melee_collision.set_deferred("disabled", false)
	if melee_done:
		melee_collision.set_deferred("disabled", true)

func _on_melee_detection_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		attack_finished = false
		attack_player()
		can_transition = true
		melee_collision.set_deferred("disabled", true)
		print("all done")
		melee_done.emit()
		#owner.player_died_golem.emit()
		#melee_collision.set_deferred("disabled", true)
	else:
		pass

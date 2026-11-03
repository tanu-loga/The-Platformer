extends State


var attack_finished: bool = false
var can_attack: bool = true
var can_transition: bool = true

signal player_died_golem
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	transition()
	#pass

func enter():
	#enter doesnt get called
	super.enter()
	attack_finished = false
	attack_player()
	can_transition = true
	#can_transition = true


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
	play_animation("melee_attack")
	owner.player_died_golem.emit()
	print("player got hurt by melee attack")
	await owner.get_tree().create_timer(1.0).timeout
	
	can_attack = true
	attack_finished = true

func play_animation(anim_name):
	animation_player.play(anim_name)
	await animation_player.animation_finished

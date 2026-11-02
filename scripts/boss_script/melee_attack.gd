extends State


var attack_finished: bool = false
var can_attack: bool = true


signal player_died_golem
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func enter():
	super.enter()
	attack_finished = false
	attack_player()


func transition():
	#if owner.direction.length() > 10 and attack_finished:
	if attack_finished and can_attack:
		get_parent().change_state("Follow")
		return
	#else:
		#print("player is close")


func attack_player():
	if not can_attack:
		attack_finished = false
		return
	can_attack = false
	animation_player.play("melee_attack")
	await animation_player.animation_finished
	player_died_golem.emit()
	print("player got hurt by melee attack")
	await owner.get_tree().create_timer(1.0).timeout
	can_attack = true
	attack_finished = true

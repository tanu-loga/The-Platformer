extends Node2D

@onready var score_label: Label = $HUD/ScorePanel/ScoreLabel

var level: int = 1
var score: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_setup_level()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
#if i have many snails in a level, how do i link each of them into the main scene from the snail scene? 
# well, i create a new function for this
# '-> void' is for making sure it doesnt return anything
func _setup_level() -> void:
	
	#connect exit
	var exit = $LevelRoot.get_node_or_null("Exit")
	if exit:
		exit.body_entered.connect(_on_exit_body_entered)
	
	#connect apples
	var apples = $LevelRoot.get_node_or_null("Apples")
	if apples:
		for apple in apples.get_children():
			apple.collected.connect(increase_score)
	
	#connect enemies
	var enemies = $LevelRoot.get_node_or_null("Enemies")
	if enemies:
		for enemy in enemies.get_children():
			enemy.player_died.connect(_on_player_died)


# ------------------------ 
# signal handlers
# ------------------------ 

func _on_exit_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		level += 1
		print(level)
		body.can_move = false


func _on_player_died(body):
	body.die()
	print("Player killed")

# ------------------------ 
# score
# ------------------------ 

func increase_score() -> void:
	score += 1
	#update score, the %s does the trick
	score_label.text = "SCORE: %s" %score

extends Node2D

@onready var score_label: Label = $HUD/ScorePanel/ScoreLabel
@export var hearts : Array[Node] = []

var level: int = 1
var score: int = 0
var lives: int = 3

var current_level_root: Node = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	current_level_root = get_node("LevelRoot")
	_setup_level()
	
	var container = $HUD/Hearts/HBoxContainer
	
	if container:
		for child in container.get_children():
			hearts.append(child)
	else:
		print("Error: Could not find HBoxContainer!")


# -----------------
# Level management
# -----------------

func _load_level(level_number: int) -> void:
	if current_level_root:
		current_level_root.queue_free()
		
	#change level
	var level_path = "res://scenes/levels/level%s.tscn" % level_number
	

#if i have many snails in a level, how do i link each of them into the main scene from the snail scene? 
# well, i create a new function for this
# '-> void' is for making sure it doesnt return anything
func _setup_level() -> void:
	
	var player = $LevelRoot.get_node_or_null("Player")
	if player:
		player.player_died_spikes.connect(decrease_health)
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
			enemy.player_died.connect(decrease_health)
			
	
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
	
	
# ------------------------ 
# health points
# ------------------------ 

func decrease_health() -> void:
	if hearts.size() > 0:
		var heart_to_remove = hearts.pop_back()
		if is_instance_valid(heart_to_remove):
			heart_to_remove.queue_free()
			lives -= 1
			print(lives)
		if lives == 0:
			print("rip player")
			var player = $LevelRoot/Player
			player.die()

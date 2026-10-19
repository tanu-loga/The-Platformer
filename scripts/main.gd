extends Node2D

@onready var fade: ColorRect = $HUD/Fade
@onready var score_label: Label = $HUD/ScorePanel/ScoreLabel
@export var hearts : Array[Node] = []

var level: int = 1
var score: int = 0
var lives: int = 3

var current_level_root: Node = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fade.modulate.a = 1.0
	current_level_root = get_node("LevelRoot")
	await _load_level(level, true, false)
	
	var container = $HUD/Hearts/HBoxContainer
	
	if container:
		for child in container.get_children():
			hearts.append(child)
	else:
		print("Error: Could not find HBoxContainer!")


# -----------------
# Level management
# -----------------

func _load_level(level_number: int, first_load: bool, reset_score: bool) -> void:
	#fade out, but dont do so in the first level
	if not first_load:
		await _fade(1.0)
	
	if reset_score:
		score = 0
		score_label.text = "SCORE: 0"
	
	if current_level_root:
		current_level_root.queue_free()
		
	#change level
	var level_path = "res://scenes/levels/level%s.tscn" % level_number
	current_level_root = load(level_path).instantiate()
	add_child(current_level_root)
	current_level_root.name = "LevelRoot"
	_setup_level(current_level_root)
	#fade in
	await _fade(0.0)
#if i have many snails in a level, how do i link each of them into the main scene from the snail scene? 
# well, i create a new function for this
# '-> void' is for making sure it doesnt return anything
func _setup_level(level_root: Node) -> void:
	
	var player = level_root.get_node_or_null("Player")
	if player:
		player.player_died_spikes.connect(decrease_health)
	#connect exit
	var exit = level_root.get_node_or_null("Exit")
	if exit:
		exit.body_entered.connect(_on_exit_body_entered)
	
	#connect apples
	var apples = level_root.get_node_or_null("Apples")
	if apples:
		for apple in apples.get_children():
			apple.collected.connect(increase_score)
	
	#connect enemies
	var enemies = level_root.get_node_or_null("Enemies")
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
		await _load_level(level, false, false)

func _on_player_died(body):
	body.die()
	await _load_level(level, false, true)

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
			#var player = $level_root/Player
			Global.player.die()

# ---------------
# fade
#----------------

func _fade(to_alpha: float) -> void:
	var tween := create_tween()
	tween.tween_property(fade, "modulate:a", to_alpha, 1.5)
	await tween.finished

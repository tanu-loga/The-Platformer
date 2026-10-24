extends Node2D

@onready var fade: ColorRect = $HUD/Fade
@onready var score_label: Label = $HUD/ScorePanel/ScoreLabel
@export var hearts : Array[Node] = []
@onready var animated_sprite_2d: AnimatedSprite2D = $LevelRoot/Player/AnimatedSprite2D 
@onready var player_animated: CharacterBody2D = $LevelRoot/Player
@onready var loading_screen: ColorRect = $HUD/LoadingScreen


var max_lives: int = 3
var level: int = 1
var score: int = 0
var lives = max_lives
var hit: bool = false 

var current_level_root: Node = null
var testing = null

signal player_declare_global
signal heart_decrease
#signal die_animation

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	loading_screen.modulate.a = 0.0
	fade.modulate.a = 1.0
	current_level_root = get_node("LevelRoot")
	await _load_level(level, true, false, true, true)
	#initialise_hearts()


# -----------------
# Level management
# -----------------

func _load_level(level_number: int, first_load: bool, reset_score: bool, reset_life: bool, initialise: bool) -> void:
	#fade out, but dont do so in the first level
	if not first_load:
		await _fade(1.0)
	if reset_life:
		lives = 3
		#initialise_hearts()
	if initialise:
		initialise_hearts()
	if reset_score:
		score = 0
		score_label.text = "SCORE: 0"

	if current_level_root:
		current_level_root.queue_free()
		
	#change level
	var level_path = "res://scenes/levels/level%s.tscn" % level_number
	#current_level_root = load(level_path).instantiate()
	#basically test if it returns null, if so, go back to level one. else, load the next level. this helps for unfinished levels and just a general safegaurd
	testing = load(level_path)
	if testing == null:
		current_level_root = load("res://scenes/levels/level1.tscn").instantiate()
	else:
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
	
	var area_button = level_root.get_node_or_null("button")
	if area_button:
		area_button.player_died_button.connect(decrease_health)
	
	var player = level_root.get_node_or_null("Player")
	if player:
		player.player_died_spikes.connect(decrease_health)
		player.died.connect(decrease_health)
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
		await _load_level(level, false, false, false, false)

func _on_player_died(body):
	decrease_health()


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
	if lives <= 0:
		return
	if hit:
		return
	if is_instance_valid(Global.player):
		if Global.player.invincible:
			return
	hit = true
	if hearts.size() > 0:
		var heart_to_remove = hearts.pop_back()
		if is_instance_valid(heart_to_remove):
			if "heart" in heart_to_remove.name.to_lower() or heart_to_remove is TextureRect:
				heart_to_remove.play("hit")
				#die_animation.emit()
				await get_tree().create_timer(0.3).timeout
				heart_to_remove.hide() 
				heart_to_remove.play("normal")
				hit = false
			lives -= 1
			print(lives)
			if lives > 0:
				hit = false
	if lives == 0:
		#Global.player.set_deferred("invincible", false)
		#hit = true
		print("rip player")
		#var player = $level_root/Player
		if is_instance_valid(Global.player):
			Global.player.set_deferred("invincible", false)
			Global.player.die()
			Global.player = null
			
		#await Global.player.died
		#initialise_hearts()
		if has_node("HUD/LoadingScreen"):
			$HUD/LoadingScreen.modulate.a = 1.0
		await _load_level(level, false, true, true, false)
		player_declare_global.emit()
		#await get_tree().process_frame
		initialise_hearts()
		if has_node("HUD/LoadingScreen"):
			$HUD/LoadingScreen.modulate.a = 0.0
		else:
			hit = false
		hit = false

# ---------------
# fade
#----------------

func _fade(to_alpha: float) -> void:
	var tween := create_tween()
	tween.tween_property(fade, "modulate:a", to_alpha, 1.5)
	await tween.finished
	

func initialise_hearts():
	#lives = max_lives
	hearts.clear()
	max_lives = 3
	lives = max_lives
	print("this is the lives")
	print(lives)
	var container = $HUD/Hearts/HBoxContainer
	if is_instance_valid(container):
		var count_hearts = 0
		for heart in container.get_children():
			if "heart" in heart.name.to_lower():
				if count_hearts < 3:
					heart.show() 
					hearts.append(heart)
					count_hearts += 1
				else:
					heart.queue_free()

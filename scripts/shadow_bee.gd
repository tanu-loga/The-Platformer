extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var trigger: CollisionShape2D = $Area2D/Trigger
@onready var collider: CollisionShape2D = $Collider
@onready var player: CharacterBody2D = $"../Player"
@onready var change_timer: Timer = $change_timer


@export var speed: float = 100.0
var dir: Vector2
var is_shadow_chase: bool = true
var dead = false
var taking_damage = false
var dealing_damage = false


var random_offset: Vector2 = Vector2.ZERO

const gravity = 2500
var knockback_force = 200
var is_roaming = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !is_on_floor():
		velocity.y += gravity * delta
		velocity.x = 0
	move(delta)
	hide_bee()
	handle_animation()
	move_and_slide()
	
	
func _on_change_timer_timeout() -> void:
	_random_dir()
	
func move(delta):
	if !dead:
		if !is_shadow_chase:
			velocity += dir * speed * delta
		elif is_shadow_chase and !taking_damage:
			var perfect_dir_to_player = position.direction_to(player.position) 
			var dir_to_player = (perfect_dir_to_player + random_offset).normalized()
			velocity.x = dir_to_player.x * speed
			velocity.y = dir_to_player.y * speed
			dir.x = sign(velocity.x)
			dir.y = sign(velocity.y)
			if dir.x != 0:
				animated_sprite_2d.flip_h = (dir.x < 0)
			
		is_roaming = true
	elif dead:
		velocity.x = 0

func handle_animation():
	if !dead and !taking_damage and !dealing_damage:
		animated_sprite_2d.animation = "idle-bee"
		if dir.x == -1:
			animated_sprite_2d.flip_h = false
		elif dir.x == 1:
			animated_sprite_2d.flip_h = true
	elif !dead and taking_damage and !dealing_damage:
		animated_sprite_2d.animation = "hurt"
		await get_tree().create_timer(0.8).timeout
		taking_damage = false
	elif dead and is_roaming:
		is_roaming = false
		await get_tree().create_timer(1).timeout
		handle_death()

func handle_death():
	self.queue_free()

func print_x():
	await get_tree().create_timer(1).timeout
	print(velocity.x)

#hide shadow bee for playtesting cuz it interupted my playtest ALOT
func hide_bee():
	var x = 0
	if x == 1:
		queue_free()
	
	

func _on_direction_timer_timeout() -> void:
	$DirectionTimer.wait_time = choose([1.5,2.0,2.5])
	if !is_shadow_chase:
		dir = choose([Vector2.RIGHT, Vector2.LEFT])
		velocity.x = 0 
		

func _random_dir():
	var random_x = randf_range(-1.5, 1.5)
	var random_y = randf_range(-1.5, 1.5)
	
	random_offset = Vector2(random_x, random_y)

	

func choose(array):
	array.shuffle()
	return array.front()

func _on_visibility_changed() -> void:
	pass # Replace with function body.


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player" and body.alive:
		var y_delta = position.y - body.position.y
		print(y_delta)
		print(dir.x)
		if (y_delta > 39):
			print("aaa")











var abcdefg = """func _on_body_entered(body: Node2D) -> void:
	#if snail touches player, broadcast aka signal that the player should die
	if body.name == "Player" and body.alive:
		var y_delta = position.y - body.position.y
		print(y_delta)
		if (y_delta > 39):
			print("destroy enemy")
			hit_snail.emit()
			call_deferred("_disabled_collision")
			queue_free()
			body.jump()
		else:
			print("decrease player health")
			emit_signal("player_died")
			
func _disabled_collision() -> void:
	collision_shape_2d.disabled = true """

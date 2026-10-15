extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D




#custom signal aka broadcast
signal player_died
signal hit_snail

const speed = 10
var dir: Vector2
var is_shadow_chase: bool = false
var dead = false
var taking_damage = false
var dealing_damage = false

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
	handle_animation()
	move_and_slide()
	
func move(delta):
	if !dead:
		if !is_shadow_chase:
			velocity += dir * speed * delta
		is_roaming = true
	elif dead:
		velocity.x = 0

func handle_animation():
	if !dead and !taking_damage and !dealing_damage:
		animated_sprite_2d.animation = "idle-bee"
		if dir.x == 1.0:
			animated_sprite_2d.flip_h = false
		if dir.x == -1.0:
			animated_sprite_2d.flip_h = true

func _on_direction_timer_timeout() -> void:
	$DirectionTimer.wait_time = choose([1.5,2.0,2.5])
	if !is_shadow_chase:
		dir = choose([Vector2.RIGHT, Vector2.LEFT])
		velocity.x = 0 
		

func choose(array):
	array.shuffle()
	return array.front()













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

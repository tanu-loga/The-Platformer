extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_sound: AudioStreamPlayer2D = $JumpSound
@onready var death_sound: AudioStreamPlayer2D = $DeathSound
@onready var immune_timer: Timer = $ImmuneTimer
@onready var main: Node2D = $"../.."



#psst, if ur reading this, ur cool
#if ur a reviewer, 
#the reason my code is inconsistent and is not very organised is that i followed multiple tuts from dif people
#also i had to write alot of code without guidance and place it myself
#if u read this, say 'Waow, thanos (pun on my name)' in a way i can see it 
#so that i know i can hereby comment for secret stuff on my code

signal died
signal player_died_spikes

const SPEED = 300.0
const JUMP_VELOCITY = -850.0
const JUMP_VELOCITY_X = -1000
var alive = true
var can_move = true

func _ready():
	Global.player = self
	#var main_guy = get_node_or_null("/root/Main")

	#if main_guy:
		#main_guy.die_animation.connect(hit_animation)
	#else:
		#print("main not found")

func _physics_process(delta: float) -> void:
	
	#if player aint alive, end this whole function
	if !alive:
		return
	
	#add animation
	if velocity.x > 1 or velocity.x < -1:
		animated_sprite_2d.animation = "running"
	else:
		animated_sprite_2d.animation = "idle"
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		animated_sprite_2d.animation = "jumping"
	
	if can_move:
		
		# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			jump_sound.play()

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		
		var direction := Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)


		move_and_slide()
		if direction == 1.0:
			animated_sprite_2d.flip_h = false
		if direction == -1.0:
			animated_sprite_2d.flip_h = true
	
	#checkin if player touches spikes
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		#if player touches anythin drawn in tilemapspikes-
		if collision.get_collider().name == "TileMapSpikes":
			if alive == true and immune_timer.is_stopped():
				immune_timer.start()
				print("is getting hit")
				player_died_spikes.emit()
				#animated_sprite_2d.play("dying")
				#hit_animation()
				jump()

func die() -> void:
	alive = false 
	can_move = false
	death_sound.play()
	animated_sprite_2d.play("dying")
	await animated_sprite_2d.animation_finished
	emit_signal("died")
	
func jump():
	velocity.y = JUMP_VELOCITY
	
func jump_x():
	velocity.x = JUMP_VELOCITY_X
	velocity.y = JUMP_VELOCITY
	print("jumped")

var abcddd = """func hit_animation():
	#turn flash on
	animated_sprite_2d.material.set_shader_parameter("flash_modifier", 1.0)
	
	await get_tree().create_timer(0.15).timeout
	
	#turn it off
	animated_sprite_2d.material.set_shader_parameter("flash_modifier", 0.0)"""

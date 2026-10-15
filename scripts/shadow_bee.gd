extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D




#custom signal aka broadcast
signal player_died
signal hit_snail

const SPEED = 10
var direction = -1.0
var dead = false
var taking_damage = false
var dealing_damage = false

var knockback_force = 200
var is_roaming = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#maintain steady speed ig
	position.x += direction * SPEED * delta

func _on_timer_timeout() -> void:
		#if its going left, turn it right or vice versa
		direction *= -1
		animated_sprite_2d.flip_h = !animated_sprite_2d.flip_h


func _on_body_entered(body: Node2D) -> void:
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
	collision_shape_2d.disabled = true

func _on_direction_timer_timeout() -> void:
	pass # Replace with function body.

extends Area2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var collision_shape_2d_2: CollisionShape2D = $CollisionShape2D2


#custom signal aka broadcast
signal player_died
signal hit_snail

const SPEED = 100.0
var direction = -1.0
var alive_snail = true
var can_move_snail = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#maintain steady speed ig
	position.x += direction * SPEED * delta
	hide_snail()

func _on_timer_timeout() -> void:
		#if its going left, turn it right or vice versa
		direction *= -1
		animated_sprite_2d.flip_h = !animated_sprite_2d.flip_h


func _on_body_entered(body: Node2D) -> void:
	#if snail touches player, broadcast aka signal that the player should die
	if body.name == "Player" and body.alive:
		var y_delta = position.y - body.position.y
		print(y_delta)
		if (y_delta > 38):
			print("destroy enemy")
			hit_snail.emit()
			call_deferred("_disabled_collision")
			queue_free()
			body.jump()
		else:
			print("decrease player health")
			emit_signal("player_died")
			body.jump_x()
			call_deferred("_disabled_collision")
			await get_tree().create_timer(1).timeout
			call_deferred("_enabled_collision")
			
func _disabled_collision() -> void:
	collision_shape_2d.disabled = true
	collision_shape_2d_2.disabled = true

func _enabled_collision() -> void:
	collision_shape_2d.disabled = false
	collision_shape_2d_2.disabled = false

#hiding snail for playtesting. if i dont do this, player keeps getting hit by invis snails...
func hide_snail():
	var x = 0
	if x == 1:
		queue_free()

extends Area2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
#custom signal aka broadcast
signal player_died

const SPEED = 100.0
var direction = -1.0

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
		emit_signal("player_died", body)
		

extends Area2D

signal player_died_golem
@onready var player = Global.player
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var acceleration: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float):
	if player:
		acceleration = (player.position - position).normalized() * 700
		
		velocity += acceleration * delta
		rotation = velocity.angle()
		velocity = velocity.limit_length(150.0)
		
		position += velocity * delta
	else:
		print("player not found")
		return

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print("hit player")
		owner.player_died_golem.emit()
		queue_free()
	else:
		print("hit object")
		queue_free()

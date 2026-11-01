extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

#@onready var player = Global.player
var direction = Vector2.RIGHT
var speed = 300
#var acceleration: Vector2 = Vector2.ZERO
#var velocity: Vector2 = Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float):
	position += direction * speed * delta
func _on_body_entered(body: Node2D) -> void:
	body.take_damage()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

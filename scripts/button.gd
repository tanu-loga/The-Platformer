extends StaticBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var is_open = false
signal player_died_button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite_2d.show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if collision_shape_2d.disabled == false:
		animated_sprite_2d.show()
	
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_action_pressed("leftClick") and not is_open:
		print("got hit")
		player_died_button.emit()
		animated_sprite_2d.play("hit")
		call_deferred("_disabled_collision_button")

func _disabled_collision_button() -> void:
	collision_shape_2d.disabled = true

func _on_animated_sprite_2d_animation_looped() -> void:
	if animated_sprite_2d.animation == "hit":
		animated_sprite_2d.hide()

extends Area2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collected_sound: AudioStreamPlayer2D = $CollectedSound
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

signal collected

func _on_body_entered(body: Node2D) -> void:
	animated_sprite_2d.animation = "collected"
	collected_sound.play()
	collected.emit()
	#i can do a collison_shape_2d.disabled = true here, but it will return an error
	#the error will show that you can't disable a collision the same time a collison is happening
	#hence the new function '_disabled_collision()'
	#the call_deferred will tell godot that its gonna run disable collison once its safe to do so
	#so the problem for the collison disabling the same time its happening is solved~
	call_deferred("_disabled_collision")

func _disabled_collision() -> void:
	collision_shape_2d.disabled = true

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

#animation_finished() doesnt work since the collected apple animation repeats
#so i used animation_looped(), which checks if the animation is looped, of course
#so if the animation is "collected" and the animation is about to loop,
# i tell godot to remove the apple when it is safe to do so - same mechanism as call_deferred
#queue_free() is a life saver and also has its own call_deffered mechanism ig
func _on_animated_sprite_2d_animation_looped() -> void:
	if animated_sprite_2d.animation == "collected":
		queue_free()

extends Node
@onready var main = $"/root/Main"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_level_1_pressed() -> void:
	main._load_level(1, true, false, true, true)
	#get_tree().change_scene_to_file("res://scenes/levels/level1.tscn")


func _on_level_2_pressed() -> void:
	print("level is wip!")
	

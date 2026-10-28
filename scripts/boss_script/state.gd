extends Node2D
class_name State
@onready var debug = owner.find_child("debug")
#@onready var player = owner.get_parent().find_child("player")
@onready var animation_player = owner.find_child("AnimationPlayer")
@onready var player: CharacterBody2D = $"../../../Player"



# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(false)

func enter():
	set_physics_process(true)

func exit():
	set_physics_process(false)

func transition():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not player:
		print("cant find player - from state gd")
		#player = get_node_or_null("Player")
	pass

func _physics_process(_delta):
	transition()
	debug.text = name

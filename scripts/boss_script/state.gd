extends Node2D
class_name State
@onready var debug = owner.find_child("debug")
#@onready var player = owner.get_parent().find_child("player")
@onready var animation_player = owner.find_child("AnimationPlayer")
@onready var player: CharacterBody2D = $"../../../Player"

var is_active: bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	is_active = false
	set_physics_process(false)

func enter():
	is_active = true
	set_physics_process(true)

func exit():
	is_active = false
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
	if not is_active:
		return
	transition()
	debug.text = name

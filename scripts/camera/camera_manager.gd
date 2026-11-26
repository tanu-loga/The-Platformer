extends Node


@onready var camera_nodes: Node2D = $CameraNodes
var collision_count: int = 0
var current_camera_zone: int = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("COLLISION COUNT IS")
	print(collision_count)
	print("----")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_current_zone(body, zone_a, zone_b):
	if body.name == "Player":
		match current_camera_zone:
			zone_a:
				current_camera_zone = zone_b
			zone_b:
				current_camera_zone = zone_a
		update_camera()

func update_camera():
	print("Camera zone: ", current_camera_zone)
	var cameras = []
	for camera in camera_nodes.find_children("*", "PhantomCamera2D"):
		cameras.append(camera)
	print("CAMERAAA")
	print(cameras)
	for camera in cameras:
		if camera != null:
			camera.priority = 0
	var zone_0 = cameras[0]
	var zone_1 = cameras[1]
	match current_camera_zone:
		0:
			zone_0.priority = 1
		1:
			zone_1.priority = 1
	
	
func _on_zone_0_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		current_camera_zone = 0
		update_camera()
		collision_count += 1
		#print("COLLISION COUNT IS")
		#print(collision_count)
		#print("----body_enter----")


func _on_zone_0_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		collision_count -= 1
		#update_current_zone(body, 0, 1)
		#print("COLLISION COUNT IS")
		#print(collision_count)
		#print("----body_exit----")


func _on_zone_1_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		current_camera_zone = 1
		update_camera()
		collision_count += 1


func _on_zone_1_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		#update_current_zone(body, 1, 2)
		collision_count -= 1

@tool
class_name AnimatedTextureRect extends TextureRect

@export var sprites : SpriteFrames:
	set(value):
		if sprites != value:
			sprites = value
			update_editor_preview()

@export var current_animation: String = "normal": 
	set(value):
		if current_animation != value:
			current_animation = value
			if sprites and sprites.has_animation(current_animation):
				_frame_index = 0
			update_editor_preview()

var _frame_index:= 0
@export var frame_index: int:
	get: return _frame_index
	set(value):
		if _frame_index != value:
			_frame_index = value
			update_editor_preview()

@export_range(0.0, INF, 0.001) var speed_scale := 1.0
@export var auto_play := true 
@export var playing := true:  
	set(value):
		playing = value
		if playing:
			frame_delta = 0.0

var refresh_rate = 1.0
var fps = 30.0
var frame_delta = 0.0

func _ready() -> void:
	if sprites and sprites.has_animation(current_animation):
		get_animation_data(current_animation)
		
	update_editor_preview()
	
	if not Engine.is_editor_hint():

		var decrease = get_tree().root.find_child("Main", true, false)
		
		if decrease:
			decrease.heart_decrease.connect(woosh)
		else:
			push_error("cant find main")


func _process(delta: float) -> void:
	if sprites == null or playing == false:
		return
		
	if not sprites.has_animation(current_animation):
		playing = false
		return 
		
	get_animation_data(current_animation)
	frame_delta += (speed_scale * delta)
	
	var frame_time = refresh_rate / (fps if fps > 0.0 else 1.0)
	if frame_delta >= frame_time:
		frame_delta -= frame_time 
		advance_frame()

func play(animation_name : String = current_animation):
	_frame_index = 0
	frame_delta = 0.0
	current_animation = animation_name
	if sprites and sprites.has_animation(current_animation):
		get_animation_data(current_animation)
		playing = true

func get_animation_data(animation: String):
	if sprites and sprites.has_animation(animation):
		fps = sprites.get_animation_speed(animation)
		var frame_count = sprites.get_frame_count(animation)
		var safe_frame = clampi(_frame_index, 0, max(0, frame_count - 1))
		if frame_count > 0:
			refresh_rate = sprites.get_frame_duration(animation, safe_frame)

func advance_frame():
	if not sprites or not sprites.has_animation(current_animation):
		return
		
	var frame_count = sprites.get_frame_count(current_animation)
	if frame_count <= 0:
		return
		
	_frame_index += 1
	if _frame_index >= frame_count:
		if sprites.get_animation_loop(current_animation):
			_frame_index = 0
		else:
			_frame_index = frame_count - 1
			playing = false
			
	get_animation_data(current_animation)
	texture = sprites.get_frame_texture(current_animation, _frame_index)

func update_editor_preview():
	if sprites and sprites.has_animation(current_animation):
		var frame_count = sprites.get_frame_count(current_animation)
		if frame_count > 0:
			if _frame_index >= frame_count or _frame_index < 0:
				_frame_index = 0
			get_animation_data(current_animation)
			texture = sprites.get_frame_texture(current_animation, _frame_index)
			queue_redraw()
	else:
		texture = null

func resume():
	playing = true

func pause():
	playing = false

func stop():
	_frame_index = 0
	playing = false
	update_editor_preview()

func woosh():
	play("hit")
	

	

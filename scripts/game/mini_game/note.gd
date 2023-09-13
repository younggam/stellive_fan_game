extends Control

@export var initial_scale:float
@export var delay:float
@export var kill_delay:float
@export var detect_diff:float

static var key_texture_map={
	KEY_Q:preload("res://textures/mini_game/q.png"),
	KEY_W:preload("res://textures/mini_game/w.png"),
	KEY_E:preload("res://textures/mini_game/e.png"),
	KEY_R:preload("res://textures/mini_game/r.png"),
	KEY_SPACE:preload("res://textures/mini_game/space.png"),
	KEY_U:preload("res://textures/mini_game/u.png"),
	KEY_I:preload("res://textures/mini_game/i.png"),
	KEY_O:preload("res://textures/mini_game/o.png"),
	KEY_P:preload("res://textures/mini_game/p.png")
}

static var key_stack={
	KEY_Q:[],
	KEY_W:[],
	KEY_E:[],
	KEY_R:[],
	KEY_SPACE:[],
	KEY_U:[],
	KEY_I:[],
	KEY_O:[],
	KEY_P:[],
}

var key
var time=0
var poped=false

signal pop(result:bool)

func initialize(text,key):
	$VBoxContainer/Label.text=text
	self.key=key
	key_stack[key].push_back(get_instance_id())
	$VBoxContainer/TextureRect.texture=key_texture_map[key]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time+=delta
	if !poped:
		var scale=lerpf(initial_scale,1,time/delay)
		$Control/ElapseLine.scale=Vector2(scale,scale)

	if time>delay+kill_delay:
		if !poped:
			on_pop(false)
		queue_free()

func _shortcut_input(event):
	if !poped and event is InputEventKey and event.keycode==key and key_stack[key].front()==get_instance_id():
		if event.is_pressed() and !event.is_echo():
			poped=true
			on_pop(absf(time-delay)<=detect_diff)
			time=delay

func on_pop(result):
	pop.emit(result)
	key_stack[key].pop_front()

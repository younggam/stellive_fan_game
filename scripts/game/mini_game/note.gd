extends Control

@export var initial_scale:float
@export var delay:float

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

var key

var time=0

var poped=false

func initialize(text,key):
	print("hello?")
	$VBoxContainer/Label.text=text
	self.key=key
	$VBoxContainer/TextureRect.texture=key_texture_map[key]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if poped:
		return

	time+=delta	
	var scale=lerpf(initial_scale,1,time/delay)
	$Control/ElapseLine.scale=Vector2(scale,scale)
	
	if time>delay:
		poped=true

func _shortcut_input(event):
	if event is InputEventKey and event.keycode==key:
		if event.is_pressed() and !event.is_echo():
			poped=true

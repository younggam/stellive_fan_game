extends StaticBody2D

var member=0
var category=0
var hitaus=true

# Called when the node enters the scene tree for the first time.
func _ready():
	input_event.connect(on_mouse_left_click)

func on_mouse_left_click(node,event,shape_index):
	if event is InputEventMouseButton and event.button_index==1 and event.pressed:
		Game.instance.open_pc(self)

extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	input_event.connect(on_mouse_left_click)

func on_mouse_left_click(node,event,shape_index):
	if event is InputEventMouseButton and event.button_index==1 and event.pressed:
		pass

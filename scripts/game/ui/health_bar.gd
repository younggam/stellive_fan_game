extends ProgressBar


# Called when the node enters the scene tree for the first time.
func _ready():
	set_max_health(1000)
	set_health(720)
	
func set_max_health(new_value):
	max_value=new_value
	update_label()

func set_health(new_value):
	value=new_value
	update_label()

func update_label():
	$Label.text="Wall %.1f / %.1f"%[value,max_value]

extends Panel

var hour=0

func _ready():
	update_label()

func set_hour(hour):
	self.hour=hour
	
	update_label()

func update_label():
	$Label.text="day %d, %d:00:00"%[hour/24,hour%24]

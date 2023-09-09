extends Panel

func _ready():
	set_time(12048.1234)

func set_time(time):
	var second=fposmod(time,60)
	time=floori(time/60)
	var minute=fposmod(time,60)
	time=floori(time/60)
	var hour=fposmod(time,24)
	var day=floori(time/24)
	
	$Label.text="day %d, %d:%d:%d"%[day,hour,minute,second]

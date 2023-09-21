extends Area2D

var velocity

func _ready():
	body_entered.connect(func(player): player.collide())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position+=velocity*delta
	var size=get_parent().size
	
	if position.x<0 or position.x>size.x or position.y<0 or position.y>size.y:
		queue_free()

func initialize(pos,rot,vel,mul):
	position=pos
	velocity=vel*mul

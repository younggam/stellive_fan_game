extends RayCast2D

@export var delay=1
@export var min_alpha=0.25
@export var max_alpha=0.5
@export var lifetime=0.25

var time=0

# Called when the node enters the scene tree for the first time.
func _ready():
	enabled=false
	$Line2D.default_color.a=min_alpha


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time+=delta
	if time<delay:
		$Line2D.default_color.a=lerpf(min_alpha,max_alpha,time/delay)
		return
	
	if enabled:
		if time>=delay+lifetime:
			queue_free()
		return
	enabled=true
	$Line2D.default_color.a=1
	$Line2D.width*=2

func _physics_process(delta):
	var collider=get_collider()
	if collider!=null:
		collider.collide()

func initialize(pos,rot,vel,mul):
	var dir=Vector2.from_angle(deg_to_rad(rot))
	delay/=mul
	var size=get_parent().size
	var valid=0
	var temp

	var t0=-pos.x/dir.x
	var y=pos.y+t0*dir.y
	if y>=0 and y<=size.y:
		temp=Vector2(0,y)
		update_laser(valid,temp)
		valid+=1

	var t1=(size.x-pos.x)/dir.x
	y=pos.y+t1*dir.y
	if y>=0 and y<=size.y:
		temp=Vector2(size.x,y)
		update_laser(valid,temp)
		valid+=1

	var t2=-pos.y/dir.y
	var x=pos.x+t2*dir.x
	if x>=0 and x<=size.x:
		temp=Vector2(x,0)
		update_laser(valid,temp)
		valid+=1

	var t3=(size.y-pos.y)/dir.y
	x=pos.x+t3*dir.x
	if x>=0 and x<=size.x:
		temp=Vector2(x,size.y)
		update_laser(valid,temp)
		valid+=1
	
func update_laser(select,value):
	if select==0:
		position=value
		$Line2D.set_point_position(0,value)
	elif select==1:
		target_position=value
		$Line2D.set_point_position(1,value)

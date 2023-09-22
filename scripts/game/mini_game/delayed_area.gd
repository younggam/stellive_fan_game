extends ShapeCast2D

@export var delay=1
@export var min_alpha=0.25
@export var max_alpha=0.5
@export var lifetime=0.25

var time=0
var velocity=Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	enabled=false
	$Polygon2D.color.a=min_alpha


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time+=delta
	if time<delay:
		position+=velocity*delta
		var size=get_parent().size
		if position.x<0 or position.x>size.x:
			position.x=clampf(position.x,0,size.x)
			velocity.x=0
		if position.y<0 or position.y>size.y:
			position.y=clampf(position.y,0,size.y)
			velocity.y=0
			
		$Polygon2D.color.a=lerpf(min_alpha,max_alpha,time/delay)
		return
	
	if enabled:
		if time>=delay+lifetime:
			queue_free()
		return
	enabled=true
	$Polygon2D.color.a=1

func _physics_process(delta):
	var collider=get_collider(0)
	if collider!=null:
		collider.collide()

func initialize(pos,rot,vel,mul):
	position=pos
	velocity=vel*mul
	rotation=rot
	delay/=mul

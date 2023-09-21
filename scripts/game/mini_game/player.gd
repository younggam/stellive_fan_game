extends RigidBody2D

@export var speed = 100 # How fast the player will move (pixels/sec).
@export var invincible_time=1.5
@export var min_alpha=0.2
@export var max_alpha=0.6
@export var blink_period=0.5

var time=0.0

signal collided()

func _process(delta):
	if time>=invincible_time:
		$Sprite2D.modulate.a=1
		return
	$Sprite2D.modulate.a=pingpong(time/blink_period*2,1)*(max_alpha-min_alpha)+min_alpha

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	time+=delta
	var velocity=Vector2.ZERO
	if Input.is_action_pressed("right"):
		velocity.x+=1
	if Input.is_action_pressed("down"):
		velocity.y+=1
	if Input.is_action_pressed("left"):
		velocity.x-=1
	if Input.is_action_pressed("up"):
		velocity.y-=1

	if is_zero_approx(velocity.length_squared()):
		return
	
	move_and_collide(velocity.normalized()*delta*speed)
	var map=get_node("../VBoxContainer/Panel")
	position=position.clamp(map.global_position,map.global_position+map.size)

func collide():
	if time<invincible_time:
		return
	collided.emit()
	time=0


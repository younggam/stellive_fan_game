extends RigidBody2D

@export var speed = 100 # How fast the player will move (pixels/sec).

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
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

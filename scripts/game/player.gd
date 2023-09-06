extends RigidBody2D

@export var speed = 100 # How fast the player will move (pixels/sec).

var target=null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Input.is_action_just_pressed("move"):
		target = get_global_mouse_position()

	if target==null:
		return

	var magnitude=minf(speed*delta,position.distance_to(target))
	if is_zero_approx(magnitude):
		target=null
	else:
		move_and_collide(position.direction_to(target)*magnitude)

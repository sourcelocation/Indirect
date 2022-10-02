extends RigidBody2D

signal hit_ground
signal hit_spike
signal spawn_player

var falling = false
var should_freeze = false

# Called when the node enters the scene tree for the first time.
func _ready():
	freeze_mode = RigidBody2D.FREEZE_MODE_STATIC
	
	transform = Transform2D(0, Vector2(67,75))
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			falling = true
			if $AnimationPlayer.current_animation != "Destroy": $AnimationPlayer.play("Fall")
		
func _physics_process(delta):
		
	if should_freeze:
		freeze = true
		position = Vector2(position.x, 205)
		should_freeze = false
		
	if falling: linear_velocity = Vector2(linear_velocity.x, 400)
		
func _on_rigid_body_2d_body_entered(body):
	if body.name == "Floor":
		emit_signal("hit_ground")
		linear_velocity = Vector2(linear_velocity.x, -350)
		if falling == true:
			falling = false

func destroy():
	should_freeze = true
	$CollisionShape2d.queue_free()
	$AnimationPlayer.play("Destroy")

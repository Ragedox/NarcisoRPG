extends KinematicBody2D

const max_speed = 5000.0
const acceleration = 1000.0

var STRblazing = true
var velocity = Vector2.ZERO
const friction = 400
var fSpeedMultipler = 1.0

signal coin_collected
signal powerup_collected

var poweruplevel = 0
var bDead = false
var bRunning = false

func _ready(): # Called when the node enters the scene tree for the first time.
	if (STRblazing):
		print(":3")
	else:
		print(":(")
	
	#Global.Player = self
	
func _physics_process(delta): # Called every frame. 'delta' is the elapsed time since the previous frame.
	var input_vector = Vector2.ZERO
	input_vector.x = (Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")) # Right 1 - 0 = 1 | Left 0 - 1 = -1
	input_vector.y = (Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")) # Right 1 - 0 = 1 | Left 0 - 1 = -1
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		$AnimationTree.set("parameters/Idle/blend_position", input_vector)
		$AnimationTree.set("parameters/Walk/blend_position", input_vector)
		$AnimationTree.get("parameters/playback").travel("Walk")
		if input_vector.x == -1:
			$Sprite.flip_h = true
		elif input_vector.x == 1:
			$Sprite.flip_h = false
		
		velocity += input_vector * acceleration * delta
		velocity = velocity.clamped(max_speed * delta)
	else:
		$AnimationTree.get("parameters/playback").travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

	velocity = move_and_slide(velocity)

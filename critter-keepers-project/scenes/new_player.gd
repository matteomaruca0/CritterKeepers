extends CharacterBody2D

@export var speed := 200.0

@onready var animation_player = $AnimationPlayer

var last_direction := "down"

func _physics_process(delta):

	var input_dir := Vector2.ZERO

	input_dir.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_dir.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	if input_dir != Vector2.ZERO:

		input_dir = input_dir.normalized()
		velocity = input_dir * speed

		last_direction = get_idle_direction(input_dir)

		var walk_direction = get_walk_direction(input_dir)

		animation_player.play("move_" + walk_direction)

	else:

		velocity = Vector2.ZERO
		animation_player.play("idle_" + last_direction)

	move_and_slide()


func get_walk_direction(dir: Vector2) -> String:

	if abs(dir.x) > abs(dir.y):

		if dir.x > 0:
			return "right"
		else:
			return "left"

	else:

		if dir.y > 0:
			return "down"
		else:
			return "up"


func get_idle_direction(dir: Vector2) -> String:

	if dir.y < -0.5:

		if dir.x < -0.5:
			return "up_left"

		elif dir.x > 0.5:
			return "up_right"

		else:
			return "up"


	elif dir.y > 0.5:

		if dir.x < -0.5:
			return "down_left"

		elif dir.x > 0.5:
			return "down_right"

		else:
			return "down"


	else:

		if dir.x < 0:
			return "left"

		else:
			return "right"

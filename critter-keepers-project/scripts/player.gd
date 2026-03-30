extends CharacterBody2D

const SPEED = 150.0

func _physics_process(delta):
	var dialogo = get_tree().get_first_node_in_group("dialogo_ui")

	var direction_x = Input.get_axis("ui_left", "ui_right")
	var direction_y = Input.get_axis("ui_up", "ui_down")
	velocity = Vector2(direction_x, direction_y).normalized() * SPEED
	move_and_slide()

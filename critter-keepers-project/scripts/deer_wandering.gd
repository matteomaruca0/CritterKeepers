extends CharacterBody2D

@export var speed := 25.0
@export var change_direction_time_min := 1.0
@export var change_direction_time_max := 3.0

@onready var sprite = $AnimatedSprite2D

var direction := Vector2.ZERO
var timer := 0.0


func _ready():
	randomize()
	choose_new_direction()


func _physics_process(delta):

	timer -= delta

	if timer <= 0:
		choose_new_direction()

	if direction == Vector2.ZERO:
		play_idle_animation()
	else:
		velocity = direction * speed
		play_walk_animation()

	move_and_slide()


func choose_new_direction():

	timer = randf_range(
		change_direction_time_min,
		change_direction_time_max
	)

	var possible_directions = [
		Vector2.ZERO,     # stand still
		Vector2.UP,
		Vector2.DOWN,
		Vector2.LEFT,
		Vector2.RIGHT
	]

	direction = possible_directions.pick_random()


func play_walk_animation():

	if direction == Vector2.UP:
		sprite.play("walk_up")

	elif direction == Vector2.DOWN:
		sprite.play("walk_down")

	elif direction == Vector2.LEFT:
		sprite.play("walk_left")

	elif direction == Vector2.RIGHT:
		sprite.play("walk_right")


func play_idle_animation():

	if sprite.animation.begins_with("walk"):
		sprite.play("idle_down")

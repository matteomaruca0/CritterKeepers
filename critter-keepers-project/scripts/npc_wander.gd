extends CharacterBody2D

@export var speed := 20.0
@export var change_direction_time_min := 1.0
@export var change_direction_time_max := 3.0
@export var npc_message := "Beautiful day in the forest."

@onready var sprite = $AnimatedSprite2D
@onready var area = $Area2D
@onready var label = $Label

var direction := Vector2.ZERO
var timer := 0.0
var facing := "down"
var player_near := false

func _ready():
	randomize()
	label.visible = false
	choose_new_direction()
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)

func _physics_process(delta):
	timer -= delta

	if timer <= 0.0:
		choose_new_direction()

	if player_near:
		velocity = Vector2.ZERO
		sprite.play("idle_" + facing)
	else:
		if direction == Vector2.ZERO:
			velocity = Vector2.ZERO
			sprite.play("idle_" + facing)
		else:
			velocity = direction * speed
			facing = dir_name(direction)
			sprite.play("walk_" + facing)

	move_and_slide()

func choose_new_direction():
	timer = randf_range(change_direction_time_min, change_direction_time_max)

	var possible_directions = [
		Vector2.ZERO,
		Vector2.UP,
		Vector2.DOWN,
		Vector2.LEFT,
		Vector2.RIGHT
	]

	direction = possible_directions.pick_random()

func dir_name(dir: Vector2) -> String:
	if dir == Vector2.UP:
		return "up"
	if dir == Vector2.DOWN:
		return "down"
	if dir == Vector2.LEFT:
		return "left"
	return "right"

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_near = true
		label.text = npc_message
		label.visible = true

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_near = false
		label.visible = false

extends CharacterBody2D

@export var speed_terra := 100.0
@export var speed_nuoto := 80.0
@export var speed_volo := 240.0

@onready var animation_player = $AnimationPlayer
@onready var camera = $Camera2D

var bloccato = false

enum Stato { TERRA, NUOTO, VOLO }
var stato = Stato.TERRA

var last_direction := "down"

func _ready():
	add_to_group("player")
	camera.enabled = true

func _physics_process(delta):
	if bloccato:
		velocity = Vector2.ZERO
		return

	var input_dir := Vector2.ZERO
	input_dir.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_dir.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	var current_speed = speed_terra

	if stato == Stato.NUOTO:
		current_speed = speed_nuoto
	elif stato == Stato.VOLO:
		current_speed = speed_volo

	if input_dir != Vector2.ZERO:
		input_dir = input_dir.normalized()
		velocity = input_dir * current_speed

		last_direction = get_idle_direction(input_dir)
		var walk_direction = get_walk_direction(input_dir)

		# for now swim/fly use same movement animation as walking
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

func inizia_nuoto():
	stato = Stato.NUOTO
	print("nuoto iniziato")

func inizia_volo():
	stato = Stato.VOLO
	print("volo iniziato")

func _atterra():
	stato = Stato.TERRA
	print("ritorno a terra")

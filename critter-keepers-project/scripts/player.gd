extends CharacterBody2D

# ── Costanti ──────────────────────────────────────────────
const SPEED = 150.0
const SPEED_NUOTO = 80.0
const SPEED_VOLO = 280.0

# ── Stato ─────────────────────────────────────────────────
enum Stato { NORMALE, NUOTO, VOLO }
var stato = Stato.NORMALE
var bloccato = false

# ── Destinazione isola (aggiusta con coordinate reali) ────
var destinazione_isola = Vector2(500, 300)

# ── Riferimenti nodi ──────────────────────────────────────
@onready var sprite = $AnimatedSprite2D
@onready var obstacles = get_node("../Obstacles")

# ── Inizializzazione ──────────────────────────────────────
func _ready():
	add_to_group("player")

# ── Loop principale ───────────────────────────────────────
func _physics_process(delta):
	var direction_x = Input.get_axis("move_left", "move_right")
	var direction_y = Input.get_axis("move_up", "move_down")
	var direction = Vector2(direction_x, direction_y).normalized()
	
	#Sono in una scena bloccata
	if bloccato:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	match stato:
		Stato.NORMALE:
			velocity = direction * SPEED
			_aggiorna_animazione_camminata(direction)
		Stato.NUOTO:
			velocity = direction * SPEED_NUOTO
			_aggiorna_animazione_nuoto(direction)
			if global_position.distance_to(destinazione_isola) < 32:
				_atterra()
		Stato.VOLO:
			velocity = direction * SPEED_VOLO
			sprite.play("fly")
			if global_position.distance_to(destinazione_isola) < 32:
				_atterra()

	move_and_slide()
	_aggiorna_z()

# ── Cambio stato ──────────────────────────────────────────
func inizia_nuoto():
	stato = Stato.NUOTO

func inizia_volo():
	stato = Stato.VOLO
	sprite.play("fly")

func _atterra():
	stato = Stato.NORMALE
	sprite.play("idle")

# ── Animazioni ────────────────────────────────────────────
func _aggiorna_animazione_camminata(dir):
	if dir == Vector2.ZERO:
		sprite.play("idle")
	elif abs(dir.x) > abs(dir.y):
		sprite.play("walk_right" if dir.x > 0 else "walk_left")
	else:
		sprite.play("walk_down" if dir.y > 0 else "walk_up")

func _aggiorna_animazione_nuoto(dir):
	if dir == Vector2.ZERO:
		sprite.play("swim_down")
	elif abs(dir.x) > abs(dir.y):
		sprite.play("swim_right" if dir.x > 0 else "swim_left")
	else:
		sprite.play("swim_down" if dir.y > 0 else "swim_up")

# ── Z Sort manuale (player davanti/dietro agli alberi) ────
func _aggiorna_z():
	var piedi = global_position + Vector2(0, 8)
	var tile_pos = obstacles.local_to_map(obstacles.to_local(piedi))
	var dietro = false
	for y_offset in range(-3, 1):
		var tile = obstacles.get_cell_source_id(Vector2i(tile_pos.x, tile_pos.y + y_offset))
		if tile != -1:
			var tile_base_y = obstacles.map_to_local(Vector2i(tile_pos.x, tile_pos.y + y_offset + 1))
			var tile_base_global = obstacles.to_global(tile_base_y)
			if piedi.y < tile_base_global.y:
				dietro = true
				break
	z_index = 0 if dietro else 2
	z_as_relative = false

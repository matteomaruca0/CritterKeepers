extends CanvasLayer

signal scelta_nuota
signal scelta_vola
signal annullato

@onready var scelta_container = $Panel/ChooseContainer
@onready var btn_si = $Panel/YesNoContainer/BtnYes
@onready var btn_no = $Panel/YesNoContainer/BtnNo
@onready var btn_nuota = $Panel/ChooseContainer/BtnSwim
@onready var btn_vola = $Panel/ChooseContainer/BtnFly

var volo_sbloccato = false
var barriera_corrente = null

func _ready():
	add_to_group("viaggio_prompt")

	visible = false
	scelta_container.visible = false

	btn_si.pressed.connect(_on_si)
	btn_no.pressed.connect(_on_no)
	btn_nuota.pressed.connect(_on_nuota)
	btn_vola.pressed.connect(_on_vola)

func get_player():
	var player = get_tree().get_first_node_in_group("player")
	print("player found:", player)
	return player

func mostra(bar):
	barriera_corrente = bar
	visible = true
	scelta_container.visible = false
	btn_si.visible = true
	btn_no.visible = true

	var player = get_player()
	if player:
		player.bloccato = true
	else:
		print("ERROR: player not found in group 'player'")

func _on_si():
	btn_si.visible = false
	btn_no.visible = false
	scelta_container.visible = true

	btn_vola.disabled = !volo_sbloccato
	btn_vola.text = "VOLARE" if volo_sbloccato else "VOLARE BLOCCATO"

func _on_no():
	visible = false
	annullato.emit()

	var player = get_player()
	if player:
		player.bloccato = false

	if barriera_corrente:
		barriera_corrente.disabled = false

func _on_nuota():
	visible = false
	scelta_nuota.emit()

	var player = get_player()
	if player:
		player.bloccato = false
		if player.has_method("inizia_nuoto"):
			player.inizia_nuoto()
		else:
			print("ERROR: player has no method inizia_nuoto()")
	else:
		print("ERROR: player not found, cannot start swimming")

	if barriera_corrente:
		barriera_corrente.disabled = true

func _on_vola():
	visible = false
	scelta_vola.emit()

	var player = get_player()
	if player:
		player.bloccato = false
		if player.has_method("inizia_volo"):
			player.inizia_volo()
		else:
			print("ERROR: player has no method inizia_volo()")
	else:
		print("ERROR: player not found, cannot start flying")

	if barriera_corrente:
		barriera_corrente.disabled = true

func sblocca_volo():
	volo_sbloccato = true
	print("Flight unlocked")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.has_method("_atterra"):
			if body.stato == body.Stato.NUOTO or body.stato == body.Stato.VOLO:
				body._atterra()
				return

		var bar = get_parent().get_node("Wood/Pier/StaticBody2D/CollisionShapeBarrier")
		mostra(bar)

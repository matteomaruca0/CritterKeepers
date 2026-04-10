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
	visible = false
	scelta_container.visible = false
	btn_si.pressed.connect(_on_si)
	btn_no.pressed.connect(_on_no)
	btn_nuota.pressed.connect(_on_nuota)
	btn_vola.pressed.connect(_on_vola)

func mostra(bar):
	barriera_corrente = bar
	visible = true
	scelta_container.visible = false
	btn_si.visible = true
	btn_no.visible = true
	get_tree().get_first_node_in_group("player").bloccato = true

func _on_si():
	btn_si.visible = false
	btn_no.visible = false
	scelta_container.visible = true
	btn_vola.disabled = !volo_sbloccato
	btn_vola.text = tr("VOLARE") if volo_sbloccato else tr("VOLARE_BLOCCATO")

func _on_no():
	visible = false
	annullato.emit()
	get_tree().get_first_node_in_group("player").bloccato = false
	print("barriera_corrente: ", barriera_corrente)
	if barriera_corrente:
		barriera_corrente.disabled = false
		print("barriera attivata!")

func _on_nuota():
	visible = false
	scelta_nuota.emit()
	get_tree().get_first_node_in_group("player").bloccato = false
	if barriera_corrente:
		barriera_corrente.disabled = true
	get_tree().get_first_node_in_group("player").inizia_nuoto()

func _on_vola():
	visible = false
	scelta_vola.emit()
	get_tree().get_first_node_in_group("player").bloccato = false
	if barriera_corrente:
		barriera_corrente.disabled = true
	get_tree().get_first_node_in_group("player").inizia_volo()

# Per sbloccare il volo quando parli con un guru:
# get_tree().get_first_node_in_group("viaggio_prompt").volo_sbloccato = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.stato == body.Stato.NUOTO or body.stato == body.Stato.VOLO:
			body._atterra()
		else:
			var bar = get_parent().get_node("Wood/Pier/StaticBody2D/CollisionShapeBarrier")
			mostra(bar)

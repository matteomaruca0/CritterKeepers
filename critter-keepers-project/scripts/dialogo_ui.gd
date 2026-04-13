extends Control

@onready var pannello = $Pannello

@onready var label_domande: Label = $Pannello/MarginContainer/VBox/LabelDomande
@onready var label_npc: Label = $Pannello/MarginContainer/VBox/LabelNPC

@onready var btn_a: Button = $Pannello/MarginContainer/VBox/HboxBottoni/BtnA
@onready var btn_b: Button = $Pannello/MarginContainer/VBox/HboxBottoni/BtnB
@onready var btn_c: Button = $Pannello/MarginContainer/VBox/HboxBottoni/BtnC
@onready var btn_d: Button = $Pannello/MarginContainer/VBox/HboxBottoni/BtnD

@onready var label_feedback: Label = $Pannello/MarginContainer/VBox/LabelFeedback
@onready var btn_chiudi: Button = $Pannello/MarginContainer/VBox/BtnChiudi

var domanda_attuale: Dictionary = {}
var guru_corrente: int = 0
var hud: CanvasLayer = null

var messaggi_bloccati := [
	"You are not ready for this guru yet.",
	"Answer the previous guru first.",
	"One step at a time.",
	"The path is still closed to you.",
	"Complete the earlier challenge first."
]

func _ready() -> void:
	add_to_group("dialogo_ui")

	visible = false
	label_feedback.text = ""

	btn_a.pressed.connect(_on_risposta_selezionata.bind("A"))
	btn_b.pressed.connect(_on_risposta_selezionata.bind("B"))
	btn_c.pressed.connect(_on_risposta_selezionata.bind("C"))
	btn_d.pressed.connect(_on_risposta_selezionata.bind("D"))
	btn_chiudi.pressed.connect(_on_btn_chiudi_pressed)

	hud = get_tree().get_first_node_in_group("hud")

func mostra_domanda(domanda: Dictionary, guru_id: int, guru_position: Vector2) -> void:
	domanda_attuale = domanda
	guru_corrente = guru_id

	label_npc.text = "Guru " + str(guru_id)
	label_domande.text = domanda["question"]

	btn_a.text = "A) " + domanda["options"]["A"]
	btn_b.text = "B) " + domanda["options"]["B"]
	btn_c.text = "C) " + domanda["options"]["C"]
	btn_d.text = "D) " + domanda["options"]["D"]

	btn_a.visible = true
	btn_b.visible = true
	btn_c.visible = true
	btn_d.visible = true

	btn_a.disabled = false
	btn_b.disabled = false
	btn_c.disabled = false
	btn_d.disabled = false

	label_feedback.text = ""
	label_feedback.modulate = Color(1, 1, 1, 1)

	visible = true
	await get_tree().process_frame
	posiziona_sopra_guru(guru_position)

func mostra_messaggio_bloccato(guru_position: Vector2) -> void:
	domanda_attuale = {}
	guru_corrente = 0

	label_npc.text = ""
	label_domande.text = messaggi_bloccati[randi() % messaggi_bloccati.size()]
	label_feedback.text = ""
	label_feedback.modulate = Color(1, 1, 1, 1)

	btn_a.visible = false
	btn_b.visible = false
	btn_c.visible = false
	btn_d.visible = false

	visible = true
	await get_tree().process_frame
	posiziona_sopra_guru(guru_position)

func mostra_messaggio_custom(msg: String, guru_position: Vector2) -> void:
	domanda_attuale = {}
	guru_corrente = 0

	label_npc.text = ""
	label_domande.text = msg
	label_feedback.text = ""
	label_feedback.modulate = Color(1, 1, 1, 1)

	btn_a.visible = false
	btn_b.visible = false
	btn_c.visible = false
	btn_d.visible = false

	visible = true
	await get_tree().process_frame
	posiziona_sopra_guru(guru_position)

func posiziona_sopra_guru(world_position: Vector2) -> void:
	var screen_position = get_viewport().get_canvas_transform() * world_position

	screen_position.x -= pannello.size.x / 2.0
	screen_position.y -= 140

	pannello.position = screen_position

func _on_risposta_selezionata(scelta: String) -> void:
	btn_a.disabled = true
	btn_b.disabled = true
	btn_c.disabled = true
	btn_d.disabled = true

	if domanda_attuale.is_empty():
		return

	if scelta == domanda_attuale["correct_answer"]:
		label_feedback.text = domanda_attuale["correct_feedback"]
		label_feedback.modulate = Color(0.2, 0.8, 0.2)

		var qid = str(domanda_attuale.get("id", ""))
		if qid != "":
			GameManager.register_correct_answer(guru_corrente, qid)

		if hud:
			hud.risposta_corretta()
	else:
		label_feedback.text = domanda_attuale.get("incorrect_feedback", "Wrong answer.")
		label_feedback.modulate = Color(0.8, 0.2, 0.2)

func _on_btn_chiudi_pressed() -> void:
	visible = false

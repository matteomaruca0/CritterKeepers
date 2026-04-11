extends Control

@onready var label_domande: Label = $Pannello/MarginContainer/VBox/LabelDomande
@onready var btn_a: Button = $Pannello/MarginContainer/VBox/HboxBottoni/BtnA
@onready var btn_b: Button = $Pannello/MarginContainer/VBox/HboxBottoni/BtnB
@onready var btn_c: Button = $Pannello/MarginContainer/VBox/HboxBottoni/BtnC
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
	visible = false
	label_feedback.text = ""

	add_to_group("dialogo_ui")

	btn_a.pressed.connect(_on_risposta_selezionata.bind("A"))
	btn_b.pressed.connect(_on_risposta_selezionata.bind("B"))
	btn_c.pressed.connect(_on_risposta_selezionata.bind("C"))
	btn_chiudi.pressed.connect(_on_btn_chiudi_pressed)

	hud = get_tree().get_first_node_in_group("hud")

func mostra_domanda(domanda: Dictionary, guru_id: int) -> void:
	domanda_attuale = domanda
	guru_corrente = guru_id

	label_domande.text = domanda["question"]
	btn_a.text = "A) " + domanda["options"]["A"]
	btn_b.text = "B) " + domanda["options"]["B"]
	btn_c.text = "C) " + domanda["options"]["C"]

	btn_a.visible = true
	btn_b.visible = true
	btn_c.visible = true

	btn_a.disabled = false
	btn_b.disabled = false
	btn_c.disabled = false

	label_feedback.text = ""
	visible = true

func mostra_messaggio_bloccato() -> void:
	domanda_attuale = {}
	guru_corrente = 0

	label_domande.text = messaggi_bloccati[randi() % messaggi_bloccati.size()]
	label_feedback.text = ""

	btn_a.visible = false
	btn_b.visible = false
	btn_c.visible = false

	visible = true

func _on_risposta_selezionata(scelta: String) -> void:
	btn_a.disabled = true
	btn_b.disabled = true
	btn_c.disabled = true

	if domanda_attuale.is_empty():
		return

	if scelta == domanda_attuale["correct_answer"]:
		label_feedback.text = domanda_attuale["correct_feedback"]
		label_feedback.modulate = Color(0.2, 0.8, 0.2)
		GameManager.complete_guru(guru_corrente)

		if hud:
			hud.risposta_corretta()
	else:
		label_feedback.text = domanda_attuale["incorrect_feedback"]
		label_feedback.modulate = Color(0.8, 0.2, 0.2)

func _on_btn_chiudi_pressed() -> void:
	visible = false

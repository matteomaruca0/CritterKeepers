extends Control

@onready var label_domande: Label = $Pannello/MarginContainer/VBox/LabelDomande
@onready var btn_a: Button = $Pannello/MarginContainer/VBox/HboxBottoni/BtnA
@onready var btn_b: Button = $Pannello/MarginContainer/VBox/HboxBottoni/BtnB
@onready var btn_c: Button = $Pannello/MarginContainer/VBox/HboxBottoni/BtnC
@onready var label_feedback: Label = $Pannello/MarginContainer/VBox/LabelFeedback
@onready var btn_chiudi: Button = $Pannello/MarginContainer/VBox/BtnChiudi

var domanda_attuale: Dictionary = {}

func _ready() -> void:
	visible = false
	label_feedback.text = ""
	
	btn_a.pressed.connect(_on_risposta_selezionata.bind("A"))
	btn_b.pressed.connect(_on_risposta_selezionata.bind("B"))
	btn_c.pressed.connect(_on_risposta_selezionata.bind("C"))
	btn_chiudi.pressed.connect(_on_btn_chiudi_pressed)

func mostra_domanda(domanda: Dictionary) -> void:
	domanda_attuale = domanda
	
	label_domande.text = domanda["question"]
	btn_a.text = "A) " + domanda["options"]["A"]
	btn_b.text = "B) " + domanda["options"]["B"]
	btn_c.text = "C) " + domanda["options"]["C"]
	
	label_feedback.text = ""
	btn_a.disabled = false
	btn_b.disabled = false
	btn_c.disabled = false
	
	visible = true

func _on_risposta_selezionata(scelta: String) -> void:
	btn_a.disabled = true
	btn_b.disabled = true
	btn_c.disabled = true
	
	if scelta == domanda_attuale["correct_answer"]:
		label_feedback.text = domanda_attuale["correct_feedback"]
		label_feedback.modulate = Color(0.2, 0.8, 0.2)
	else:
		label_feedback.text = domanda_attuale["incorrect_feedback"]
		label_feedback.modulate = Color(0.8, 0.2, 0.2)

func _on_btn_chiudi_pressed() -> void:
	visible = false

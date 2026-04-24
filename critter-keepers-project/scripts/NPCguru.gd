extends StaticBody2D

signal player_nearby(is_near: bool)

@export var domande_path_EN: String = "res://questions/QuestionsEN.json"
@export var domande_path_IT: String = "res://questions/QuestionsIT.json"
@export var guru_id: int = 1

var player_in_range: bool = false
var domande: Array = []
var domanda_corrente: Dictionary = {}
var habitat_del_guru: String = ""

@onready var area_interazione: Area2D = $AreaInterazione
@onready var label_interagisci: Label = $LabelInteragisci

func _ready() -> void:
	print(name, " guru_id = ", guru_id)
	
	# Identifica l'habitat del guru leggendo i suoi gruppi
	for gruppo in get_groups():
		if gruppo.begins_with("habitat_"):
			habitat_del_guru = gruppo
			break

	if habitat_del_guru == "":
		push_error("Errore: Il guru " + name + " non fa parte di nessun gruppo habitat (es. 'habitat_Savanah').")

	_carica_domande()
	
	if not domande.is_empty():
		GameManager.register_guru_total(guru_id, domande.size())

	label_interagisci.visible = false

	area_interazione.body_entered.connect(_on_player_entrato)
	area_interazione.body_exited.connect(_on_player_uscito)
	
func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSLATION_CHANGED:
		_carica_domande()

func _carica_domande() -> void:
	if habitat_del_guru == "":
		return # Interrompi se il guru non ha un habitat assegnato

	var file
	var current_path = ""
	
	if TranslationServer.get_locale().begins_with("en"): 
		current_path = domande_path_EN
	else:
		current_path = domande_path_IT
		
	file = FileAccess.open(current_path, FileAccess.READ)
	
	if file == null:
		push_error("Cannot open questions file: " + current_path)
		return

	var json_text = file.get_as_text()
	file.close()

	var json = JSON.new()
	var err = json.parse(json_text)

	if err != OK:
		push_error("JSON parse error in: " + current_path)
		return

	# Controlla se il JSON ha l'habitat richiesto (es: "habitat_temperateForest")
	if not json.data.has(habitat_del_guru):
		push_error("Missing '" + habitat_del_guru + "' field in: " + current_path)
		return

	# Carica solo le domande di quello specifico habitat
	domande = json.data[habitat_del_guru]

func _on_player_entrato(body: Node2D) -> void:
	#_ready()
	if body.is_in_group("player"):
		player_in_range = true
		label_interagisci.visible = true
		emit_signal("player_nearby", true)

func _on_player_uscito(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		label_interagisci.visible = false
		emit_signal("player_nearby", false)

func _input(event: InputEvent) -> void:
	if player_in_range and event.is_action_pressed("ui_accept"):
		var dialogo = get_tree().get_first_node_in_group("dialogo_ui")

		if dialogo == null:
			print("dialogo_ui not found")
			return

		if dialogo.visible:
			return

		if not GameManager.can_answer_guru(guru_id):
			dialogo.mostra_messaggio_bloccato(global_position)
			return

		_avvia_dialogo()

func _avvia_dialogo() -> void:
	if domande.is_empty():
		print("No questions loaded for guru ", guru_id)
		return

	var domande_non_risposte: Array = []

	for domanda in domande:
		var qid = str(domanda.get("id", ""))
		if qid == "":
			continue
		if not GameManager.question_already_answered(guru_id, qid):
			domande_non_risposte.append(domanda)

	var dialogo = get_tree().get_first_node_in_group("dialogo_ui")

	if domande_non_risposte.is_empty():
		if dialogo:
			dialogo.mostra_messaggio_custom("You already completed all questions for this guru.", global_position)
		return

	domanda_corrente = domande_non_risposte[randi() % domande_non_risposte.size()]

	if dialogo:
		dialogo.mostra_domanda(domanda_corrente, guru_id, global_position)
		
		

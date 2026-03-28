extends StaticBody2D

# Segnale emesso quando il player entra/esce dal raggio di interazione
signal player_nearby(is_near: bool)

@export var interaction_radius: float = 40.0
@export var domande_path: String = "res://domande.json"

var player_in_range: bool = false
var domande: Array = []
var domanda_corrente: Dictionary = {}

# Riferimento al popup di dialogo (impostato dalla scena)
@onready var area_interazione: Area2D = $AreaInterazione
@onready var label_interagisci: Label = $LabelInteragisci

func _ready() -> void:
	_carica_domande()
	label_interagisci.visible = false
	# Connetti i segnali dell'area
	area_interazione.body_entered.connect(_on_player_entrato)
	area_interazione.body_exited.connect(_on_player_uscito)

func _carica_domande() -> void:
	var file = FileAccess.open(domande_path, FileAccess.READ)
	if file == null:
		push_error("NPC: impossibile aprire il file domande.json")
		return
	var json_text = file.get_as_text()
	file.close()
	var json = JSON.new()
	var err = json.parse(json_text)
	if err != OK:
		push_error("NPC: errore nel parsing del JSON")
		return
	domande = json.data["questions"]

func _on_player_entrato(body: Node2D) -> void:
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
		_avvia_dialogo()

func _avvia_dialogo() -> void:
	print("Tasto E premuto!")
	
	if domande.is_empty():
		print("ERRORE: Le domande non sono state caricate. Controlla il percorso o il parsing del JSON.")
		return
		
	domanda_corrente = domande[randi() % domande.size()]
	
	var dialogo = get_tree().get_first_node_in_group("dialogo_ui")
	if dialogo:
		print("Interfaccia trovata, mostro il popup.")
		dialogo.mostra_domanda(domanda_corrente)
	else:
		print("ERRORE: Nessun nodo trovato nel gruppo 'dialogo_ui'.")

func get_domanda_casuale() -> Dictionary:
	if domande.is_empty():
		return {}
	return domande[randi() % domande.size()]

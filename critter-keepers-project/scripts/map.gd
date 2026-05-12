extends Node2D

@onready var instruction = $UI_Instructions
@onready var prompt1 = $PierRock1/TravelPanel
@onready var prompt2 = $PierRock2/TravelPanel
@onready var prompt3 = $PierRock3/TravelPanel
@onready var unlocked = $UiAllGuruUnlocked

var range = [2,4,6,8]

func show_instructions():
	instruction.visible = true

func _ready():
	#Show instructions
	show_instructions()
	
	prompt1.scelta_nuota.connect(_on_nuota)
	prompt1.scelta_vola.connect(_on_vola)

	prompt2.scelta_nuota.connect(_on_nuota)
	prompt2.scelta_vola.connect(_on_vola)

	prompt3.scelta_nuota.connect(_on_nuota)
	prompt3.scelta_vola.connect(_on_vola)

func _process(delta: float) -> void:
	controlla_progresso_guru()
	
	controlla_fine_gioco()

func _on_nuota():
	print("Map received swim signal")

func _on_vola():
	print("Map received fly signal")

func controlla_progresso_guru():
	var guru_attuale = GameManager.getCurrentGuru()-1
	# Controlla se il guru è uno di quelli richiesti (2, 4, 6, 8)
	if guru_attuale in range:
		range.erase(guru_attuale)
		_mostra_messaggio_temporaneo()

# Funzione interna per gestire la comparsa e scomparsa
func _mostra_messaggio_temporaneo():
	# Supponendo che tu abbia un nodo Label chiamato LabelAnnuncio
	unlocked.visible = true
	print("Unlocked")
	# Crea un timer di 3 secondi direttamente via codice
	await get_tree().create_timer(3.0).timeout
	
	# Nasconde la scritta dopo che il tempo è scaduto
	unlocked.visible = false

func controlla_fine_gioco():
	var hud = get_tree().get_first_node_in_group("hud")
	
	if hud and hud.is_xp_massimo():
		get_tree().change_scene_to_file("res://scenes/winner_scene.tscn")

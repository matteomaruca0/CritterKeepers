extends CanvasLayer

@onready var barra_xp       = $UIRoot/PanelContainer/HBoxContainer/VBoxContainer/ProgressBar
@onready var label_xp       = $UIRoot/PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer/LabelXP
@onready var label_monete   = $UIRoot/PanelContainer/HBoxContainer/HBoxContainer/LabelCoins
@onready var label_notifica = $UIRoot/LabelNotifications

var xp     : int = 0
var monete : int = 0
const XP_PER_LIVELLO : int = 100
var notifica_timer : float = 0.0

func _ready() -> void:
	aggiorna_ui()

func _process(delta):
	if notifica_timer > 0:
		notifica_timer -= delta
		if notifica_timer <= 0:
			label_notifica.visible = false

func risposta_corretta():
	aggiungi_xp(10)
	aggiungi_monete(10)

func aggiungi_xp(quantita: int):
	xp += quantita
	while xp >= XP_PER_LIVELLO:
		xp -= XP_PER_LIVELLO
		mostra_notifica(tr("LIVELLO_RAGGIUNTO"))
		return
	mostra_notifica(tr("XP_MONETE"))
	aggiorna_ui()

func aggiungi_monete(quantita: int):
	monete += quantita
	aggiorna_ui()

func aggiorna_ui():
	barra_xp.value    = xp
	label_xp.text     = "%d / %d XP" % [xp, XP_PER_LIVELLO]
	label_monete.text = str(monete)

func mostra_notifica(testo: String):
	label_notifica.text    = testo
	label_notifica.visible = true
	notifica_timer         = 2.0

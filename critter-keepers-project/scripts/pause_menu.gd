extends CanvasLayer


@onready var btn_pausa = $BtnPause
@onready var panel_menu = $PanelMenu
@onready var btn_salva_esci = $PanelMenu/VBoxContainer/BtnSaveAndEsc
@onready var btn_esci = $PanelMenu/VBoxContainer/BtnEsc
@onready var btn_impostazioni = $PanelMenu/VBoxContainer/BtnSettings
@onready var btn_close = $PanelMenu/VBoxContainer/BtnClose
@onready var panel_impostazioni = $PanelSettings
@onready var btn_italiano = $PanelSettings/VBoxContainer/BtnItalian
@onready var btn_inglese = $PanelSettings/VBoxContainer/BtnEnglish
@onready var btn_chiudi_impostazioni = $PanelSettings/VBoxContainer/BtnClose
@onready var checkbox_musica = $PanelSettings/VBoxContainer/CheckBoxMusic

func _ready():
	panel_menu.visible = false
	panel_impostazioni.visible = false
	btn_pausa.pressed.connect(_on_pausa)
	#btn_salva_esci.pressed.connect(_on_salva_esci)
	btn_esci.pressed.connect(_on_esci)
	btn_impostazioni.pressed.connect(_on_impostazioni)
	btn_italiano.pressed.connect(_on_italiano)
	btn_inglese.pressed.connect(_on_inglese)
	btn_chiudi_impostazioni.pressed.connect(_on_chiudi_impostazioni)
	btn_close.pressed.connect(_on_chiudi)
	checkbox_musica.button_pressed = true  # di default musica attiva
	checkbox_musica.toggled.connect(_on_musica_toggled)
	
func _on_chiudi(): 
	panel_menu.visible = false
	get_tree().paused = false

func _on_pausa():
	panel_menu.visible = !panel_menu.visible
	get_tree().paused = panel_menu.visible

func _on_salva_esci():
	get_tree().paused = false
	get_tree().quit()

func _on_esci():
	get_tree().paused = false
	get_tree().quit()

func _on_impostazioni():
	panel_menu.visible = false
	panel_impostazioni.visible = true

func _on_italiano():
	TranslationServer.set_locale("it")

func _on_inglese():
	TranslationServer.set_locale("en")

func _on_chiudi_impostazioni():
	panel_impostazioni.visible = false
	get_tree().paused = false

func _on_musica_toggled(attiva: bool):
	print("toggled: ", attiva)
	var musica = get_tree().get_first_node_in_group("background_music")
	print("musica trovata: ", musica)
	if musica:
		if attiva:
			musica.play()
		else:
			musica.stop()

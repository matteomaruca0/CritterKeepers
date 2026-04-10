extends CanvasLayer

@onready var btn_pausa = $BtnPause
@onready var panel_menu = $PanelMenu
@onready var btn_salva_esci = $PanelMenu/VBoxContainer/BtnSaveAndEsc
@onready var btn_esci = $PanelMenu/VBoxContainer/BtnEsc
@onready var btn_impostazioni = $PanelMenu/VBoxContainer/BtnSettings
@onready var panel_impostazioni = $PanelSettings
@onready var btn_italiano = $PanelSettings/VBoxContainer/BtnItalian
@onready var btn_inglese = $PanelSettings/VBoxContainer/BtnEnglish
@onready var btn_chiudi_impostazioni = $PanelSettings/VBoxContainer/BtnClose

func _ready():
	panel_menu.visible = false
	panel_impostazioni.visible = false
	btn_pausa.pressed.connect(_on_pausa)
	btn_salva_esci.pressed.connect(_on_salva_esci)
	btn_esci.pressed.connect(_on_esci)
	btn_impostazioni.pressed.connect(_on_impostazioni)
	btn_italiano.pressed.connect(_on_italiano)
	btn_inglese.pressed.connect(_on_inglese)
	btn_chiudi_impostazioni.pressed.connect(_on_chiudi_impostazioni)

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

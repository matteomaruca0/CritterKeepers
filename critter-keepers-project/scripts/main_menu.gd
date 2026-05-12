extends Control

@onready var settingPanel = $PanelSettings
@onready var btnIta = $PanelSettings/VBoxContainer/BtnItaliano
@onready var btnEng = $PanelSettings/VBoxContainer/BtnEnglish
@onready var btnEsc = $PanelSettings/VBoxContainer/BtnClose

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	settingPanel.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_new_game_pressed():
	print('New Game Pressed')
	get_tree().change_scene_to_file("res://scenes/map2.tscn")


func _on_load_game_pressed():
	print('Load Game Pressed')


func _on_settings_pressed():
	settingPanel.visible = true
	btnIta.pressed.connect(_on_ita)
	btnEng.pressed.connect(_on_eng)
	btnEsc.pressed.connect(_on_close)
	print('Settings Pressed')


func _on_quit_pressed():
	get_tree().quit()

func _on_ita():
	TranslationServer.set_locale("it")

func _on_eng():
	TranslationServer.set_locale("en")

func _on_close():
	settingPanel.visible = false

extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_new_game_pressed():
	print('New Game Pressed')


func _on_load_game_pressed():
	print('Load Game Pressed')


func _on_settings_pressed():
	print('Settings Pressed')


func _on_quit_pressed():
	get_tree().quit()
	

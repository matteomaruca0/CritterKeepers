extends Control

@onready var btn = $Panel/VBoxContainer/BtnClose

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	btn.pressed.connect(_on_close)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_close():
	get_tree().quit()

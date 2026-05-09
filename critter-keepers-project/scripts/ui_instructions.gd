extends CanvasLayer

@onready var btnClose = $PanelContainer/VBoxContainer/ButtonClose


func _ready() -> void:
	#$VBoxContainer.rect_min_size = Vector2(300, 200)
	var player = get_tree().get_first_node_in_group("player")
	player.bloccato = true
	#Press
	btnClose.pressed.connect(_on_Button_close_pressed)
	
	pass # Replace with function body.

func _on_Button_close_pressed():
	var player = get_tree().get_first_node_in_group("player")
	player.bloccato = false
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

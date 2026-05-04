extends CanvasLayer

@onready var btnClose = $Panel/VBoxContainer/ButtonClose

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#$VBoxContainer.rect_min_size = Vector2(300, 200)
	
	#Press
	btnClose.pressed.connect(_on_Button_close_pressed)
	
	pass # Replace with function body.

func _on_Button_close_pressed():
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

extends CharacterBody2D

const SPEED = 150.0

func _physics_process(delta):
	# Ottieni la direzione dell'input (frecce direzionali o WASD)
	var direction_x = Input.get_axis("ui_left", "ui_right")
	var direction_y = Input.get_axis("ui_up", "ui_down")
	
	# Calcola il vettore di movimento e normalizzalo per evitare movimenti diagonali troppo veloci
	velocity = Vector2(direction_x, direction_y).normalized() * SPEED
	
	# Applica il movimento e gestisci automaticamente le collisioni
	move_and_slide()

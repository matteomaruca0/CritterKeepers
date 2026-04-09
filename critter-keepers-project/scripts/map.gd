extends Node2D

@onready var prompt1 = $PierRock1/TravelPanel
@onready var prompt2 = $PierRock2/TravelPanel
@onready var prompt3 = $PierRock3/TravelPanel
@onready var player = $Player

func _ready():
	#Molo 1
	prompt1.scelta_nuota.connect(_on_nuota)
	prompt1.scelta_vola.connect(_on_vola)
	
	#Molo 2
	prompt2.scelta_nuota.connect(_on_nuota)
	prompt2.scelta_vola.connect(_on_vola)
	
	#Molo 3
	prompt3.scelta_nuota.connect(_on_nuota)
	prompt3.scelta_vola.connect(_on_vola)

#func _on_molo_trigger_body_entered(body):
#	if body.is_in_group("player"):
#		prompt.mostra()

func _on_nuota():
	player.inizia_nuoto()

func _on_vola():
	player.inizia_volo()

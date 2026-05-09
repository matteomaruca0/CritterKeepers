extends Node2D

@onready var instruction = $UI_Instructions
@onready var prompt1 = $PierRock1/TravelPanel
@onready var prompt2 = $PierRock2/TravelPanel
@onready var prompt3 = $PierRock3/TravelPanel

func show_instructions():
	instruction.visible = true

func _ready():
	#Show instructions
	show_instructions()
	
	prompt1.scelta_nuota.connect(_on_nuota)
	prompt1.scelta_vola.connect(_on_vola)

	prompt2.scelta_nuota.connect(_on_nuota)
	prompt2.scelta_vola.connect(_on_vola)

	prompt3.scelta_nuota.connect(_on_nuota)
	prompt3.scelta_vola.connect(_on_vola)

func _on_nuota():
	print("Map received swim signal")

func _on_vola():
	print("Map received fly signal")
	

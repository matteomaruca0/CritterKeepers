extends Node

var current_guru: int = 1

func can_answer_guru(guru_id: int) -> bool:
	return guru_id == current_guru

func complete_guru(guru_id: int) -> void:
	if guru_id == current_guru:
		current_guru += 1
		print("Unlocked guru ", current_guru)

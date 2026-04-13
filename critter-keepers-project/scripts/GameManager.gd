extends Node

var current_guru: int = 1

var guru_correct_counts := {}
var guru_total_questions := {}
var guru_answered_questions := {}

func can_answer_guru(guru_id: int) -> bool:
	return guru_id == current_guru

func register_guru_total(guru_id: int, total_questions: int) -> void:
	guru_total_questions[guru_id] = total_questions

	if not guru_correct_counts.has(guru_id):
		guru_correct_counts[guru_id] = 0

	if not guru_answered_questions.has(guru_id):
		guru_answered_questions[guru_id] = []

func question_already_answered(guru_id: int, question_id: String) -> bool:
	if not guru_answered_questions.has(guru_id):
		return false
	return question_id in guru_answered_questions[guru_id]

func register_correct_answer(guru_id: int, question_id: String) -> void:
	if not guru_answered_questions.has(guru_id):
		guru_answered_questions[guru_id] = []

	if question_id in guru_answered_questions[guru_id]:
		return

	guru_answered_questions[guru_id].append(question_id)

	if not guru_correct_counts.has(guru_id):
		guru_correct_counts[guru_id] = 0

	guru_correct_counts[guru_id] += 1

	print("Guru ", guru_id, " progress: ", guru_correct_counts[guru_id], "/", guru_total_questions.get(guru_id, 0))

	if guru_correct_counts[guru_id] >= guru_total_questions.get(guru_id, 999999):
		current_guru += 1
		print("Unlocked guru ", current_guru)

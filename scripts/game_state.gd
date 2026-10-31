extends Node

## Autoload singleton managing game state, language, current location, scene paths, clues, and puzzle progression.

const Localization = preload("res://scripts/localization.gd")

signal language_changed(lang: String)
signal clue_added(clue_id: String, clue_description: String)
signal clue_discovered(clue: Dictionary)
signal deduction_unlocked(deduction_id: String, deduction_data: Dictionary)
signal puzzle_solved(puzzle_id: String)
signal question_asked(character_id: String, question_id: String)
signal information_revealed(info_key: String)
signal evidence_presented(character_id: String, clue_id: String, is_contradiction: bool)

var current_language: String = "my" # Defaults to Myanmar as requested
var current_location_id: String = "downtown"
var discovered_clues: Array[Dictionary] = []
var unlocked_deductions: Array[String] = []
var completed_puzzles: Dictionary = {}
var asked_dialogue_questions: Dictionary = {}
var revealed_dialogue_info: Dictionary = {}

const LOCATIONS: Dictionary = {
	"downtown": {
		"scene_path": "res://scenes/locations/downtown.tscn",
		"color": Color(0.12, 0.16, 0.24, 1.0),
		"accent": Color(0.96, 0.76, 0.35, 1.0)
	},
	"tea_shop": {
		"scene_path": "res://scenes/locations/tea_shop.tscn",
		"color": Color(0.22, 0.15, 0.10, 1.0),
		"accent": Color(0.92, 0.58, 0.28, 1.0)
	},
	"market": {
		"scene_path": "res://scenes/locations/market.tscn",
		"color": Color(0.18, 0.11, 0.22, 1.0),
		"accent": Color(0.85, 0.42, 0.55, 1.0)
	}
}

func _ready() -> void:
	TranslationServer.set_locale(current_language)

## Language and Localization
func set_language(lang: String) -> void:
	if lang != "en" and lang != "my":
		return
	if current_language != lang:
		current_language = lang
		TranslationServer.set_locale(lang)
		language_changed.emit(current_language)

func toggle_language() -> void:
	var next_lang = "en" if current_language == "my" else "my"
	set_language(next_lang)

func get_language() -> String:
	return current_language

func loc(key: String) -> String:
	return Localization.get_ui_text(key, current_language)

func get_current_location_data() -> Dictionary:
	return get_location_data(current_location_id)

func get_location_data(loc_id: String) -> Dictionary:
	var base = LOCATIONS.get(loc_id, LOCATIONS["downtown"]).duplicate()
	var text_data = Localization.get_location_data(loc_id, current_language)
	base["title"] = text_data.get("title", "")
	base["subtitle"] = text_data.get("subtitle", "")
	base["description"] = text_data.get("description", "")
	return base

func go_to_location(loc_id: String) -> void:
	if LOCATIONS.has(loc_id):
		current_location_id = loc_id
		var path: String = LOCATIONS[loc_id]["scene_path"]
		get_tree().change_scene_to_file(path)

## Clue Management System (Persistent across scene changes)
func add_clue(id: String, default_title: String, default_desc: String, default_loc: String) -> bool:
	if id.is_empty():
		return false
	
	# Prevent duplicate clues from being recorded repeatedly
	for clue in discovered_clues:
		if clue.get("id", "") == id:
			return false
	
	var new_clue: Dictionary = {
		"id": id,
		"default_title": default_title,
		"default_desc": default_desc,
		"default_loc": default_loc,
		"timestamp": "11:45 PM"
	}
	discovered_clues.append(new_clue)
	clue_added.emit(id, default_desc)
	clue_discovered.emit(get_localized_clue(new_clue))
	return true

func has_clue(id: String) -> bool:
	for clue in discovered_clues:
		if clue.get("id", "") == id:
			return true
	return false

func get_clues() -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for clue in discovered_clues:
		result.append(get_localized_clue(clue))
	return result

func get_localized_clue(clue: Dictionary) -> Dictionary:
	var id: String = clue.get("id", "")
	var clue_loc = Localization.get_clue_data(id, current_language)
	return {
		"id": id,
		"title": clue_loc.get("title", clue.get("default_title", "")),
		"description": clue_loc.get("description", clue.get("default_desc", "")),
		"location": clue_loc.get("location", clue.get("default_loc", "")),
		"icon": clue_loc.get("icon", "🔍"),
		"timestamp": clue.get("timestamp", "11:45 PM")
	}

func get_clue_count() -> int:
	return discovered_clues.size()

func clear_clues() -> void:
	discovered_clues.clear()

## Deduction Management System (Synthesis of evidence)
func unlock_deduction(id: String) -> bool:
	if id.is_empty() or has_deduction(id):
		return false
	unlocked_deductions.append(id)
	var data: Dictionary = Localization.get_deduction_data(id, current_language)
	deduction_unlocked.emit(id, data)
	return true

func has_deduction(id: String) -> bool:
	return unlocked_deductions.has(id)

func get_deductions() -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for did in unlocked_deductions:
		result.append(Localization.get_deduction_data(did, current_language))
	return result

func get_deduction_count() -> int:
	return unlocked_deductions.size()

func clear_deductions() -> void:
	unlocked_deductions.clear()

## Evaluates whether connecting two clue IDs forms a valid deduction
func evaluate_clue_connection(clue_id_1: String, clue_id_2: String) -> Dictionary:
	if clue_id_1.is_empty() or clue_id_2.is_empty() or clue_id_1 == clue_id_2:
		return {
			"status": "INVALID",
			"message": Localization.get_ui_text("NOTEBOOK_FEEDBACK_SELECT_TWO", current_language),
			"deduction": {}
		}
	
	var lang: String = current_language
	var matched_deduction_id: String = ""
	
	for did in Localization.DEDUCTIONS:
		var d_info = Localization.DEDUCTIONS[did]
		var req_clues: Array = d_info.get("clues", [])
		if req_clues.size() == 2:
			if (req_clues[0] == clue_id_1 and req_clues[1] == clue_id_2) or \
			   (req_clues[0] == clue_id_2 and req_clues[1] == clue_id_1):
				matched_deduction_id = did
				break
	
	if matched_deduction_id.is_empty():
		return {
			"status": "NO_CONNECTION",
			"message": Localization.get_ui_text("NOTEBOOK_FEEDBACK_NO_MATCH", lang),
			"deduction": {}
		}
	
	var ded_data = Localization.get_deduction_data(matched_deduction_id, lang)
	var ded_title = ded_data.get("title", matched_deduction_id)
	
	if has_deduction(matched_deduction_id):
		var fmt_already = Localization.get_ui_text("NOTEBOOK_FEEDBACK_ALREADY", lang)
		return {
			"status": "ALREADY_UNLOCKED",
			"message": fmt_already % ded_title,
			"deduction": ded_data
		}
	
	unlock_deduction(matched_deduction_id)
	var fmt_succ = Localization.get_ui_text("NOTEBOOK_FEEDBACK_SUCCESS", lang)
	return {
		"status": "SUCCESS",
		"message": fmt_succ % ded_title,
		"deduction": ded_data
	}

## Puzzle Progression System (Persistent across scene changes)
func mark_puzzle_solved(puzzle_id: String) -> void:
	if not puzzle_id.is_empty():
		completed_puzzles[puzzle_id] = true
		puzzle_solved.emit(puzzle_id)

func is_puzzle_solved(puzzle_id: String) -> bool:
	return completed_puzzles.get(puzzle_id, false)

func get_solved_puzzle_count() -> int:
	var count: int = 0
	for p in completed_puzzles:
		if completed_puzzles[p]:
			count += 1
	return count

func is_game_completed() -> bool:
	return is_puzzle_solved("final_delivery_puzzle")

func clear_puzzles() -> void:
	completed_puzzles.clear()

## Character Questioning & Interrogation Tracking
func record_question_asked(char_id: String, question_id: String) -> void:
	if not asked_dialogue_questions.has(char_id):
		asked_dialogue_questions[char_id] = {}
	asked_dialogue_questions[char_id][question_id] = true
	question_asked.emit(char_id, question_id)

func is_question_asked(char_id: String, question_id: String) -> bool:
	if asked_dialogue_questions.has(char_id):
		return asked_dialogue_questions[char_id].get(question_id, false)
	return false

func record_info_revealed(info_key: String) -> void:
	if not info_key.is_empty():
		revealed_dialogue_info[info_key] = true
		information_revealed.emit(info_key)

func is_info_revealed(info_key: String) -> bool:
	return revealed_dialogue_info.get(info_key, false)

func record_evidence_presented(char_id: String, clue_id: String, is_contradiction: bool) -> void:
	evidence_presented.emit(char_id, clue_id, is_contradiction)

func clear_questioning_state() -> void:
	asked_dialogue_questions.clear()
	revealed_dialogue_info.clear()

func reset_game() -> void:
	clear_clues()
	clear_puzzles()
	clear_deductions()
	clear_questioning_state()
	current_location_id = "downtown"

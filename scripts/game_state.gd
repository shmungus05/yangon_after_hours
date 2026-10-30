extends Node

## Autoload singleton managing game state, language, current location, scene paths, clues, and puzzle progression.

const Localization = preload("res://scripts/localization.gd")

signal language_changed(lang: String)
signal clue_added(clue_id: String, clue_description: String)
signal clue_discovered(clue: Dictionary)
signal puzzle_solved(puzzle_id: String)

var current_language: String = "my" # Defaults to Myanmar as requested
var current_location_id: String = "downtown"
var discovered_clues: Array[Dictionary] = []
var completed_puzzles: Dictionary = {}

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
		"timestamp": clue.get("timestamp", "11:45 PM")
	}

func get_clue_count() -> int:
	return discovered_clues.size()

func clear_clues() -> void:
	discovered_clues.clear()

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

func reset_game() -> void:
	clear_clues()
	clear_puzzles()
	current_location_id = "downtown"

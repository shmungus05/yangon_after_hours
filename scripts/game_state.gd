extends Node

## Autoload singleton managing game state, current location, scene paths, clues, and puzzle progression.

signal clue_discovered(clue: Dictionary)
signal puzzle_solved(puzzle_id: String)

var current_location_id: String = "downtown"
var discovered_clues: Array[Dictionary] = []
var completed_puzzles: Dictionary = {}

const LOCATIONS: Dictionary = {
	"downtown": {
		"title": "Downtown (Sule)",
		"subtitle": "Colonial Heritage & Neon Alleyways",
		"description": "Rain-slicked cobblestones reflect golden pagoda spires and glowing vintage shop signs. Cool night breezes rustle through the colonial balconies as late-night taxis hum past Sule Pagoda.",
		"scene_path": "res://scenes/locations/downtown.tscn",
		"color": Color(0.12, 0.16, 0.24, 1.0),
		"accent": Color(0.96, 0.76, 0.35, 1.0)
	},
	"tea_shop": {
		"title": "Lucky Tea Shop",
		"subtitle": "Corner of 38th Street",
		"description": "Low plastic stools line the sidewalk under warm incandescent bulbs. The sweet aroma of steamed black tea, condensed milk, and fresh samosas fills the humid night air as patrons discuss the evening news.",
		"scene_path": "res://scenes/locations/tea_shop.tscn",
		"color": Color(0.22, 0.15, 0.10, 1.0),
		"accent": Color(0.92, 0.58, 0.28, 1.0)
	},
	"market": {
		"title": "Night Market",
		"subtitle": "Strand Road Waterfront",
		"description": "A vibrant labyrinth of stalls beneath striped tarps and string lights along the riverbank. Sizzling charcoal grills, fresh tropical fruits, and bustling vendor shouts echo in the humid night breeze.",
		"scene_path": "res://scenes/locations/market.tscn",
		"color": Color(0.18, 0.11, 0.22, 1.0),
		"accent": Color(0.85, 0.42, 0.55, 1.0)
	}
}

func get_current_location_data() -> Dictionary:
	return LOCATIONS.get(current_location_id, LOCATIONS["downtown"])

func get_location_data(loc_id: String) -> Dictionary:
	return LOCATIONS.get(loc_id, LOCATIONS["downtown"])

func go_to_location(loc_id: String) -> void:
	if LOCATIONS.has(loc_id):
		current_location_id = loc_id
		var path: String = LOCATIONS[loc_id]["scene_path"]
		get_tree().change_scene_to_file(path)

## Clue Management System (Persistent across scene changes)

func add_clue(id: String, title: String, description: String, source_location: String) -> bool:
	if id.is_empty():
		return false
	
	# Prevent duplicate clues from being recorded repeatedly
	for clue in discovered_clues:
		if clue.get("id", "") == id:
			return false
	
	var new_clue: Dictionary = {
		"id": id,
		"title": title,
		"description": description,
		"location": source_location,
		"timestamp": "11:45 PM"
	}
	discovered_clues.append(new_clue)
	clue_discovered.emit(new_clue)
	return true

func has_clue(id: String) -> bool:
	for clue in discovered_clues:
		if clue.get("id", "") == id:
			return true
	return false

func get_clues() -> Array[Dictionary]:
	return discovered_clues

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

func clear_puzzles() -> void:
	completed_puzzles.clear()

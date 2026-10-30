extends Control

const Localization = preload("res://scripts/localization.gd")

## Epilogue and Ending screen for Yangon After Hours.
## Summarizes the resolved mystery and displays player investigation statistics.

@onready var pre_title: Label = %PreTitle
@onready var title_label: Label = %TitleLabel
@onready var subtitle_label: Label = %SubtitleLabel
@onready var narrative_label: Label = %NarrativeLabel

@onready var clue_stat_label: Label = %ClueStatLabel
@onready var puzzle_stat_label: Label = %PuzzleStatLabel
@onready var location_stat_label: Label = %LocationStatLabel

@onready var ending_lang_button: Button = %EndingLangButton
@onready var restart_button: Button = %RestartButton
@onready var free_roam_button: Button = %FreeRoamButton

func _ready() -> void:
	if ending_lang_button:
		ending_lang_button.pressed.connect(_on_lang_pressed)
	if restart_button:
		restart_button.pressed.connect(_on_restart_pressed)
		restart_button.grab_focus()
	if free_roam_button:
		free_roam_button.pressed.connect(_on_free_roam_pressed)
	
	var game_state = get_node_or_null("/root/GameState")
	if game_state:
		game_state.language_changed.connect(_on_language_changed)
	
	_update_localized_ui()

func _update_localized_ui() -> void:
	var game_state = get_node_or_null("/root/GameState")
	var lang: String = game_state.get_language() if game_state else "my"
	var e_data: Dictionary = Localization.get_ending_data(lang)
	
	if pre_title:
		pre_title.text = e_data.get("pretitle", "")
	if title_label:
		title_label.text = e_data.get("title", "")
	if subtitle_label:
		subtitle_label.text = e_data.get("subtitle", "")
	if narrative_label:
		narrative_label.text = e_data.get("narrative", "")
	
	if ending_lang_button:
		ending_lang_button.text = "မြန်မာ" if lang == "my" else "English"
	if restart_button:
		restart_button.text = e_data.get("restart_btn", "↺ Play Again")
	if free_roam_button:
		free_roam_button.text = e_data.get("freeroam_btn", "🗺️ Return to City Map")
	
	var clue_count: int = game_state.get_clue_count() if game_state else 0
	var puzzle_count: int = game_state.get_solved_puzzle_count() if game_state else 0
	
	if clue_stat_label:
		var clue_fmt: String = e_data.get("clues_stat", "Clues: %d / 7")
		clue_stat_label.text = clue_fmt % clue_count
	if puzzle_stat_label:
		var puzzle_fmt: String = e_data.get("puzzles_stat", "Puzzles: %d / 3")
		puzzle_stat_label.text = puzzle_fmt % puzzle_count
	if location_stat_label:
		location_stat_label.text = e_data.get("locations_stat", "Locations: 3 / 3")

func _on_lang_pressed() -> void:
	var game_state = get_node_or_null("/root/GameState")
	if game_state:
		game_state.toggle_language()

func _on_language_changed(_lang: String) -> void:
	_update_localized_ui()

func _on_restart_pressed() -> void:
	var game_state = get_node_or_null("/root/GameState")
	if game_state:
		game_state.reset_game()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_free_roam_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/city_map.tscn")

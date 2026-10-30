class_name MarketPuzzlePanel
extends Control

const Localization = preload("res://scripts/localization.gd")

## Market Notebook Puzzle controller for Yangon After Hours.
## Players deduce the combination to unlock Ko Lin's missing recipe and delivery ledger.

signal puzzle_completed
signal puzzle_closed

const PUZZLE_ID: String = "market_notebook_puzzle"

const CORRECT_EMBLEM_CHOICE: int = 1  # Royal Burmese Peacock Seal
const CORRECT_STASH_CHOICE: int = 1   # Pier 4 Riverboat Cargo Stash
const CORRECT_SPICE_CHOICE: int = 1   # Shan Star Anise & Dried Chili

@onready var backdrop: Control = %Backdrop
@onready var title_label: Label = %TitleLabel
@onready var subtitle_label: Label = %SubtitleLabel
@onready var status_badge: Label = %StatusBadge
@onready var top_close_button: Button = %TopCloseButton

@onready var emblem_name: Label = %EmblemName
@onready var emblem_hint: Label = %EmblemHint
@onready var emblem_prompt: Label = %EmblemPrompt
@onready var emblem_option: OptionButton = %EmblemOption

@onready var stash_name: Label = %StashName
@onready var stash_hint: Label = %StashHint
@onready var stash_prompt: Label = %StashPrompt
@onready var stash_option: OptionButton = %StashOption

@onready var spice_name: Label = %SpiceName
@onready var spice_hint: Label = %SpiceHint
@onready var spice_prompt: Label = %SpicePrompt
@onready var spice_option: OptionButton = %SpiceOption

@onready var feedback_label: Label = %FeedbackLabel
@onready var unlock_button: Button = %UnlockButton
@onready var close_button: Button = %CloseButton

func _ready() -> void:
	visible = false
	var game_state = get_node_or_null("/root/GameState")
	if game_state:
		game_state.language_changed.connect(_on_language_changed)
	
	_populate_options()
	_connect_signals()

func _on_language_changed(_lang: String) -> void:
	if visible:
		_populate_options()
		_update_state()

func _populate_options() -> void:
	var lang: String = "my"
	var game_state = get_node_or_null("/root/GameState")
	if game_state:
		lang = game_state.get_language()
	
	var p_data: Dictionary = Localization.get_market_puzzle_data(lang)
	var emblems: Array = p_data.get("emblem_choices", [])
	var stashes: Array = p_data.get("stash_choices", [])
	var spices: Array = p_data.get("spice_choices", [])
	
	if emblem_option:
		var prev = emblem_option.selected
		emblem_option.clear()
		for choice in emblems:
			emblem_option.add_item(str(choice))
		if prev >= 0 and prev < emblems.size():
			emblem_option.selected = prev
	
	if stash_option:
		var prev = stash_option.selected
		stash_option.clear()
		for choice in stashes:
			stash_option.add_item(str(choice))
		if prev >= 0 and prev < stashes.size():
			stash_option.selected = prev
	
	if spice_option:
		var prev = spice_option.selected
		spice_option.clear()
		for choice in spices:
			spice_option.add_item(str(choice))
		if prev >= 0 and prev < spices.size():
			spice_option.selected = prev

func _connect_signals() -> void:
	if unlock_button and not unlock_button.pressed.is_connected(_on_unlock_pressed):
		unlock_button.pressed.connect(_on_unlock_pressed)
	if close_button and not close_button.pressed.is_connected(close_puzzle):
		close_button.pressed.connect(close_puzzle)
	if top_close_button and not top_close_button.pressed.is_connected(close_puzzle):
		top_close_button.pressed.connect(close_puzzle)
	if backdrop and not backdrop.gui_input.is_connected(_on_backdrop_input):
		backdrop.gui_input.connect(_on_backdrop_input)

func _unhandled_input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("ui_cancel"):
		close_puzzle()
		get_viewport().set_input_as_handled()

func open_puzzle() -> void:
	visible = true
	_populate_options()
	_update_state()
	if unlock_button and unlock_button.is_inside_tree() and not unlock_button.disabled:
		unlock_button.grab_focus()

func close_puzzle() -> void:
	visible = false
	puzzle_closed.emit()

func _update_state() -> void:
	var game_state = get_node_or_null("/root/GameState")
	var lang: String = game_state.get_language() if game_state else "my"
	var p_data: Dictionary = Localization.get_market_puzzle_data(lang)
	var is_solved: bool = game_state.is_puzzle_solved(PUZZLE_ID) if game_state else false
	
	if title_label:
		title_label.text = p_data.get("title", "")
	if subtitle_label:
		subtitle_label.text = p_data.get("subtitle", "")
	if top_close_button:
		top_close_button.text = p_data.get("btn_close", "✕ Close")
	if close_button:
		close_button.text = p_data.get("btn_cancel", "Cancel")
	
	var dials: Dictionary = p_data.get("dials", {})
	if dials.has("emblem"):
		if emblem_name: emblem_name.text = dials["emblem"].get("name", "")
		if emblem_hint: emblem_hint.text = dials["emblem"].get("hint", "")
		if emblem_prompt: emblem_prompt.text = dials["emblem"].get("prompt", "")
	if dials.has("stash"):
		if stash_name: stash_name.text = dials["stash"].get("name", "")
		if stash_hint: stash_hint.text = dials["stash"].get("hint", "")
		if stash_prompt: stash_prompt.text = dials["stash"].get("prompt", "")
	if dials.has("spice"):
		if spice_name: spice_name.text = dials["spice"].get("name", "")
		if spice_hint: spice_hint.text = dials["spice"].get("hint", "")
		if spice_prompt: spice_prompt.text = dials["spice"].get("prompt", "")
	
	if is_solved:
		emblem_option.selected = CORRECT_EMBLEM_CHOICE
		stash_option.selected = CORRECT_STASH_CHOICE
		spice_option.selected = CORRECT_SPICE_CHOICE
		
		emblem_option.disabled = true
		stash_option.disabled = true
		spice_option.disabled = true
		
		unlock_button.disabled = true
		unlock_button.text = p_data.get("btn_unlocked", "Chest Unlocked ✔")
		
		status_badge.text = p_data.get("status_unlocked", "STATUS: UNLOCKED ✔")
		status_badge.add_theme_color_override("font_color", Color(0.4, 0.9, 0.5, 1.0))
		
		feedback_label.text = p_data.get("feedback_solved", "")
		feedback_label.add_theme_color_override("font_color", Color(0.4, 0.9, 0.5, 1.0))
	else:
		emblem_option.disabled = false
		stash_option.disabled = false
		spice_option.disabled = false
		
		unlock_button.disabled = false
		unlock_button.text = p_data.get("btn_unlock", "Unlock Spice Chest 🔓")
		
		status_badge.text = p_data.get("status_locked", "STATUS: LOCKED 🔒")
		status_badge.add_theme_color_override("font_color", Color(0.988235, 0.827451, 0.301961, 1.0))
		
		feedback_label.text = p_data.get("feedback_init", "")
		feedback_label.add_theme_color_override("font_color", Color(0.85, 0.88, 0.92, 1.0))

func _on_unlock_pressed() -> void:
	var game_state = get_node_or_null("/root/GameState")
	var lang: String = game_state.get_language() if game_state else "my"
	var p_data: Dictionary = Localization.get_market_puzzle_data(lang)
	
	var emblem_idx: int = emblem_option.selected
	var stash_idx: int = stash_option.selected
	var spice_idx: int = spice_option.selected
	
	if emblem_idx <= 0 or stash_idx <= 0 or spice_idx <= 0:
		feedback_label.text = p_data.get("feedback_incomplete", "⚠️ Set all three dials!")
		feedback_label.add_theme_color_override("font_color", Color(0.98, 0.75, 0.35, 1.0))
		return
	
	var emblem_ok: bool = (emblem_idx == CORRECT_EMBLEM_CHOICE)
	var stash_ok: bool = (stash_idx == CORRECT_STASH_CHOICE)
	var spice_ok: bool = (spice_idx == CORRECT_SPICE_CHOICE)
	
	if emblem_ok and stash_ok and spice_ok:
		_on_puzzle_solved()
	else:
		_on_puzzle_wrong(emblem_ok, stash_ok, spice_ok)

func _on_puzzle_solved() -> void:
	var game_state = get_node_or_null("/root/GameState")
	var lang: String = game_state.get_language() if game_state else "my"
	var p_data: Dictionary = Localization.get_market_puzzle_data(lang)
	var clue_info: Dictionary = Localization.get_clue_data("vendor_delivery_ledger", lang)
	var loc_info: Dictionary = game_state.get_location_data("market") if game_state else {}
	
	if game_state:
		game_state.mark_puzzle_solved(PUZZLE_ID)
		game_state.add_clue(
			"vendor_delivery_ledger",
			clue_info.get("title", "Vendor's Midnight Delivery Ledger"),
			clue_info.get("desc", ""),
			loc_info.get("title", "Night Market")
		)
	
	_update_state()
	feedback_label.text = p_data.get("feedback_solved", "")
	feedback_label.add_theme_color_override("font_color", Color(0.4, 0.9, 0.5, 1.0))
	puzzle_completed.emit()

func _on_puzzle_wrong(emblem_ok: bool, stash_ok: bool, spice_ok: bool) -> void:
	var game_state = get_node_or_null("/root/GameState")
	var lang: String = game_state.get_language() if game_state else "my"
	var p_data: Dictionary = Localization.get_market_puzzle_data(lang)
	
	var correct_count: int = (1 if emblem_ok else 0) + (1 if stash_ok else 0) + (1 if spice_ok else 0)
	var hint_text: String = ""
	
	if correct_count == 0:
		hint_text = p_data.get("feedback_0", "❌ None match!")
	elif correct_count == 1:
		hint_text = p_data.get("feedback_1", "❌ 1 of 3 correct!")
	else:
		hint_text = p_data.get("feedback_2", "❌ 2 of 3 correct!")
	
	feedback_label.text = hint_text
	feedback_label.add_theme_color_override("font_color", Color(0.95, 0.45, 0.45, 1.0))

func _on_backdrop_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		close_puzzle()
	elif event is InputEventScreenTouch and event.pressed:
		close_puzzle()

class_name TeaPuzzlePanel
extends Control

const Localization = preload("res://scripts/localization.gd")

## Tea Shop order matching puzzle controller for Yangon After Hours.
## Players deduce the correct Burmese tea order for three customers based on dialogue clues.

signal puzzle_completed
signal puzzle_closed

const PUZZLE_ID: String = "tea_order_puzzle"

const CORRECT_MIN_CHOICE: int = 2   # Cho-pyit (Sweet & Strong)
const CORRECT_THIDA_CHOICE: int = 1 # Cho-seint (Sweet & Rich)
const CORRECT_AUNG_CHOICE: int = 3  # Pawt-seint (Mild & Creamy)

@onready var backdrop: Control = %Backdrop
@onready var title_label: Label = %TitleLabel
@onready var subtitle_label: Label = %SubtitleLabel
@onready var status_badge: Label = %StatusBadge
@onready var top_close_button: Button = %TopCloseButton

@onready var min_name: Label = %MinName
@onready var min_hint: Label = %MinHint
@onready var min_option: OptionButton = %MinOption

@onready var thida_name: Label = %ThidaName
@onready var thida_hint: Label = %ThidaHint
@onready var thida_option: OptionButton = %ThidaOption

@onready var aung_name: Label = %AungName
@onready var aung_hint: Label = %AungHint
@onready var aung_option: OptionButton = %AungOption

@onready var feedback_label: Label = %FeedbackLabel
@onready var serve_button: Button = %ServeButton
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
	
	var p_data: Dictionary = Localization.get_tea_puzzle_data(lang)
	var choices: Array = p_data.get("tea_choices", [])
	
	for opt in [min_option, thida_option, aung_option]:
		if opt:
			var prev_selected = opt.selected
			opt.clear()
			for choice in choices:
				opt.add_item(str(choice))
			if prev_selected >= 0 and prev_selected < choices.size():
				opt.selected = prev_selected

func _connect_signals() -> void:
	if serve_button and not serve_button.pressed.is_connected(_on_serve_pressed):
		serve_button.pressed.connect(_on_serve_pressed)
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
	if serve_button and serve_button.is_inside_tree() and not serve_button.disabled:
		serve_button.grab_focus()

func close_puzzle() -> void:
	visible = false
	puzzle_closed.emit()

func _update_state() -> void:
	var game_state = get_node_or_null("/root/GameState")
	var lang: String = game_state.get_language() if game_state else "my"
	var p_data: Dictionary = Localization.get_tea_puzzle_data(lang)
	var is_solved: bool = game_state.is_puzzle_solved(PUZZLE_ID) if game_state else false
	
	if title_label:
		title_label.text = p_data.get("title", "")
	if subtitle_label:
		subtitle_label.text = p_data.get("subtitle", "")
	if top_close_button:
		top_close_button.text = p_data.get("btn_close", "✕ Close")
	if close_button:
		close_button.text = p_data.get("btn_close", "✕ Close")
	
	var hints: Dictionary = p_data.get("customer_hints", {})
	if min_name and hints.has("min"):
		min_name.text = hints["min"].get("name", "")
	if min_hint and hints.has("min"):
		min_hint.text = hints["min"].get("hint", "")
		
	if thida_name and hints.has("thida"):
		thida_name.text = hints["thida"].get("name", "")
	if thida_hint and hints.has("thida"):
		thida_hint.text = hints["thida"].get("hint", "")
		
	if aung_name and hints.has("aung"):
		aung_name.text = hints["aung"].get("name", "")
	if aung_hint and hints.has("aung"):
		aung_hint.text = hints["aung"].get("hint", "")
	
	if is_solved:
		# Lock in correct answers and show solved status
		min_option.selected = CORRECT_MIN_CHOICE
		thida_option.selected = CORRECT_THIDA_CHOICE
		aung_option.selected = CORRECT_AUNG_CHOICE
		
		min_option.disabled = true
		thida_option.disabled = true
		aung_option.disabled = true
		
		serve_button.disabled = true
		serve_button.text = p_data.get("btn_served", "Orders Served ✔")
		
		status_badge.text = p_data.get("status_solved", "STATUS: SOLVED ✔")
		status_badge.add_theme_color_override("font_color", Color(0.4, 0.9, 0.5, 1.0))
		
		feedback_label.text = p_data.get("feedback_solved", "")
		feedback_label.add_theme_color_override("font_color", Color(0.4, 0.9, 0.5, 1.0))
	else:
		min_option.disabled = false
		thida_option.disabled = false
		aung_option.disabled = false
		
		serve_button.disabled = false
		serve_button.text = p_data.get("btn_serve", "Serve Orders ☕")
		
		status_badge.text = p_data.get("status_unsolved", "STATUS: UNSOLVED")
		status_badge.add_theme_color_override("font_color", Color(0.988235, 0.827451, 0.301961, 1.0))
		
		feedback_label.text = p_data.get("feedback_init", "")
		feedback_label.add_theme_color_override("font_color", Color(0.85, 0.88, 0.92, 1.0))

func _on_serve_pressed() -> void:
	var game_state = get_node_or_null("/root/GameState")
	var lang: String = game_state.get_language() if game_state else "my"
	var p_data: Dictionary = Localization.get_tea_puzzle_data(lang)
	
	var min_choice: int = min_option.selected
	var thida_choice: int = thida_option.selected
	var aung_choice: int = aung_option.selected
	
	# Validate that all selections were made
	if min_choice <= 0 or thida_choice <= 0 or aung_choice <= 0:
		feedback_label.text = p_data.get("feedback_incomplete", "⚠️ Incomplete orders!")
		feedback_label.add_theme_color_override("font_color", Color(0.98, 0.75, 0.35, 1.0))
		return
	
	# Check correctness
	var min_ok: bool = (min_choice == CORRECT_MIN_CHOICE)
	var thida_ok: bool = (thida_choice == CORRECT_THIDA_CHOICE)
	var aung_ok: bool = (aung_choice == CORRECT_AUNG_CHOICE)
	
	if min_ok and thida_ok and aung_ok:
		_on_puzzle_solved()
	else:
		_on_puzzle_wrong(min_ok, thida_ok, aung_ok)

func _on_puzzle_solved() -> void:
	var game_state = get_node_or_null("/root/GameState")
	var lang: String = game_state.get_language() if game_state else "my"
	var p_data: Dictionary = Localization.get_tea_puzzle_data(lang)
	var clue_info: Dictionary = Localization.get_clue_data("harbor_cargo_slip", lang)
	var loc_info: Dictionary = game_state.get_location_data("tea_shop") if game_state else {}
	
	if game_state:
		game_state.mark_puzzle_solved(PUZZLE_ID)
		game_state.add_clue(
			"harbor_cargo_slip",
			clue_info.get("title", "Stained Harbor Cargo Slip"),
			clue_info.get("desc", ""),
			loc_info.get("title", "Lucky Tea Shop")
		)
	
	_update_state()
	feedback_label.text = p_data.get("feedback_solved", "")
	feedback_label.add_theme_color_override("font_color", Color(0.4, 0.9, 0.5, 1.0))
	puzzle_completed.emit()

func _on_puzzle_wrong(min_ok: bool, thida_ok: bool, aung_ok: bool) -> void:
	var game_state = get_node_or_null("/root/GameState")
	var lang: String = game_state.get_language() if game_state else "my"
	var p_data: Dictionary = Localization.get_tea_puzzle_data(lang)
	
	var correct_count: int = (1 if min_ok else 0) + (1 if thida_ok else 0) + (1 if aung_ok else 0)
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

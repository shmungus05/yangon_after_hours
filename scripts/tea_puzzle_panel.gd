class_name TeaPuzzlePanel
extends Control

## Tea Shop order matching puzzle controller for Yangon After Hours.
## Players deduce the correct Burmese tea order for three customers based on dialogue clues.

signal puzzle_completed
signal puzzle_closed

const PUZZLE_ID: String = "tea_order_puzzle"

const TEA_CHOICES: Array[String] = [
	"-- Select a Tea Order --",
	"Cho-seint (Sweet & Rich)",
	"Cho-pyit (Sweet & Strong)",
	"Pawt-seint (Mild & Creamy)"
]

const CORRECT_MIN_CHOICE: int = 2   # Cho-pyit (Sweet & Strong)
const CORRECT_THIDA_CHOICE: int = 1 # Cho-seint (Sweet & Rich)
const CORRECT_AUNG_CHOICE: int = 3  # Pawt-seint (Mild & Creamy)

@onready var backdrop: Control = %Backdrop
@onready var min_option: OptionButton = %MinOption
@onready var thida_option: OptionButton = %ThidaOption
@onready var aung_option: OptionButton = %AungOption
@onready var serve_button: Button = %ServeButton
@onready var close_button: Button = %CloseButton
@onready var top_close_button: Button = %TopCloseButton
@onready var feedback_label: Label = %FeedbackLabel
@onready var status_badge: Label = %StatusBadge

func _ready() -> void:
	visible = false
	_populate_options()
	_connect_signals()

func _populate_options() -> void:
	for opt in [min_option, thida_option, aung_option]:
		if opt:
			opt.clear()
			for choice in TEA_CHOICES:
				opt.add_item(choice)

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
	_update_state()
	if serve_button and serve_button.is_inside_tree() and not serve_button.disabled:
		serve_button.grab_focus()

func close_puzzle() -> void:
	visible = false
	puzzle_closed.emit()

func _update_state() -> void:
	var game_state = get_node_or_null("/root/GameState")
	var is_solved: bool = game_state.is_puzzle_solved(PUZZLE_ID) if game_state else false
	
	if is_solved:
		# Lock in correct answers and show solved status
		min_option.selected = CORRECT_MIN_CHOICE
		thida_option.selected = CORRECT_THIDA_CHOICE
		aung_option.selected = CORRECT_AUNG_CHOICE
		
		min_option.disabled = true
		thida_option.disabled = true
		aung_option.disabled = true
		
		serve_button.disabled = true
		serve_button.text = "Orders Served ✔"
		
		status_badge.text = "STATUS: SOLVED ✔"
		status_badge.add_theme_color_override("font_color", Color(0.4, 0.9, 0.5, 1.0))
		
		feedback_label.text = "All customers received their favorite tea orders! The harbor cargo slip has been recorded in your notebook."
		feedback_label.add_theme_color_override("font_color", Color(0.4, 0.9, 0.5, 1.0))
	else:
		min_option.disabled = false
		thida_option.disabled = false
		aung_option.disabled = false
		
		serve_button.disabled = false
		serve_button.text = "Serve Orders ☕"
		
		status_badge.text = "STATUS: UNSOLVED"
		status_badge.add_theme_color_override("font_color", Color(0.988235, 0.827451, 0.301961, 1.0))
		
		feedback_label.text = "Examine customer dialogues for clues on sweetness and strength, select their requested tea brews, and press Serve Orders."
		feedback_label.add_theme_color_override("font_color", Color(0.85, 0.88, 0.92, 1.0))

func _on_serve_pressed() -> void:
	var min_choice: int = min_option.selected
	var thida_choice: int = thida_option.selected
	var aung_choice: int = aung_option.selected
	
	# Validate that all selections were made
	if min_choice <= 0 or thida_choice <= 0 or aung_choice <= 0:
		feedback_label.text = "⚠️ You haven't chosen a tea order for all three customers yet! Select an order for each person before serving."
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
	if game_state:
		game_state.mark_puzzle_solved(PUZZLE_ID)
		game_state.add_clue(
			"harbor_cargo_slip",
			"Stained Harbor Cargo Slip",
			"A rain-soaked delivery receipt dropped at the tea shop: 'Pier 4 - Midnight Unloading - Container #7'.",
			"Lucky Tea Shop"
		)
	
	_update_state()
	feedback_label.text = "🎉 Spot on! Every customer is happily sipping their favorite brew!\nTea Master Ko Zaw nods in approval and hands you a dropped harbor cargo slip!"
	feedback_label.add_theme_color_override("font_color", Color(0.4, 0.9, 0.5, 1.0))
	puzzle_completed.emit()

func _on_puzzle_wrong(min_ok: bool, thida_ok: bool, aung_ok: bool) -> void:
	var correct_count: int = (1 if min_ok else 0) + (1 if thida_ok else 0) + (1 if aung_ok else 0)
	var hint_text: String = ""
	
	if correct_count == 0:
		hint_text = "❌ None of the tea cups match what the customers asked for!\nHint: Check who needs strong caffeine to stay awake, who wants classic sweetness, and who asked for low sugar."
	elif correct_count == 1:
		hint_text = "❌ Only 1 of the 3 orders is correct! Some customers are shaking their heads.\nHint: Saya Min needs heavy caffeine (Cho-pyit), while Ko Aung wants low sugar (Pawt-seint)."
	else:
		hint_text = "❌ So close! 2 of the 3 orders are correct, but 1 customer got the wrong cup.\nDouble-check the difference between Cho-seint (Sweet & Rich) and Cho-pyit (Sweet & Strong)."
	
	feedback_label.text = hint_text
	feedback_label.add_theme_color_override("font_color", Color(0.95, 0.45, 0.45, 1.0))

func _on_backdrop_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		close_puzzle()
	elif event is InputEventScreenTouch and event.pressed:
		close_puzzle()

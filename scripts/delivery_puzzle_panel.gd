class_name DeliveryPuzzlePanel
extends Control

const Localization = preload("res://scripts/localization.gd")

## Final Delivery Puzzle controller for Yangon After Hours.
## Connects clues gathered from Tea Shop and Market to complete the midnight cargo delivery.

signal puzzle_completed
signal puzzle_closed
signal proceed_to_ending

const PUZZLE_ID: String = "final_delivery_puzzle"

const CORRECT_SEAL_CHOICE: int = 1       # Hintha Bird Royal Seal
const CORRECT_PASSCODE_CHOICE: int = 2   # Passcode: 1886
const CORRECT_RECIPIENT_CHOICE: int = 1  # Night Watchman U Ba

@onready var backdrop: Control = %Backdrop
@onready var title_label: Label = %TitleLabel
@onready var subtitle_label: Label = %SubtitleLabel
@onready var status_badge: Label = %StatusBadge
@onready var top_close_button: Button = %TopCloseButton

@onready var seal_name: Label = %SealName
@onready var seal_hint: Label = %SealHint
@onready var seal_prompt: Label = %SealPrompt
@onready var seal_option: OptionButton = %SealOption

@onready var passcode_name: Label = %PasscodeName
@onready var passcode_hint: Label = %PasscodeHint
@onready var passcode_prompt: Label = %PasscodePrompt
@onready var passcode_option: OptionButton = %PasscodeOption

@onready var recipient_name: Label = %RecipientName
@onready var recipient_hint: Label = %RecipientHint
@onready var recipient_prompt: Label = %RecipientPrompt
@onready var recipient_option: OptionButton = %RecipientOption

@onready var feedback_label: Label = %FeedbackLabel
@onready var deliver_button: Button = %DeliverButton
@onready var ending_button: Button = %EndingButton
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
	
	var p_data: Dictionary = Localization.get_delivery_puzzle_data(lang)
	var seals: Array = p_data.get("seal_choices", [])
	var passcodes: Array = p_data.get("passcode_choices", [])
	var recipients: Array = p_data.get("recipient_choices", [])
	
	if seal_option:
		var prev = seal_option.selected
		seal_option.clear()
		for choice in seals:
			seal_option.add_item(str(choice))
		if prev >= 0 and prev < seals.size():
			seal_option.selected = prev
	
	if passcode_option:
		var prev = passcode_option.selected
		passcode_option.clear()
		for choice in passcodes:
			passcode_option.add_item(str(choice))
		if prev >= 0 and prev < passcodes.size():
			passcode_option.selected = prev
	
	if recipient_option:
		var prev = recipient_option.selected
		recipient_option.clear()
		for choice in recipients:
			recipient_option.add_item(str(choice))
		if prev >= 0 and prev < recipients.size():
			recipient_option.selected = prev

func _connect_signals() -> void:
	if deliver_button and not deliver_button.pressed.is_connected(_on_deliver_pressed):
		deliver_button.pressed.connect(_on_deliver_pressed)
	if ending_button and not ending_button.pressed.is_connected(_on_ending_pressed):
		ending_button.pressed.connect(_on_ending_pressed)
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
	if deliver_button and deliver_button.is_inside_tree() and not deliver_button.disabled:
		deliver_button.grab_focus()

func close_puzzle() -> void:
	visible = false
	puzzle_closed.emit()

func _update_state() -> void:
	var game_state = get_node_or_null("/root/GameState")
	var lang: String = game_state.get_language() if game_state else "my"
	var p_data: Dictionary = Localization.get_delivery_puzzle_data(lang)
	var is_solved: bool = game_state.is_puzzle_solved(PUZZLE_ID) if game_state else false
	
	if title_label:
		title_label.text = p_data.get("title", "")
	if subtitle_label:
		subtitle_label.text = p_data.get("subtitle", "")
	if top_close_button:
		top_close_button.text = p_data.get("btn_close", "✕ Close")
	if close_button:
		close_button.text = p_data.get("btn_cancel", "Cancel")
	
	var fields: Dictionary = p_data.get("fields", {})
	if fields.has("seal"):
		if seal_name: seal_name.text = fields["seal"].get("name", "")
		if seal_hint: seal_hint.text = fields["seal"].get("hint", "")
		if seal_prompt: seal_prompt.text = fields["seal"].get("prompt", "")
	if fields.has("passcode"):
		if passcode_name: passcode_name.text = fields["passcode"].get("name", "")
		if passcode_hint: passcode_hint.text = fields["passcode"].get("hint", "")
		if passcode_prompt: passcode_prompt.text = fields["passcode"].get("prompt", "")
	if fields.has("recipient"):
		if recipient_name: recipient_name.text = fields["recipient"].get("name", "")
		if recipient_hint: recipient_hint.text = fields["recipient"].get("hint", "")
		if recipient_prompt: recipient_prompt.text = fields["recipient"].get("prompt", "")
	
	if is_solved:
		seal_option.selected = CORRECT_SEAL_CHOICE
		passcode_option.selected = CORRECT_PASSCODE_CHOICE
		recipient_option.selected = CORRECT_RECIPIENT_CHOICE
		
		seal_option.disabled = true
		passcode_option.disabled = true
		recipient_option.disabled = true
		
		deliver_button.disabled = true
		deliver_button.visible = false
		
		if ending_button:
			ending_button.visible = true
			ending_button.text = p_data.get("btn_ending", "View Mystery Resolution 🏆")
			ending_button.grab_focus()
		
		status_badge.text = p_data.get("status_delivered", "STATUS: DELIVERED ✔")
		status_badge.add_theme_color_override("font_color", Color(0.4, 0.9, 0.5, 1.0))
		
		feedback_label.text = p_data.get("feedback_solved_summary", "")
		feedback_label.add_theme_color_override("font_color", Color(0.4, 0.9, 0.5, 1.0))
	else:
		seal_option.disabled = false
		passcode_option.disabled = false
		recipient_option.disabled = false
		
		deliver_button.disabled = false
		deliver_button.visible = true
		deliver_button.text = p_data.get("btn_deliver", "Verify & Complete Delivery 📦")
		
		if ending_button:
			ending_button.visible = false
		
		status_badge.text = p_data.get("status_pending", "STATUS: PENDING 🔒")
		status_badge.add_theme_color_override("font_color", Color(0.988235, 0.827451, 0.301961, 1.0))
		
		feedback_label.text = p_data.get("feedback_init", "")
		feedback_label.add_theme_color_override("font_color", Color(0.85, 0.88, 0.92, 1.0))

func _on_deliver_pressed() -> void:
	var game_state = get_node_or_null("/root/GameState")
	var lang: String = game_state.get_language() if game_state else "my"
	var p_data: Dictionary = Localization.get_delivery_puzzle_data(lang)
	
	var seal_idx: int = seal_option.selected
	var passcode_idx: int = passcode_option.selected
	var recipient_idx: int = recipient_option.selected
	
	if seal_idx <= 0 or passcode_idx <= 0 or recipient_idx <= 0:
		feedback_label.text = p_data.get("feedback_incomplete", "⚠️ Complete all three fields!")
		feedback_label.add_theme_color_override("font_color", Color(0.98, 0.75, 0.35, 1.0))
		return
	
	var seal_ok: bool = (seal_idx == CORRECT_SEAL_CHOICE)
	var passcode_ok: bool = (passcode_idx == CORRECT_PASSCODE_CHOICE)
	var recipient_ok: bool = (recipient_idx == CORRECT_RECIPIENT_CHOICE)
	
	if seal_ok and passcode_ok and recipient_ok:
		_on_puzzle_solved()
	else:
		_on_puzzle_wrong(seal_ok, passcode_ok, recipient_ok)

func _on_puzzle_solved() -> void:
	var game_state = get_node_or_null("/root/GameState")
	var lang: String = game_state.get_language() if game_state else "my"
	var p_data: Dictionary = Localization.get_delivery_puzzle_data(lang)
	var clue_info: Dictionary = Localization.get_clue_data("heritage_vault_secured", lang)
	var loc_info: Dictionary = game_state.get_location_data("downtown") if game_state else {}
	
	if game_state:
		game_state.mark_puzzle_solved(PUZZLE_ID)
		game_state.add_clue(
			"heritage_vault_secured",
			clue_info.get("title", "Heritage Vault Secured & Relics Restored"),
			clue_info.get("desc", ""),
			loc_info.get("title", "Downtown (Sule)")
		)
	
	_update_state()
	feedback_label.text = p_data.get("feedback_solved", "")
	feedback_label.add_theme_color_override("font_color", Color(0.4, 0.9, 0.5, 1.0))
	puzzle_completed.emit()

func _on_puzzle_wrong(seal_ok: bool, passcode_ok: bool, recipient_ok: bool) -> void:
	var game_state = get_node_or_null("/root/GameState")
	var lang: String = game_state.get_language() if game_state else "my"
	var p_data: Dictionary = Localization.get_delivery_puzzle_data(lang)
	
	var correct_count: int = (1 if seal_ok else 0) + (1 if passcode_ok else 0) + (1 if recipient_ok else 0)
	var hint_text: String = ""
	
	if correct_count == 0:
		hint_text = p_data.get("feedback_0", "❌ None match!")
	elif correct_count == 1:
		hint_text = p_data.get("feedback_1", "❌ 1 of 3 correct!")
	else:
		hint_text = p_data.get("feedback_2", "❌ 2 of 3 correct!")
	
	feedback_label.text = hint_text
	feedback_label.add_theme_color_override("font_color", Color(0.95, 0.45, 0.45, 1.0))

func _on_ending_pressed() -> void:
	proceed_to_ending.emit()
	get_tree().change_scene_to_file("res://scenes/game_ending.tscn")

func _on_backdrop_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		close_puzzle()
	elif event is InputEventScreenTouch and event.pressed:
		close_puzzle()

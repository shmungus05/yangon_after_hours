class_name NotebookPanel
extends Control

const Localization = preload("res://scripts/localization.gd")

## Reusable investigator's notebook & interactive deduction board for Yangon After Hours.
## Displays collected clues, allows selecting and connecting clues to form deductions,
## and persists all discoveries across locations.

signal notebook_opened
signal notebook_closed
signal deduction_made(deduction_id: String)
signal tab_switched(tab_name: String)

@onready var backdrop: Control = %Backdrop
@onready var title_label: Label = %TitleLabel
@onready var subtitle_label: Label = %SubtitleLabel
@onready var top_close_button: Button = %TopCloseButton
@onready var close_button: Button = %CloseButton

# Tabs
@onready var tab_bar: HBoxContainer = %TabBar
@onready var clues_tab_btn: Button = %CluesTabButton
@onready var deductions_tab_btn: Button = %DeductionsTabButton

# Content Views
@onready var clues_view: VBoxContainer = %CluesView
@onready var clues_scroll: ScrollContainer = %CluesScroll
@onready var clues_list: VBoxContainer = %CluesList
@onready var empty_state_label: Label = %EmptyStateLabel

@onready var deductions_view: VBoxContainer = %DeductionsView
@onready var deductions_scroll: ScrollContainer = %DeductionsScroll
@onready var deductions_list: VBoxContainer = %DeductionsList
@onready var deductions_empty_label: Label = %DeductionsEmptyStateLabel

# Workbench
@onready var workbench_panel: PanelContainer = %WorkbenchPanel
@onready var workbench_title_label: Label = %WorkbenchTitleLabel
@onready var workbench_hint_label: Label = %WorkbenchHintLabel
@onready var clear_button: Button = %ClearButton
@onready var slot1_button: Button = %Slot1Button
@onready var plus_label: Label = %PlusLabel
@onready var slot2_button: Button = %Slot2Button
@onready var deduce_button: Button = %DeduceButton
@onready var feedback_label: Label = %FeedbackLabel

# Footer Counters
@onready var clue_count_label: Label = %ClueCountLabel
@onready var deduction_count_label: Label = %DeductionCountLabel

# State
var _active_tab: String = "clues"
var _selected_clue_ids: Array[String] = []
var _card_map: Dictionary = {} # clue_id -> PanelContainer

func _ready() -> void:
	visible = false
	_connect_events()

func _connect_events() -> void:
	if backdrop and not backdrop.gui_input.is_connected(_on_backdrop_input):
		backdrop.gui_input.connect(_on_backdrop_input)
	if top_close_button and not top_close_button.pressed.is_connected(close_notebook):
		top_close_button.pressed.connect(close_notebook)
	if close_button and not close_button.pressed.is_connected(close_notebook):
		close_button.pressed.connect(close_notebook)
	
	if clues_tab_btn and not clues_tab_btn.pressed.is_connected(_on_clues_tab_pressed):
		clues_tab_btn.pressed.connect(_on_clues_tab_pressed)
	if deductions_tab_btn and not deductions_tab_btn.pressed.is_connected(_on_deductions_tab_pressed):
		deductions_tab_btn.pressed.connect(_on_deductions_tab_pressed)
	
	if clear_button and not clear_button.pressed.is_connected(clear_selection):
		clear_button.pressed.connect(clear_selection)
	if slot1_button and not slot1_button.pressed.is_connected(_on_slot1_pressed):
		slot1_button.pressed.connect(_on_slot1_pressed)
	if slot2_button and not slot2_button.pressed.is_connected(_on_slot2_pressed):
		slot2_button.pressed.connect(_on_slot2_pressed)
	if deduce_button and not deduce_button.pressed.is_connected(attempt_connection):
		deduce_button.pressed.connect(attempt_connection)

func _unhandled_input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("ui_cancel"):
		close_notebook()
		get_viewport().set_input_as_handled()

## Opens the notebook and refreshes all clues and deductions
func open_notebook() -> void:
	_switch_tab(_active_tab)
	refresh_clues()
	refresh_deductions()
	_update_workbench()
	move_to_front()
	visible = true
	notebook_opened.emit()
	if close_button and close_button.is_inside_tree():
		close_button.grab_focus()

## Closes the notebook
func close_notebook() -> void:
	visible = false
	notebook_closed.emit()

func _on_clues_tab_pressed() -> void:
	_switch_tab("clues")

func _on_deductions_tab_pressed() -> void:
	_switch_tab("deductions")

func _switch_tab(tab: String) -> void:
	_active_tab = tab
	if clues_view:
		clues_view.visible = (_active_tab == "clues")
	if deductions_view:
		deductions_view.visible = (_active_tab == "deductions")
	
	_update_tab_buttons()
	tab_switched.emit(_active_tab)

func _update_tab_buttons() -> void:
	var lang: String = _get_current_language()
	var game_state = get_node_or_null("/root/GameState")
	var clue_count: int = game_state.get_clue_count() if game_state else 0
	var ded_count: int = game_state.get_deduction_count() if game_state else 0
	
	var clue_fmt: String = Localization.get_ui_text("NOTEBOOK_TAB_CLUES", lang)
	var ded_fmt: String = Localization.get_ui_text("NOTEBOOK_TAB_DEDUCTIONS", lang)
	
	if clues_tab_btn:
		clues_tab_btn.text = clue_fmt % clue_count
		_apply_tab_style(clues_tab_btn, _active_tab == "clues")
	
	if deductions_tab_btn:
		deductions_tab_btn.text = ded_fmt % ded_count
		_apply_tab_style(deductions_tab_btn, _active_tab == "deductions")

func _apply_tab_style(btn: Button, is_active: bool) -> void:
	var style = StyleBoxFlat.new()
	style.corner_radius_top_left = 6
	style.corner_radius_top_right = 6
	style.border_width_left = 1
	style.border_width_top = 1
	style.border_width_right = 1
	
	if is_active:
		style.bg_color = Color(0.18, 0.14, 0.06, 0.95)
		style.border_width_bottom = 2
		style.border_color = Color(0.988, 0.827, 0.302, 1.0)
		btn.add_theme_color_override("font_color", Color(1.0, 0.92, 0.5, 1.0))
	else:
		style.bg_color = Color(0.08, 0.10, 0.16, 0.7)
		style.border_width_bottom = 1
		style.border_color = Color(0.35, 0.42, 0.55, 0.5)
		btn.add_theme_color_override("font_color", Color(0.72, 0.76, 0.84, 1.0))
	
	btn.add_theme_stylebox_override("normal", style)
	btn.add_theme_stylebox_override("hover", style)
	btn.add_theme_stylebox_override("focus", style)

## Refreshes the list of collected clue cards
func refresh_clues() -> void:
	var lang: String = _get_current_language()
	var game_state = get_node_or_null("/root/GameState")
	
	if title_label:
		title_label.text = Localization.get_ui_text("NOTEBOOK_TITLE", lang)
	if subtitle_label:
		subtitle_label.text = Localization.get_ui_text("NOTEBOOK_SUBTITLE", lang)
	if empty_state_label:
		empty_state_label.text = Localization.get_ui_text("NOTEBOOK_EMPTY", lang)
	if top_close_button:
		top_close_button.text = Localization.get_ui_text("NOTEBOOK_CLOSE", lang)
	if close_button:
		close_button.text = Localization.get_ui_text("NOTEBOOK_CLOSE", lang)
	if clear_button:
		clear_button.text = Localization.get_ui_text("NOTEBOOK_CLEAR_BTN", lang)
	if workbench_title_label:
		workbench_title_label.text = Localization.get_ui_text("NOTEBOOK_WORKBENCH_TITLE", lang)
	if workbench_hint_label:
		workbench_hint_label.text = "— " + Localization.get_ui_text("NOTEBOOK_WORKBENCH_HINT", lang)
	if deduce_button:
		deduce_button.text = Localization.get_ui_text("NOTEBOOK_DEDUCE_BTN", lang)
	
	var clues: Array[Dictionary] = game_state.get_clues() if game_state else []
	_card_map.clear()
	
	# Clear previous cards (keeping empty_state_label)
	for child in clues_list.get_children():
		if child != empty_state_label:
			clues_list.remove_child(child)
			child.queue_free()
	
	var count_fmt: String = Localization.get_ui_text("NOTEBOOK_COUNT", lang)
	if clues.is_empty():
		empty_state_label.visible = true
		clue_count_label.text = count_fmt % 0
	else:
		empty_state_label.visible = false
		clue_count_label.text = count_fmt % clues.size()
		
		for clue in clues:
			var card: PanelContainer = _create_clue_card(clue)
			_card_map[clue.get("id", "")] = card
			clues_list.add_child(card)
	
	_update_tab_buttons()
	_update_card_highlights()

## Creates a styled interactive clue card
func _create_clue_card(clue: Dictionary) -> PanelContainer:
	var card = PanelContainer.new()
	var clue_id: String = clue.get("id", "")
	card.name = "ClueCard_%s" % clue_id
	card.custom_minimum_size = Vector2(0, 58)
	card.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	
	var margin = MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 12)
	margin.add_theme_constant_override("margin_top", 8)
	margin.add_theme_constant_override("margin_right", 12)
	margin.add_theme_constant_override("margin_bottom", 8)
	card.add_child(margin)
	
	var hbox = HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 12)
	margin.add_child(hbox)
	
	# Icon display
	var icon_lbl = Label.new()
	icon_lbl.text = clue.get("icon", "🔍")
	icon_lbl.add_theme_font_size_override("font_size", 22)
	icon_lbl.custom_minimum_size = Vector2(32, 0)
	icon_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	hbox.add_child(icon_lbl)
	
	# Main Content (Title, location, description)
	var vbox = VBoxContainer.new()
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vbox.add_theme_constant_override("separation", 2)
	hbox.add_child(vbox)
	
	var header_hbox = HBoxContainer.new()
	header_hbox.add_theme_constant_override("separation", 8)
	vbox.add_child(header_hbox)
	
	var title_lbl = Label.new()
	title_lbl.name = "TitleLabel"
	title_lbl.text = clue.get("title", "Untitled Clue")
	title_lbl.add_theme_color_override("font_color", Color(0.988235, 0.827451, 0.301961, 1.0))
	title_lbl.add_theme_font_size_override("font_size", 14)
	title_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header_hbox.add_child(title_lbl)
	
	var loc_lbl = Label.new()
	loc_lbl.text = "📍 " + clue.get("location", "Yangon")
	loc_lbl.add_theme_color_override("font_color", Color(0.49, 0.78, 0.98, 1.0))
	loc_lbl.add_theme_font_size_override("font_size", 11)
	header_hbox.add_child(loc_lbl)
	
	var desc_lbl = Label.new()
	desc_lbl.name = "DescLabel"
	desc_lbl.text = clue.get("description", "")
	desc_lbl.add_theme_color_override("font_color", Color(0.88, 0.90, 0.95, 1.0))
	desc_lbl.add_theme_font_size_override("font_size", 12)
	desc_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vbox.add_child(desc_lbl)
	
	# Selection badge
	var status_lbl = Label.new()
	status_lbl.name = "StatusLabel"
	status_lbl.text = "＋ Select"
	status_lbl.add_theme_font_size_override("font_size", 11)
	status_lbl.add_theme_color_override("font_color", Color(0.65, 0.72, 0.85, 0.8))
	status_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	hbox.add_child(status_lbl)
	
	# Interactive clicks and touches
	card.gui_input.connect(func(event: InputEvent):
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			toggle_clue_selection(clue_id)
		elif event is InputEventScreenTouch and event.pressed:
			toggle_clue_selection(clue_id)
	)
	
	# Hover effects
	card.mouse_entered.connect(func():
		if not _selected_clue_ids.has(clue_id):
			_apply_card_style(card, "hover")
	)
	card.mouse_exited.connect(func():
		if not _selected_clue_ids.has(clue_id):
			_apply_card_style(card, "normal")
	)
	
	_apply_card_style(card, "normal")
	return card

func _apply_card_style(card: PanelContainer, state: String) -> void:
	var style = StyleBoxFlat.new()
	style.corner_radius_top_left = 6
	style.corner_radius_top_right = 6
	style.corner_radius_bottom_right = 6
	style.corner_radius_bottom_left = 6
	
	var status_lbl: Label = card.get_node_or_null("MarginContainer/HBoxContainer/StatusLabel")
	
	if state == "selected":
		style.bg_color = Color(0.24, 0.18, 0.07, 0.96)
		style.border_width_left = 2
		style.border_width_top = 2
		style.border_width_right = 2
		style.border_width_bottom = 2
		style.border_color = Color(1.0, 0.88, 0.42, 1.0)
		if status_lbl:
			status_lbl.text = "✔ Selected"
			status_lbl.add_theme_color_override("font_color", Color(1.0, 0.88, 0.42, 1.0))
	elif state == "hover":
		style.bg_color = Color(0.12, 0.15, 0.22, 0.95)
		style.border_width_left = 1
		style.border_width_top = 1
		style.border_width_right = 1
		style.border_width_bottom = 1
		style.border_color = Color(0.988, 0.85, 0.42, 0.8)
		if status_lbl:
			status_lbl.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0, 1.0))
	else:
		style.bg_color = Color(0.07, 0.09, 0.14, 0.9)
		style.border_width_left = 1
		style.border_width_top = 1
		style.border_width_right = 1
		style.border_width_bottom = 1
		style.border_color = Color(0.88, 0.72, 0.32, 0.45)
		if status_lbl:
			status_lbl.text = "＋ Select"
			status_lbl.add_theme_color_override("font_color", Color(0.65, 0.72, 0.85, 0.8))
	
	card.add_theme_stylebox_override("panel", style)

func _update_card_highlights() -> void:
	for clue_id in _card_map:
		var card = _card_map[clue_id]
		if _selected_clue_ids.has(clue_id):
			_apply_card_style(card, "selected")
		else:
			_apply_card_style(card, "normal")

## Toggles the selection of a clue for synthesis
func toggle_clue_selection(clue_id: String) -> void:
	if _selected_clue_ids.has(clue_id):
		_selected_clue_ids.erase(clue_id)
	else:
		if _selected_clue_ids.size() < 2:
			_selected_clue_ids.append(clue_id)
		else:
			# Replace the second slot
			_selected_clue_ids[1] = clue_id
	
	_update_workbench()
	_update_card_highlights()

func clear_selection(preserve_feedback: bool = false) -> void:
	_selected_clue_ids.clear()
	_update_workbench(preserve_feedback)
	_update_card_highlights()

func _on_slot1_pressed() -> void:
	if _selected_clue_ids.size() > 0:
		_selected_clue_ids.remove_at(0)
		_update_workbench()
		_update_card_highlights()

func _on_slot2_pressed() -> void:
	if _selected_clue_ids.size() > 1:
		_selected_clue_ids.remove_at(1)
		_update_workbench()
		_update_card_highlights()

## Updates the synthesis workbench display and buttons
func _update_workbench(preserve_feedback: bool = false) -> void:
	var lang: String = _get_current_language()
	var empty_slot_txt: String = Localization.get_ui_text("NOTEBOOK_SLOT_EMPTY", lang)
	
	# Slot 1
	if slot1_button:
		if _selected_clue_ids.size() > 0:
			var c1 = Localization.get_clue_data(_selected_clue_ids[0], lang)
			slot1_button.text = "%s %s" % [c1.get("icon", "🔍"), c1.get("title", _selected_clue_ids[0])]
			_set_slot_active(slot1_button, true)
		else:
			slot1_button.text = empty_slot_txt + " 1"
			_set_slot_active(slot1_button, false)
	
	# Slot 2
	if slot2_button:
		if _selected_clue_ids.size() > 1:
			var c2 = Localization.get_clue_data(_selected_clue_ids[1], lang)
			slot2_button.text = "%s %s" % [c2.get("icon", "🔍"), c2.get("title", _selected_clue_ids[1])]
			_set_slot_active(slot2_button, true)
		else:
			slot2_button.text = empty_slot_txt + " 2"
			_set_slot_active(slot2_button, false)
	
	# Deduce Button state
	if deduce_button:
		var ready_to_deduce = (_selected_clue_ids.size() == 2)
		deduce_button.disabled = not ready_to_deduce
		_set_deduce_button_style(ready_to_deduce)
	
	# Feedback prompt
	if feedback_label and not preserve_feedback:
		if _selected_clue_ids.size() == 0:
			feedback_label.text = Localization.get_ui_text("NOTEBOOK_WORKBENCH_HINT", lang)
			feedback_label.add_theme_color_override("font_color", Color(0.72, 0.78, 0.88, 1.0))
		elif _selected_clue_ids.size() == 1:
			feedback_label.text = Localization.get_ui_text("NOTEBOOK_FEEDBACK_SELECT_TWO", lang)
			feedback_label.add_theme_color_override("font_color", Color(0.988, 0.827, 0.302, 1.0))
		else:
			feedback_label.text = Localization.get_ui_text("NOTEBOOK_DEDUCE_BTN", lang) + " ▶"
			feedback_label.add_theme_color_override("font_color", Color(1.0, 0.92, 0.5, 1.0))

func _set_slot_active(btn: Button, is_active: bool) -> void:
	var style = StyleBoxFlat.new()
	style.corner_radius_top_left = 5
	style.corner_radius_top_right = 5
	style.corner_radius_bottom_right = 5
	style.corner_radius_bottom_left = 5
	style.border_width_left = 1
	style.border_width_top = 1
	style.border_width_right = 1
	style.border_width_bottom = 1
	
	if is_active:
		style.bg_color = Color(0.22, 0.17, 0.07, 0.95)
		style.border_color = Color(0.988, 0.827, 0.302, 1.0)
		btn.add_theme_color_override("font_color", Color(1.0, 0.92, 0.6, 1.0))
	else:
		style.bg_color = Color(0.098, 0.12, 0.188, 0.85)
		style.border_color = Color(0.5, 0.58, 0.72, 0.6)
		btn.add_theme_color_override("font_color", Color(0.65, 0.72, 0.82, 0.8))
	
	btn.add_theme_stylebox_override("normal", style)
	btn.add_theme_stylebox_override("hover", style)
	btn.add_theme_stylebox_override("focus", style)

func _set_deduce_button_style(is_enabled: bool) -> void:
	var style = StyleBoxFlat.new()
	style.corner_radius_top_left = 5
	style.corner_radius_top_right = 5
	style.corner_radius_bottom_right = 5
	style.corner_radius_bottom_left = 5
	style.border_width_left = 1
	style.border_width_top = 1
	style.border_width_right = 1
	style.border_width_bottom = 1
	
	if is_enabled:
		style.bg_color = Color(0.882, 0.725, 0.321, 1.0)
		style.border_color = Color(1.0, 0.92, 0.6, 1.0)
		deduce_button.add_theme_color_override("font_color", Color(0.08, 0.08, 0.08, 1.0))
	else:
		style.bg_color = Color(0.18, 0.20, 0.26, 0.6)
		style.border_color = Color(0.35, 0.40, 0.50, 0.4)
		deduce_button.add_theme_color_override("font_color", Color(0.5, 0.55, 0.62, 0.6))
	
	deduce_button.add_theme_stylebox_override("normal", style)
	deduce_button.add_theme_stylebox_override("disabled", style)

## Evaluates the currently selected pair of clues
func attempt_connection() -> Dictionary:
	if _selected_clue_ids.size() < 2:
		return {"status": "INVALID"}
	
	var game_state = get_node_or_null("/root/GameState")
	if game_state == null:
		return {"status": "INVALID"}
	
	var res: Dictionary = game_state.evaluate_clue_connection(_selected_clue_ids[0], _selected_clue_ids[1])
	var status: String = res.get("status", "")
	var msg: String = res.get("message", "")
	
	if status == "SUCCESS":
		_animate_success()
		var ded_id: String = res.get("deduction", {}).get("id", "")
		deduction_made.emit(ded_id)
		clear_selection(true)
		refresh_deductions()
		_update_tab_buttons()
		if feedback_label:
			feedback_label.text = msg
			feedback_label.add_theme_color_override("font_color", Color(0.4, 0.95, 0.5, 1.0))
	elif status == "ALREADY_UNLOCKED":
		if feedback_label:
			feedback_label.text = msg
			feedback_label.add_theme_color_override("font_color", Color(0.49, 0.78, 0.98, 1.0))
	elif status == "NO_CONNECTION":
		if feedback_label:
			feedback_label.text = msg
			feedback_label.add_theme_color_override("font_color", Color(0.98, 0.75, 0.4, 1.0))
	
	return res

func _animate_success() -> void:
	if workbench_panel:
		var tween = create_tween()
		tween.tween_property(workbench_panel, "modulate", Color(1.3, 1.2, 0.8, 1.0), 0.15)
		tween.tween_property(workbench_panel, "modulate", Color.WHITE, 0.3)

## Refreshes the list of synthesized deductions
func refresh_deductions() -> void:
	var lang: String = _get_current_language()
	var game_state = get_node_or_null("/root/GameState")
	
	if deductions_empty_label:
		deductions_empty_label.text = Localization.get_ui_text("NOTEBOOK_DEDUCTIONS_EMPTY", lang)
	
	var deductions: Array[Dictionary] = game_state.get_deductions() if game_state else []
	
	for child in deductions_list.get_children():
		if child != deductions_empty_label:
			deductions_list.remove_child(child)
			child.queue_free()
	
	var count_fmt: String = Localization.get_ui_text("NOTEBOOK_DEDUCTION_COUNT", lang)
	if deductions.is_empty():
		deductions_empty_label.visible = true
		if deduction_count_label:
			deduction_count_label.text = count_fmt % 0
	else:
		deductions_empty_label.visible = false
		if deduction_count_label:
			deduction_count_label.text = count_fmt % deductions.size()
		
		for ded in deductions:
			var card: PanelContainer = _create_deduction_card(ded)
			deductions_list.add_child(card)
	
	_update_tab_buttons()

## Creates a styled deduction card
func _create_deduction_card(deduction: Dictionary) -> PanelContainer:
	var card = PanelContainer.new()
	card.name = "DeductionCard_%s" % deduction.get("id", "")
	
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.12, 0.10, 0.05, 0.95)
	style.border_width_left = 2
	style.border_width_top = 2
	style.border_width_right = 2
	style.border_width_bottom = 2
	style.border_color = Color(0.988, 0.827, 0.302, 0.95)
	style.corner_radius_top_left = 6
	style.corner_radius_top_right = 6
	style.corner_radius_bottom_right = 6
	style.corner_radius_bottom_left = 6
	card.add_theme_stylebox_override("panel", style)
	
	var margin = MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 14)
	margin.add_theme_constant_override("margin_top", 10)
	margin.add_theme_constant_override("margin_right", 14)
	margin.add_theme_constant_override("margin_bottom", 10)
	card.add_child(margin)
	
	var hbox = HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 14)
	margin.add_child(hbox)
	
	# Icon
	var icon_lbl = Label.new()
	icon_lbl.text = deduction.get("icon", "💡")
	icon_lbl.add_theme_font_size_override("font_size", 24)
	icon_lbl.custom_minimum_size = Vector2(34, 0)
	icon_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	hbox.add_child(icon_lbl)
	
	# Content
	var vbox = VBoxContainer.new()
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vbox.add_theme_constant_override("separation", 4)
	hbox.add_child(vbox)
	
	var header_hbox = HBoxContainer.new()
	vbox.add_child(header_hbox)
	
	var title_lbl = Label.new()
	title_lbl.text = "✦ " + deduction.get("title", "Case Deduction")
	title_lbl.add_theme_color_override("font_color", Color(0.988235, 0.854902, 0.419608, 1.0))
	title_lbl.add_theme_font_size_override("font_size", 15)
	title_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header_hbox.add_child(title_lbl)
	
	var badge_lbl = Label.new()
	badge_lbl.text = "✔ DEDUCTION"
	badge_lbl.add_theme_color_override("font_color", Color(0.988, 0.827, 0.302, 1.0))
	badge_lbl.add_theme_font_size_override("font_size", 11)
	header_hbox.add_child(badge_lbl)
	
	# Connected Clues sub-label
	var lang: String = _get_current_language()
	var clue_ids: Array = deduction.get("clues", [])
	var clue_titles: Array[String] = []
	for cid in clue_ids:
		var c_data = Localization.get_clue_data(cid, lang)
		clue_titles.append(c_data.get("title", cid))
	
	var conn_prefix: String = Localization.get_ui_text("NOTEBOOK_CONNECTED_LABEL", lang)
	var conn_lbl = Label.new()
	conn_lbl.text = conn_prefix + " + ".join(clue_titles)
	conn_lbl.add_theme_color_override("font_color", Color(0.49, 0.78, 0.98, 1.0))
	conn_lbl.add_theme_font_size_override("font_size", 11)
	vbox.add_child(conn_lbl)
	
	var desc_lbl = Label.new()
	desc_lbl.text = deduction.get("description", "")
	desc_lbl.add_theme_color_override("font_color", Color(0.92, 0.94, 0.97, 1.0))
	desc_lbl.add_theme_font_size_override("font_size", 13)
	desc_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vbox.add_child(desc_lbl)
	
	return card

func _get_current_language() -> String:
	var game_state = get_node_or_null("/root/GameState") if is_inside_tree() else null
	if game_state and game_state.has_method("get_language"):
		return game_state.get_language()
	return "my"

func _on_backdrop_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		close_notebook()
	elif event is InputEventScreenTouch and event.pressed:
		close_notebook()

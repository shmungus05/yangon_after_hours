class_name NotebookPanel
extends Control

## Reusable investigator's notebook panel for Yangon After Hours.
## Displays all discovered clues and evidence, persisting across locations.

signal notebook_opened
signal notebook_closed

@onready var backdrop: Control = %Backdrop
@onready var top_close_button: Button = %TopCloseButton
@onready var close_button: Button = %CloseButton
@onready var clues_list: VBoxContainer = %CluesList
@onready var empty_state_label: Label = %EmptyStateLabel
@onready var clue_count_label: Label = %ClueCountLabel

func _ready() -> void:
	visible = false
	if backdrop and not backdrop.gui_input.is_connected(_on_backdrop_input):
		backdrop.gui_input.connect(_on_backdrop_input)
	if top_close_button and not top_close_button.pressed.is_connected(close_notebook):
		top_close_button.pressed.connect(close_notebook)
	if close_button and not close_button.pressed.is_connected(close_notebook):
		close_button.pressed.connect(close_notebook)

func _unhandled_input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("ui_cancel"):
		close_notebook()
		get_viewport().set_input_as_handled()

func open_notebook() -> void:
	refresh_clues()
	visible = true
	notebook_opened.emit()
	if close_button and close_button.is_inside_tree():
		close_button.grab_focus()

func close_notebook() -> void:
	visible = false
	notebook_closed.emit()

func refresh_clues() -> void:
	var game_state = get_node_or_null("/root/GameState")
	var clues: Array[Dictionary] = game_state.get_clues() if game_state else []
	
	# Clear previous clue cards (except empty state label)
	for child in clues_list.get_children():
		if child != empty_state_label:
			child.queue_free()
	
	if clues.is_empty():
		empty_state_label.visible = true
		clue_count_label.text = "Recorded Clues: 0"
	else:
		empty_state_label.visible = false
		clue_count_label.text = "Recorded Clues: %d" % clues.size()
		
		for clue in clues:
			var card: PanelContainer = _create_clue_card(clue)
			clues_list.add_child(card)

func _create_clue_card(clue: Dictionary) -> PanelContainer:
	var card = PanelContainer.new()
	var margin = MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 14)
	margin.add_theme_constant_override("margin_top", 10)
	margin.add_theme_constant_override("margin_right", 14)
	margin.add_theme_constant_override("margin_bottom", 10)
	card.add_child(margin)
	
	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 6)
	margin.add_child(vbox)
	
	var header_hbox = HBoxContainer.new()
	vbox.add_child(header_hbox)
	
	var title_lbl = Label.new()
	title_lbl.text = "📜 " + clue.get("title", "Untitled Clue")
	title_lbl.add_theme_color_override("font_color", Color(0.988235, 0.827451, 0.301961, 1.0))
	title_lbl.add_theme_font_size_override("font_size", 16)
	title_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header_hbox.add_child(title_lbl)
	
	var loc_lbl = Label.new()
	loc_lbl.text = "📍 " + clue.get("location", "Yangon")
	loc_lbl.add_theme_color_override("font_color", Color(0.49, 0.78, 0.98, 1.0))
	loc_lbl.add_theme_font_size_override("font_size", 13)
	header_hbox.add_child(loc_lbl)
	
	var desc_lbl = Label.new()
	desc_lbl.text = clue.get("description", "")
	desc_lbl.add_theme_color_override("font_color", Color(0.92, 0.94, 0.97, 1.0))
	desc_lbl.add_theme_font_size_override("font_size", 14)
	desc_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vbox.add_child(desc_lbl)
	
	return card

func _on_backdrop_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		close_notebook()
	elif event is InputEventScreenTouch and event.pressed:
		close_notebook()

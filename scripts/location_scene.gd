extends Control

const Localization = preload("res://scripts/localization.gd")

## Base script for location scenes in Yangon After Hours.
## Manages point-and-click hotspots, dialogue panel, notebook, puzzles, and map navigation.

@export var location_id: String = "downtown"
@export var location_title: String = "Downtown (Sule)"
@export var location_subtitle: String = "Colonial Heritage & Neon Alleyways"
@export_multiline var location_description: String = "Rain-slicked asphalt reflects golden pagoda spires and glowing neon signs."
@export var background_texture: Texture2D

@onready var back_button: Button = %BackToMapButton
@onready var title_label: Label = %LocationTitleLabel
@onready var subtitle_label: Label = %LocationSubtitleLabel
@onready var description_label: Label = %LocationDescriptionLabel
@onready var background_rect: TextureRect = %BackgroundRect
@onready var narrative_panel: PanelContainer = %NarrativePanel
@onready var dialogue_panel: DialoguePanel = %DialoguePanel
@onready var notebook_button: Button = %NotebookButton
@onready var notebook_panel: NotebookPanel = %NotebookPanel
@onready var tea_puzzle_panel: TeaPuzzlePanel = get_node_or_null("%TeaPuzzlePanel")
@onready var market_puzzle_panel: MarketPuzzlePanel = get_node_or_null("%MarketPuzzlePanel")
@onready var delivery_puzzle_panel: DeliveryPuzzlePanel = get_node_or_null("%DeliveryPuzzlePanel")

var _lang_button: Button = null

func _ready() -> void:
	var game_state = get_node_or_null("/root/GameState")
	if game_state:
		game_state.current_location_id = location_id
		game_state.language_changed.connect(_on_language_changed)
		game_state.clue_added.connect(func(_id, _desc): _update_notebook_button())

	if back_button:
		back_button.pressed.connect(_on_back_to_map_pressed)
	
	if background_rect and background_texture:
		background_rect.texture = background_texture
	
	_create_language_button()
	_connect_dialogue_panel()
	_connect_notebook()
	_connect_puzzle()
	_connect_hotspots()
	_update_localized_ui()

func _create_language_button() -> void:
	var top_bar: Node = null
	if back_button and back_button.get_parent():
		top_bar = back_button.get_parent()
	
	if top_bar:
		_lang_button = Button.new()
		_lang_button.name = "LocationLangButton"
		_lang_button.custom_minimum_size = Vector2(100, 44)
		_lang_button.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		_lang_button.add_theme_font_size_override("font_size", 15)
		_lang_button.add_theme_color_override("font_color", Color(0.78, 0.9, 1.0, 1.0))
		_lang_button.pressed.connect(func():
			var gs = get_node_or_null("/root/GameState")
			if gs:
				gs.toggle_language()
		)
		top_bar.add_child(_lang_button)
		if notebook_button:
			top_bar.move_child(_lang_button, notebook_button.get_index())

func _update_localized_ui() -> void:
	var game_state = get_node_or_null("/root/GameState")
	var lang: String = game_state.get_language() if game_state else "my"
	var loc_data: Dictionary = game_state.get_location_data(location_id) if game_state else {}
	
	if title_label:
		title_label.text = loc_data.get("title", location_title)
	if subtitle_label:
		subtitle_label.text = loc_data.get("subtitle", location_subtitle)
	if description_label:
		description_label.text = loc_data.get("description", location_description)
	if back_button:
		back_button.text = Localization.get_ui_text("BACK_TO_MAP", lang)
	if _lang_button:
		_lang_button.text = "မြန်မာ" if lang == "my" else "English"
	
	_update_notebook_button()
	_update_hotspots_text(self, lang)

func _update_hotspots_text(parent_node: Node, lang: String) -> void:
	for child in parent_node.get_children():
		if child is InteractableHotspot:
			var h_data = Localization.get_hotspot_data(child.name, lang)
			if h_data.has("button_text"):
				child.text = h_data["button_text"]
		_update_hotspots_text(child, lang)

func _on_language_changed(_lang: String) -> void:
	_update_localized_ui()

func _connect_dialogue_panel() -> void:
	if dialogue_panel:
		dialogue_panel.dialogue_started.connect(_on_dialogue_started)
		dialogue_panel.dialogue_closed.connect(_on_dialogue_closed)

func _connect_notebook() -> void:
	if notebook_button and not notebook_button.pressed.is_connected(_on_notebook_pressed):
		notebook_button.pressed.connect(_on_notebook_pressed)

func _connect_puzzle() -> void:
	if tea_puzzle_panel:
		tea_puzzle_panel.puzzle_completed.connect(_on_puzzle_completed)
	if market_puzzle_panel:
		market_puzzle_panel.puzzle_completed.connect(_on_puzzle_completed)
	if delivery_puzzle_panel:
		delivery_puzzle_panel.puzzle_completed.connect(_on_puzzle_completed)

func _on_puzzle_completed() -> void:
	_update_notebook_button()

func _update_notebook_button() -> void:
	if notebook_button:
		var game_state = get_node_or_null("/root/GameState")
		var count: int = game_state.get_clue_count() if game_state else 0
		var lang: String = game_state.get_language() if game_state else "my"
		var fmt: String = Localization.get_ui_text("NOTEBOOK_BTN", lang)
		notebook_button.text = fmt % count

func _on_notebook_pressed() -> void:
	if notebook_panel:
		notebook_panel.open_notebook()

func _connect_hotspots() -> void:
	_find_and_connect_hotspots(self)

func _find_and_connect_hotspots(parent_node: Node) -> void:
	for child in parent_node.get_children():
		if child is InteractableHotspot:
			if not child.interacted.is_connected(_on_hotspot_interacted):
				child.interacted.connect(_on_hotspot_interacted)
		_find_and_connect_hotspots(child)

func _on_hotspot_interacted(hotspot: InteractableHotspot) -> void:
	var game_state = get_node_or_null("/root/GameState")
	var lang: String = game_state.get_language() if game_state else "my"
	
	# Trigger dedicated puzzles if applicable
	if hotspot.name == "TeaOrdersHotspot" and tea_puzzle_panel:
		tea_puzzle_panel.open_puzzle()
		return
	if hotspot.name == "MarketNotebookHotspot" and market_puzzle_panel:
		market_puzzle_panel.open_puzzle()
		return
	if hotspot.name == "DeliveryHotspot" and delivery_puzzle_panel:
		delivery_puzzle_panel.open_puzzle()
		return
	
	var h_data: Dictionary = Localization.get_hotspot_data(hotspot.name, lang)
	var lines_to_show: Array[String] = []
	
	# React dynamically based on puzzle progression
	if hotspot.name == "TeaMasterHotspot" and game_state:
		if game_state.is_puzzle_solved("tea_order_puzzle"):
			lines_to_show = _to_string_array(h_data.get("dialogue_solved", []))
		else:
			lines_to_show = _to_string_array(h_data.get("dialogue_default", []))
	elif hotspot.name == "VendorHotspot" and game_state:
		if game_state.is_puzzle_solved("market_notebook_puzzle"):
			lines_to_show = _to_string_array(h_data.get("dialogue_solved", []))
		else:
			lines_to_show = _to_string_array(h_data.get("dialogue_default", []))
	elif hotspot.name == "WatchmanHotspot" and game_state:
		if game_state.is_puzzle_solved("final_delivery_puzzle"):
			lines_to_show = _to_string_array(h_data.get("dialogue_delivery_solved", []))
		elif game_state.is_puzzle_solved("market_notebook_puzzle"):
			lines_to_show = _to_string_array(h_data.get("dialogue_market_solved", []))
		else:
			lines_to_show = _to_string_array(h_data.get("dialogue_default", []))
	else:
		if h_data.has("dialogue_default"):
			lines_to_show = _to_string_array(h_data["dialogue_default"])
		else:
			lines_to_show = hotspot.dialogue_lines.duplicate()
	
	if lines_to_show.is_empty():
		lines_to_show = hotspot.dialogue_lines.duplicate()
	
	# Check if this hotspot contains a clue to discover
	if not hotspot.clue_id.is_empty() and game_state:
		var clue_info: Dictionary = Localization.get_clue_data(hotspot.clue_id, lang)
		var c_title: String = clue_info.get("title", hotspot.clue_title)
		var c_desc: String = clue_info.get("desc", hotspot.clue_description)
		var loc_data: Dictionary = game_state.get_location_data(location_id)
		var loc_title: String = loc_data.get("title", location_title)
		
		var is_new: bool = game_state.add_clue(hotspot.clue_id, c_title, c_desc, loc_title)
		if is_new:
			_update_notebook_button()
			var clue_fmt: String = Localization.get_ui_text("CLUE_RECORDED", lang)
			lines_to_show.append(clue_fmt % c_title)
	
	if dialogue_panel:
		var speaker: String = h_data.get("speaker", hotspot.speaker_name)
		var avatar: Texture2D = hotspot.avatar_texture if "avatar_texture" in hotspot else null
		dialogue_panel.show_dialogue(speaker, lines_to_show, avatar)

func _to_string_array(src: Array) -> Array[String]:
	var result: Array[String] = []
	for item in src:
		result.append(str(item))
	return result

func _on_dialogue_started(_speaker: String) -> void:
	if narrative_panel:
		narrative_panel.visible = false

func _on_dialogue_closed() -> void:
	if narrative_panel:
		narrative_panel.visible = true

func _on_back_to_map_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/city_map.tscn")

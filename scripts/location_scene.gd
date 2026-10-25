extends Control

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

func _ready() -> void:
	if back_button:
		back_button.pressed.connect(_on_back_to_map_pressed)
	if title_label:
		title_label.text = location_title
	if subtitle_label:
		subtitle_label.text = location_subtitle
	if description_label:
		description_label.text = location_description
	if background_rect and background_texture:
		background_rect.texture = background_texture
	
	var game_state = get_node_or_null("/root/GameState")
	if game_state:
		game_state.current_location_id = location_id
	
	_connect_dialogue_panel()
	_connect_notebook()
	_connect_puzzle()
	_connect_hotspots()
	_update_notebook_button()

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

func _on_puzzle_completed() -> void:
	_update_notebook_button()

func _update_notebook_button() -> void:
	if notebook_button:
		var game_state = get_node_or_null("/root/GameState")
		var count: int = game_state.get_clue_count() if game_state else 0
		notebook_button.text = "📓 Notebook (%d)" % count

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
	# Trigger dedicated puzzle if applicable
	if hotspot.name == "TeaOrdersHotspot" and tea_puzzle_panel:
		tea_puzzle_panel.open_puzzle()
		return
	
	var lines_to_show: Array[String] = hotspot.dialogue_lines.duplicate()
	
	# React dynamically if puzzle is already solved
	if hotspot.name == "TeaMasterHotspot":
		var game_state = get_node_or_null("/root/GameState")
		if game_state and game_state.is_puzzle_solved("tea_order_puzzle"):
			lines_to_show = [
				"Mingalarbar! Thanks to your keen deduction, Table Three is happily drinking their favorite tea!",
				"That nervous customer dropped the harbor cargo slip when he rushed out. Make sure you check your notebook and investigate the Strand Road docks!"
			]
	
	# Check if this hotspot contains a clue to discover
	if not hotspot.clue_id.is_empty():
		var game_state = get_node_or_null("/root/GameState")
		if game_state:
			var is_new: bool = game_state.add_clue(
				hotspot.clue_id,
				hotspot.clue_title,
				hotspot.clue_description,
				location_title
			)
			if is_new:
				_update_notebook_button()
				lines_to_show.append("📓 [ CLUE RECORDED IN NOTEBOOK: %s ]" % hotspot.clue_title)
	
	if dialogue_panel:
		var avatar: Texture2D = hotspot.avatar_texture if "avatar_texture" in hotspot else null
		dialogue_panel.show_dialogue(hotspot.speaker_name, lines_to_show, avatar)

func _on_dialogue_started(_speaker: String) -> void:
	if narrative_panel:
		narrative_panel.visible = false

func _on_dialogue_closed() -> void:
	if narrative_panel:
		narrative_panel.visible = true

func _on_back_to_map_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/city_map.tscn")

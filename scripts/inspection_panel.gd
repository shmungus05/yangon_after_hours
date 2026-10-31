class_name InspectionPanel
extends Control

const Localization = preload("res://scripts/localization.gd")

## Reusable close-up object inspection system for Yangon After Hours.
## Displays a zoomed-in view of selected items with clickable detail areas,
## typewriter observations, clue collection, and notebook integration.

signal inspection_opened(object_id: String)
signal area_inspected(area_id: String, clue_id: String)
signal clue_collected(clue_id: String)
signal inspection_closed

@onready var backdrop: Control = %Backdrop
@onready var main_dialog: PanelContainer = %MainDialog
@onready var object_title_label: Label = %ObjectTitleLabel
@onready var object_subtitle_label: Label = %ObjectSubtitleLabel
@onready var close_button: Button = %CloseButton
@onready var object_texture: TextureRect = %ObjectTexture
@onready var hotspots_container: Control = %HotspotsContainer
@onready var observation_title_label: Label = %ObservationTitleLabel
@onready var observation_label: Label = %ObservationLabel
@onready var clue_notice_badge: PanelContainer = %ClueNoticeBadge
@onready var clue_notice_label: Label = %ClueNoticeLabel
@onready var notebook_button: Button = %NotebookButton
@onready var return_button: Button = %ReturnButton
@onready var footer_hint_label: Label = %FooterHintLabel

var _current_object_id: String = ""
var _current_object_data: Dictionary = {}
var _is_typing: bool = false
var _typewriter_tween: Tween = null
var _area_buttons: Array[Button] = []

func _ready() -> void:
	visible = false
	_ensure_nodes()
	
	if close_button and not close_button.pressed.is_connected(close_inspection):
		close_button.pressed.connect(close_inspection)
	if return_button and not return_button.pressed.is_connected(close_inspection):
		return_button.pressed.connect(close_inspection)
	if notebook_button and not notebook_button.pressed.is_connected(_on_notebook_pressed):
		notebook_button.pressed.connect(_on_notebook_pressed)
	if backdrop and not backdrop.gui_input.is_connected(_on_backdrop_input):
		backdrop.gui_input.connect(_on_backdrop_input)

func _ensure_nodes() -> void:
	if backdrop == null and has_node("%Backdrop"):
		backdrop = %Backdrop
	if main_dialog == null and has_node("%MainDialog"):
		main_dialog = %MainDialog
	if object_title_label == null and has_node("%ObjectTitleLabel"):
		object_title_label = %ObjectTitleLabel
	if object_subtitle_label == null and has_node("%ObjectSubtitleLabel"):
		object_subtitle_label = %ObjectSubtitleLabel
	if close_button == null and has_node("%CloseButton"):
		close_button = %CloseButton
	if object_texture == null and has_node("%ObjectTexture"):
		object_texture = %ObjectTexture
	if hotspots_container == null and has_node("%HotspotsContainer"):
		hotspots_container = %HotspotsContainer
	if observation_title_label == null and has_node("%ObservationTitleLabel"):
		observation_title_label = %ObservationTitleLabel
	if observation_label == null and has_node("%ObservationLabel"):
		observation_label = %ObservationLabel
	if clue_notice_badge == null and has_node("%ClueNoticeBadge"):
		clue_notice_badge = %ClueNoticeBadge
	if clue_notice_label == null and has_node("%ClueNoticeLabel"):
		clue_notice_label = %ClueNoticeLabel
	if notebook_button == null and has_node("%NotebookButton"):
		notebook_button = %NotebookButton
	if return_button == null and has_node("%ReturnButton"):
		return_button = %ReturnButton
	if footer_hint_label == null and has_node("%FooterHintLabel"):
		footer_hint_label = %FooterHintLabel

## Opens the close-up inspection view for the specified object ID.
func open_inspection(object_id: String) -> void:
	_ensure_nodes()
	_current_object_id = object_id
	
	var lang: String = "my"
	if is_inside_tree():
		var game_state = get_node_or_null("/root/GameState")
		if game_state and game_state.has_method("get_language"):
			lang = game_state.get_language()
	
	_current_object_data = Localization.get_inspection_data(object_id, lang)
	if _current_object_data.is_empty():
		push_warning("InspectionPanel: No data found for object '%s'" % object_id)
		return
	
	# Set header info
	if object_title_label:
		object_title_label.text = "✦ " + _current_object_data.get("title", object_id)
	if object_subtitle_label:
		object_subtitle_label.text = _current_object_data.get("subtitle", "")
	if close_button:
		close_button.text = Localization.get_ui_text("INSPECT_CLOSE", lang)
	if return_button:
		return_button.text = Localization.get_ui_text("INSPECT_RETURN", lang)
	if footer_hint_label:
		footer_hint_label.text = Localization.get_ui_text("INSPECT_PROMPT", lang)
	
	# Load close-up texture
	var tex_path: String = _current_object_data.get("texture_path", "")
	var tex: Texture2D = null
	if ResourceLoader.exists(tex_path):
		tex = load(tex_path)
	elif FileAccess.file_exists(tex_path):
		var img: Image = Image.load_from_file(tex_path)
		if img:
			tex = ImageTexture.create_from_image(img)
	
	if object_texture and tex:
		object_texture.texture = tex
	
	# Reset observation panel
	if observation_title_label:
		observation_title_label.text = Localization.get_ui_text("INSPECT_OBS_TITLE", lang)
	if observation_label:
		observation_label.text = Localization.get_ui_text("INSPECT_INITIAL_OBS", lang)
		observation_label.visible_characters = -1
	if clue_notice_badge:
		clue_notice_badge.visible = false
	
	_update_notebook_button()
	_build_hotspots(_current_object_data.get("areas", []))
	
	visible = true
	_animate_entrance()
	inspection_opened.emit(object_id)

## Closes the inspection view and returns to the location scene.
func close_inspection() -> void:
	if _typewriter_tween and _typewriter_tween.is_valid():
		_typewriter_tween.kill()
	_is_typing = false
	visible = false
	_current_object_id = ""
	_current_object_data = {}
	_clear_hotspots()
	inspection_closed.emit()

func _clear_hotspots() -> void:
	if hotspots_container:
		for child in hotspots_container.get_children():
			hotspots_container.remove_child(child)
			child.queue_free()
	_area_buttons.clear()

func _build_hotspots(areas: Array) -> void:
	_clear_hotspots()
	if hotspots_container == null:
		return
	
	for i in range(areas.size()):
		var area: Dictionary = areas[i]
		var rect: Rect2 = area.get("rect", Rect2(50, 50, 100, 60))
		var btn: Button = Button.new()
		btn.name = "AreaButton_%s" % area.get("id", str(i))
		btn.text = "🔍  " + area.get("name", "Inspect")
		btn.tooltip_text = area.get("name", "Inspect Detail")
		btn.position = rect.position
		btn.size = rect.size
		btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		btn.focus_mode = Control.FOCUS_ALL
		btn.add_theme_font_size_override("font_size", 12)
		
		# Normal style: semi-transparent dark with warm gold outline
		var normal_style = StyleBoxFlat.new()
		normal_style.bg_color = Color(0.08, 0.11, 0.18, 0.35)
		normal_style.border_width_left = 1
		normal_style.border_width_top = 1
		normal_style.border_width_right = 1
		normal_style.border_width_bottom = 1
		normal_style.border_color = Color(0.88, 0.72, 0.32, 0.75)
		normal_style.corner_radius_top_left = 4
		normal_style.corner_radius_top_right = 4
		normal_style.corner_radius_bottom_right = 4
		normal_style.corner_radius_bottom_left = 4
		btn.add_theme_stylebox_override("normal", normal_style)
		btn.add_theme_color_override("font_color", Color(0.988, 0.85, 0.40, 0.9))
		
		# Hover / Focus style: radiant warm gold highlight
		var hover_style = StyleBoxFlat.new()
		hover_style.bg_color = Color(0.96, 0.78, 0.22, 0.45)
		hover_style.border_width_left = 2
		hover_style.border_width_top = 2
		hover_style.border_width_right = 2
		hover_style.border_width_bottom = 2
		hover_style.border_color = Color(1.0, 0.90, 0.45, 1.0)
		hover_style.corner_radius_top_left = 4
		hover_style.corner_radius_top_right = 4
		hover_style.corner_radius_bottom_right = 4
		hover_style.corner_radius_bottom_left = 4
		btn.add_theme_stylebox_override("hover", hover_style)
		btn.add_theme_stylebox_override("focus", hover_style)
		btn.add_theme_color_override("font_hover_color", Color(1.0, 1.0, 1.0, 1.0))
		btn.add_theme_color_override("font_focus_color", Color(1.0, 1.0, 1.0, 1.0))
		
		# Pressed style
		var pressed_style = StyleBoxFlat.new()
		pressed_style.bg_color = Color(0.85, 0.68, 0.18, 0.7)
		pressed_style.corner_radius_top_left = 4
		pressed_style.corner_radius_top_right = 4
		pressed_style.corner_radius_bottom_right = 4
		pressed_style.corner_radius_bottom_left = 4
		btn.add_theme_stylebox_override("pressed", pressed_style)
		
		var area_copy: Dictionary = area.duplicate(true)
		btn.pressed.connect(_on_area_pressed.bind(area_copy))
		
		hotspots_container.add_child(btn)
		_area_buttons.append(btn)

func _on_area_pressed(area: Dictionary) -> void:
	var lang: String = "my"
	var game_state = get_node_or_null("/root/GameState") if is_inside_tree() else null
	if game_state and game_state.has_method("get_language"):
		lang = game_state.get_language()
	
	if observation_title_label:
		observation_title_label.text = "✦ " + area.get("name", "Observation")
	
	var obs_text: String = area.get("observation", "")
	_start_typewriter(obs_text)
	
	# Process clue collection if this area yields a clue
	var clue_id: String = area.get("clue_id", "")
	if not clue_id.is_empty() and game_state:
		var clue_info: Dictionary = Localization.get_clue_data(clue_id, lang)
		var c_title: String = clue_info.get("title", area.get("name", clue_id))
		var c_desc: String = clue_info.get("desc", obs_text)
		var loc_title: String = clue_info.get("location", "Lucky Tea Shop")
		
		var is_new: bool = game_state.add_clue(clue_id, c_title, c_desc, loc_title)
		if clue_notice_badge and clue_notice_label:
			clue_notice_badge.visible = true
			if is_new:
				var fmt: String = Localization.get_ui_text("INSPECT_CLUE_FOUND", lang)
				clue_notice_label.text = fmt % c_title
				clue_collected.emit(clue_id)
				_update_notebook_button()
			else:
				var fmt: String = Localization.get_ui_text("INSPECT_CLUE_ALREADY", lang)
				clue_notice_label.text = fmt % c_title
	else:
		if clue_notice_badge:
			clue_notice_badge.visible = false
	
	area_inspected.emit(area.get("id", ""), clue_id)

func _start_typewriter(full_text: String) -> void:
	if _typewriter_tween and _typewriter_tween.is_valid():
		_typewriter_tween.kill()
	
	if observation_label:
		observation_label.text = full_text
		observation_label.visible_characters = 0
	
	var char_count: int = full_text.length()
	if char_count == 0:
		_is_typing = false
		if observation_label:
			observation_label.visible_characters = -1
		return
	
	_is_typing = true
	var typing_speed: float = 50.0
	var duration: float = clampf(float(char_count) / typing_speed, 0.2, 1.4)
	
	_typewriter_tween = create_tween()
	_typewriter_tween.tween_property(observation_label, "visible_characters", char_count, duration)
	_typewriter_tween.finished.connect(func():
		_is_typing = false
		if observation_label:
			observation_label.visible_characters = -1
	)

func _skip_typewriter() -> void:
	if _typewriter_tween and _typewriter_tween.is_valid():
		_typewriter_tween.kill()
	_is_typing = false
	if observation_label:
		observation_label.visible_characters = -1

func _update_notebook_button() -> void:
	if notebook_button:
		var game_state = get_node_or_null("/root/GameState") if is_inside_tree() else null
		var count: int = game_state.get_clue_count() if game_state else 0
		var lang: String = game_state.get_language() if game_state else "my"
		var fmt: String = Localization.get_ui_text("INSPECT_NOTEBOOK_BTN", lang)
		notebook_button.text = fmt % count

func _on_notebook_pressed() -> void:
	if not is_inside_tree():
		return
	var nb: NotebookPanel = null
	if owner:
		nb = owner.get_node_or_null("%NotebookPanel") as NotebookPanel
	if nb == null and get_parent():
		nb = get_parent().get_node_or_null("%NotebookPanel") as NotebookPanel
	if nb == null and get_tree().current_scene:
		nb = get_tree().current_scene.get_node_or_null("%NotebookPanel") as NotebookPanel
	if nb:
		if not nb.notebook_closed.is_connected(_update_notebook_button):
			nb.notebook_closed.connect(_update_notebook_button)
		nb.open_notebook()

func _animate_entrance() -> void:
	if main_dialog == null:
		return
	main_dialog.pivot_offset = main_dialog.size / 2.0
	main_dialog.scale = Vector2(0.95, 0.95)
	main_dialog.modulate = Color(1.0, 1.0, 1.0, 0.0)
	
	var tween: Tween = create_tween().set_parallel(true)
	tween.tween_property(main_dialog, "scale", Vector2.ONE, 0.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(main_dialog, "modulate:a", 1.0, 0.16).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _on_backdrop_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if _is_typing:
			_skip_typewriter()
	elif event is InputEventScreenTouch and event.pressed:
		if _is_typing:
			_skip_typewriter()

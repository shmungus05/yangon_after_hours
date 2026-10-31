class_name DialoguePanel
extends Control

const Localization = preload("res://scripts/localization.gd")

## Cinematic and compact dialogue & interactive questioning panel for Yangon After Hours.
## Supports typewriter text, instant reveal, animated character portraits,
## decorative name badges, warm gold styling, interactive dialogue choices,
## and full interactive interrogation & evidence presentation.

signal dialogue_started(speaker: String)
signal dialogue_advanced(current_index: int, total_lines: int)
signal dialogue_closed
signal choice_selected(choice_index: int, choice_text: String)

@onready var speaker_label: Label = %SpeakerLabel
@onready var dialogue_label: Label = %DialogueLabel
@onready var page_label: Label = %PageLabel
@onready var hint_label: Label = %HintLabel
@onready var continue_button: Button = %ContinueButton
@onready var backdrop: Control = %Backdrop
@onready var dialogue_frame: PanelContainer = %DialogueBox
@onready var avatar_container: Control = %AvatarContainer
@onready var avatar_rect: TextureRect = %AvatarRect
@onready var speaker_badge: PanelContainer = %SpeakerBadge
@onready var speech_tail: Control = %SpeechTail
@onready var choices_scroll: ScrollContainer = %ChoicesScroll
@onready var choices_container: VBoxContainer = %ChoicesContainer

var _current_lines: Array[String] = []
var _current_index: int = 0
var _current_speaker: String = ""
var _current_avatar: Texture2D = null
var _current_choices: Array[String] = []

var _is_typing: bool = false
var _typewriter_tween: Tween = null
var _choice_callback: Callable = Callable()

# Interactive Questioning & Interrogation State
var _is_questioning: bool = false
var _questioning_char_id: String = ""
var _questioning_state: String = "menu" # "menu", "evidence", "answering"
var _questioning_actions: Array[Dictionary] = []

func _ready() -> void:
	visible = false
	_ensure_nodes()
	
	if continue_button and not continue_button.pressed.is_connected(_on_continue_pressed):
		continue_button.pressed.connect(_on_continue_pressed)
	if backdrop and not backdrop.gui_input.is_connected(_on_input_event):
		backdrop.gui_input.connect(_on_input_event)
	if dialogue_frame and not dialogue_frame.gui_input.is_connected(_on_input_event):
		dialogue_frame.gui_input.connect(_on_input_event)

func _ensure_nodes() -> void:
	if speaker_label == null and has_node("%SpeakerLabel"):
		speaker_label = %SpeakerLabel
	if dialogue_label == null and has_node("%DialogueLabel"):
		dialogue_label = %DialogueLabel
	if page_label == null and has_node("%PageLabel"):
		page_label = %PageLabel
	if hint_label == null and has_node("%HintLabel"):
		hint_label = %HintLabel
	if continue_button == null and has_node("%ContinueButton"):
		continue_button = %ContinueButton
	if backdrop == null and has_node("%Backdrop"):
		backdrop = %Backdrop
	if dialogue_frame == null and has_node("%DialogueBox"):
		dialogue_frame = %DialogueBox
	if avatar_container == null and has_node("%AvatarContainer"):
		avatar_container = %AvatarContainer
	if avatar_rect == null and has_node("%AvatarRect"):
		avatar_rect = %AvatarRect
	if speaker_badge == null and has_node("%SpeakerBadge"):
		speaker_badge = %SpeakerBadge
	if speech_tail == null and has_node("%SpeechTail"):
		speech_tail = %SpeechTail
	if choices_scroll == null and has_node("%ChoicesScroll"):
		choices_scroll = %ChoicesScroll
	if choices_container == null and has_node("%ChoicesContainer"):
		choices_container = %ChoicesContainer

## Shows standard dialogue lines, optionally with choices at the end.
func show_dialogue(speaker: String, lines: Array, avatar: Texture2D = null, choices: Array = []) -> void:
	_ensure_nodes()
	if lines.is_empty():
		return
	
	_is_questioning = false
	_questioning_char_id = ""
	_questioning_state = "menu"
	_questioning_actions.clear()
	
	_current_speaker = speaker
	_current_lines.clear()
	for l in lines:
		_current_lines.append(str(l))
	_current_avatar = avatar
	_current_choices.clear()
	for c in choices:
		_current_choices.append(str(c))
	_current_index = 0
	_choice_callback = Callable()
	visible = true
	
	if choices_scroll:
		choices_scroll.visible = false
	
	_animate_avatar_entrance()
	_update_ui()
	
	if continue_button and continue_button.is_inside_tree():
		continue_button.grab_focus()
	
	dialogue_started.emit(_current_speaker)

## Dedicated helper to show interactive decision choices with a prompt line.
func show_choices(speaker: String, prompt_line: String, choices: Array, avatar: Texture2D = null, on_selected: Callable = Callable()) -> void:
	_ensure_nodes()
	_is_questioning = false
	_questioning_char_id = ""
	_questioning_state = "menu"
	_questioning_actions.clear()
	
	_current_speaker = speaker
	_current_lines.clear()
	_current_lines.append(prompt_line if not prompt_line.is_empty() else "...")
	_current_avatar = avatar
	_current_choices.clear()
	for c in choices:
		_current_choices.append(str(c))
	_current_index = 0
	_choice_callback = on_selected
	visible = true
	
	_animate_avatar_entrance()
	_update_ui()
	dialogue_started.emit(_current_speaker)

## Starts an interactive questioning & interrogation session with an important character
func start_questioning(character_id: String, speaker_name: String, avatar: Texture2D = null) -> void:
	_ensure_nodes()
	_is_questioning = true
	_questioning_char_id = character_id
	_current_speaker = speaker_name
	_current_avatar = avatar
	_choice_callback = Callable()
	visible = true
	
	_animate_avatar_entrance()
	_show_question_menu()
	dialogue_started.emit(_current_speaker)

## Displays the list of available interrogation questions and options
func _show_question_menu(custom_prompt: String = "") -> void:
	_questioning_state = "menu"
	_questioning_actions.clear()
	_current_choices.clear()
	_current_index = 0
	
	var lang: String = _get_current_language()
	var game_state = get_node_or_null("/root/GameState")
	var q_data = Localization.get_character_questioning_data(_questioning_char_id, lang)
	
	# Determine character prompt / greeting
	var prompt_line: String = ""
	if not custom_prompt.is_empty():
		prompt_line = custom_prompt
	else:
		var greetings = q_data.get("greetings", {})
		if game_state and game_state.is_info_revealed("ko_zaw_true_timeline") and greetings.has("after_confession"):
			prompt_line = str(greetings["after_confession"])
		elif game_state and game_state.is_puzzle_solved("tea_order_puzzle") and greetings.has("solved"):
			prompt_line = str(greetings["solved"])
		elif greetings.has("default"):
			prompt_line = str(greetings["default"])
		else:
			prompt_line = Localization.get_ui_text("QUESTIONING_PROMPT_DEFAULT", lang)
	
	_current_lines = [prompt_line]
	
	# Add subject questions with checkmarks for asked ones
	var questions: Array = q_data.get("questions", [])
	for q in questions:
		var q_id: String = q.get("id", "")
		var is_asked: bool = game_state.is_question_asked(_questioning_char_id, q_id) if game_state else false
		var prefix: String = "✔  " if is_asked else "❓  "
		var q_text: String = q.get("text", "")
		_current_choices.append(prefix + q_text)
		_questioning_actions.append({
			"type": "question",
			"id": q_id,
			"data": q
		})
	
	# Add Present Evidence option
	_current_choices.append(Localization.get_ui_text("QUESTIONING_PRESENT_EVIDENCE", lang))
	_questioning_actions.append({
		"type": "open_evidence"
	})
	
	# Add Leave Conversation option
	_current_choices.append(Localization.get_ui_text("QUESTIONING_LEAVE", lang))
	_questioning_actions.append({
		"type": "leave"
	})
	
	_update_ui()

## Shows the evidence selection menu listing collected notebook clues
func _show_evidence_menu() -> void:
	_questioning_state = "evidence"
	_questioning_actions.clear()
	_current_choices.clear()
	_current_index = 0
	
	var lang: String = _get_current_language()
	var game_state = get_node_or_null("/root/GameState")
	var clues: Array[Dictionary] = game_state.get_clues() if game_state else []
	
	var prompt_line: String = ""
	if clues.is_empty():
		prompt_line = Localization.get_ui_text("QUESTIONING_NO_CLUES", lang)
	else:
		var prompt_fmt = Localization.get_ui_text("QUESTIONING_SELECT_CLUE", lang)
		prompt_line = prompt_fmt % _current_speaker
		for clue in clues:
			var c_id: String = clue.get("id", "")
			var c_icon: String = clue.get("icon", "🔍")
			var c_title: String = clue.get("title", c_id)
			_current_choices.append("%s  %s" % [c_icon, c_title])
			_questioning_actions.append({
				"type": "present_clue",
				"clue_id": c_id
			})
	
	# Add Back option to return to questions
	_current_choices.append(Localization.get_ui_text("QUESTIONING_BACK", lang))
	_questioning_actions.append({
		"type": "back_to_menu"
	})
	
	_current_lines = [prompt_line]
	_update_ui()

## Handles the player selecting a question to ask
func _ask_question(q_id: String, q_dict: Dictionary) -> void:
	var game_state = get_node_or_null("/root/GameState")
	if game_state:
		game_state.record_question_asked(_questioning_char_id, q_id)
	
	var lines_to_show: Array[String] = []
	var has_revealed: bool = game_state.is_info_revealed("ko_zaw_true_timeline") if game_state else false
	
	if has_revealed and q_dict.has("dialogue_revealed"):
		lines_to_show = _to_string_array(q_dict["dialogue_revealed"])
	elif q_dict.has("dialogue_initial"):
		lines_to_show = _to_string_array(q_dict["dialogue_initial"])
	elif q_dict.has("dialogue"):
		lines_to_show = _to_string_array(q_dict["dialogue"])
	
	_show_answer_lines(lines_to_show)

## Handles presenting a selected clue from the notebook to the character
func _present_clue(clue_id: String) -> void:
	var lang: String = _get_current_language()
	var game_state = get_node_or_null("/root/GameState")
	var q_data = Localization.get_character_questioning_data(_questioning_char_id, lang)
	var reactions: Dictionary = q_data.get("evidence_reactions", {})
	
	var lines_to_show: Array[String] = []
	var is_contradiction: bool = false
	
	if reactions.has(clue_id):
		var r_data = reactions[clue_id]
		is_contradiction = r_data.get("is_contradiction", false)
		if is_contradiction:
			var reveals_info: String = r_data.get("reveals_info", "")
			var already_revealed: bool = game_state.is_info_revealed(reveals_info) if game_state else false
			if not already_revealed:
				if game_state:
					game_state.record_info_revealed(reveals_info)
				lines_to_show = _to_string_array(r_data.get("dialogue_first", []))
			else:
				lines_to_show = _to_string_array(r_data.get("dialogue_repeated", r_data.get("dialogue_first", [])))
		else:
			lines_to_show = _to_string_array(r_data.get("dialogue", []))
	else:
		var def_data = reactions.get("default", {})
		lines_to_show = _to_string_array(def_data.get("dialogue", ["..."]))
	
	if game_state:
		game_state.record_evidence_presented(_questioning_char_id, clue_id, is_contradiction)
	
	_show_answer_lines(lines_to_show)

## Transitions to displaying multi-line dialogue response while keeping questioning session alive
func _show_answer_lines(lines: Array[String]) -> void:
	_questioning_state = "answering"
	_current_lines = lines if not lines.is_empty() else ["..."]
	_current_index = 0
	_current_choices.clear()
	_questioning_actions.clear()
	if choices_scroll:
		choices_scroll.visible = false
	_update_ui()

func advance_dialogue() -> void:
	if _is_typing:
		_skip_typewriter()
		return
	
	# If choices are currently active on this page, do not advance via generic click
	if _are_choices_active():
		return
	
	_current_index += 1
	if _current_index >= _current_lines.size():
		if _is_questioning and _questioning_state == "answering":
			# Answer finished! Return smoothly to question menu
			var lang = _get_current_language()
			var game_state = get_node_or_null("/root/GameState")
			var prompt: String = ""
			if game_state and game_state.is_info_revealed("ko_zaw_true_timeline"):
				var q_data = Localization.get_character_questioning_data(_questioning_char_id, lang)
				prompt = q_data.get("greetings", {}).get("after_confession", Localization.get_ui_text("QUESTIONING_PROMPT_MORE", lang))
			else:
				prompt = Localization.get_ui_text("QUESTIONING_PROMPT_MORE", lang)
			_show_question_menu(prompt)
		else:
			close_dialogue()
	else:
		_update_ui()
		dialogue_advanced.emit(_current_index, _current_lines.size())

func close_dialogue() -> void:
	if _typewriter_tween and _typewriter_tween.is_valid():
		_typewriter_tween.kill()
	_is_typing = false
	visible = false
	_current_lines = []
	_current_avatar = null
	_current_choices = []
	_current_index = 0
	_choice_callback = Callable()
	_is_questioning = false
	_questioning_char_id = ""
	_questioning_state = "menu"
	_questioning_actions.clear()
	if choices_scroll:
		choices_scroll.visible = false
	dialogue_closed.emit()

func _update_ui() -> void:
	var lang: String = _get_current_language()
	
	if speaker_label:
		speaker_label.text = _current_speaker
	if speaker_badge:
		speaker_badge.visible = not _current_speaker.is_empty()
	
	if page_label:
		if _is_questioning:
			if _questioning_state == "menu":
				page_label.text = "Interrogation" if lang == "en" else "စစ်ဆေးမေးမြန်းမှု"
			elif _questioning_state == "evidence":
				page_label.text = "Evidence" if lang == "en" else "သက်သေအထောက်အထား"
			else:
				page_label.text = "%d / %d" % [_current_index + 1, _current_lines.size()]
		else:
			page_label.text = "%d / %d" % [_current_index + 1, _current_lines.size()]
	
	if hint_label:
		if _is_questioning:
			if _questioning_state == "menu":
				hint_label.text = "Select a subject to ask or present evidence" if lang == "en" else "မေးခွန်း သို့မဟုတ် သက်သေ ရွေးချယ်ပါ"
			elif _questioning_state == "evidence":
				hint_label.text = "Select a clue from notebook to present" if lang == "en" else "တင်ပြရန် သဲလွန်စကို ရွေးချယ်ပါ"
			else:
				hint_label.text = Localization.get_ui_text("DIALOGUE_HINT", lang)
		elif _are_choices_active():
			hint_label.text = "Choose an option to proceed" if lang == "en" else "ရွေးချယ်စရာတစ်ခုကို နှိပ်ပါ"
		else:
			hint_label.text = Localization.get_ui_text("DIALOGUE_HINT", lang)
	
	if avatar_container:
		if _current_avatar != null:
			avatar_container.visible = true
			if avatar_rect:
				avatar_rect.texture = _current_avatar
			if speech_tail:
				speech_tail.visible = true
		else:
			avatar_container.visible = false
			if speech_tail:
				speech_tail.visible = false
	
	var is_last_page: bool = (_current_index == _current_lines.size() - 1)
	var has_choices_now: bool = (is_last_page and not _current_choices.is_empty())
	
	if continue_button:
		if has_choices_now:
			continue_button.visible = false
		else:
			continue_button.visible = true
			if _is_questioning and _questioning_state == "answering":
				if is_last_page:
					continue_button.text = Localization.get_ui_text("QUESTIONING_BACK", lang)
				else:
					continue_button.text = Localization.get_ui_text("DIALOGUE_CONTINUE", lang)
			else:
				if is_last_page:
					continue_button.text = "Close ✕" if lang == "en" else Localization.get_ui_text("NOTEBOOK_CLOSE", lang)
				else:
					continue_button.text = Localization.get_ui_text("DIALOGUE_CONTINUE", lang)
	
	# Start typewriter effect for current text line
	var full_text: String = _current_lines[_current_index] if _current_index < _current_lines.size() else ""
	if has_choices_now:
		_show_choices_ui()
	_start_typewriter(full_text, has_choices_now)

func _start_typewriter(full_text: String, has_choices: bool) -> void:
	if _typewriter_tween and _typewriter_tween.is_valid():
		_typewriter_tween.kill()
	
	if dialogue_label:
		dialogue_label.text = full_text
		dialogue_label.visible_characters = 0
	
	if choices_scroll:
		choices_scroll.visible = has_choices
	
	var char_count: int = full_text.length()
	if char_count == 0:
		_is_typing = false
		if dialogue_label:
			dialogue_label.visible_characters = -1
		if has_choices:
			_show_choices_ui()
		return
	
	_is_typing = true
	var typing_speed: float = 45.0 # chars per second
	var duration: float = clampf(float(char_count) / typing_speed, 0.2, 1.6)
	
	_typewriter_tween = create_tween()
	_typewriter_tween.tween_property(dialogue_label, "visible_characters", char_count, duration)
	_typewriter_tween.finished.connect(func():
		_is_typing = false
		if dialogue_label:
			dialogue_label.visible_characters = -1
		if has_choices and choices_container and choices_container.get_child_count() == 0:
			_show_choices_ui()
	)

func _skip_typewriter() -> void:
	if _typewriter_tween and _typewriter_tween.is_valid():
		_typewriter_tween.kill()
	_is_typing = false
	if dialogue_label:
		dialogue_label.visible_characters = -1
	
	var is_last_page: bool = (_current_index == _current_lines.size() - 1)
	if is_last_page and not _current_choices.is_empty() and choices_container and choices_container.get_child_count() == 0:
		_show_choices_ui()

func _animate_avatar_entrance() -> void:
	if avatar_rect == null or _current_avatar == null:
		return
	avatar_rect.pivot_offset = Vector2(66.0, 66.0)
	avatar_rect.scale = Vector2(0.86, 0.86)
	avatar_rect.modulate = Color(1.0, 1.0, 1.0, 0.0)
	
	var tween: Tween = create_tween().set_parallel(true)
	tween.tween_property(avatar_rect, "scale", Vector2.ONE, 0.22).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(avatar_rect, "modulate:a", 1.0, 0.18).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _are_choices_active() -> bool:
	var is_last_page: bool = (_current_index == _current_lines.size() - 1)
	return is_last_page and not _current_choices.is_empty() and choices_scroll and choices_scroll.visible

func _show_choices_ui() -> void:
	if choices_container == null or choices_scroll == null:
		return
	
	# Clear old choice buttons
	for child in choices_container.get_children():
		choices_container.remove_child(child)
		child.queue_free()
	
	for i in range(_current_choices.size()):
		var choice_text: String = _current_choices[i]
		var btn: Button = Button.new()
		btn.name = "ChoiceButton_%d" % i
		btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
		btn.custom_minimum_size = Vector2(0, 36)
		btn.add_theme_font_size_override("font_size", 15)
		
		var has_custom_prefix: bool = (
			choice_text.begins_with("✔") or 
			choice_text.begins_with("❓") or 
			choice_text.begins_with("💼") or 
			choice_text.begins_with("✕") or 
			choice_text.begins_with("←") or 
			choice_text.begins_with("▶") or
			choice_text.begins_with("🧾") or
			choice_text.begins_with("🕒") or
			choice_text.begins_with("📜") or
			choice_text.begins_with("⚓") or
			choice_text.begins_with("📰") or
			choice_text.begins_with("📦") or
			choice_text.begins_with("🪙")
		)
		btn.text = choice_text if has_custom_prefix else ("▶  " + choice_text)
		
		# Normal style: sleek dark panel with subtle gold border
		var normal_style = StyleBoxFlat.new()
		normal_style.corner_radius_top_left = 4
		normal_style.corner_radius_top_right = 4
		normal_style.corner_radius_bottom_right = 4
		normal_style.corner_radius_bottom_left = 4
		normal_style.content_margin_left = 14
		normal_style.content_margin_right = 14
		normal_style.content_margin_top = 4
		normal_style.content_margin_bottom = 4
		normal_style.border_width_left = 1
		normal_style.border_width_top = 1
		normal_style.border_width_right = 1
		normal_style.border_width_bottom = 1
		
		if choice_text.begins_with("✔"):
			normal_style.bg_color = Color(0.06, 0.08, 0.12, 0.85)
			normal_style.border_color = Color(0.55, 0.65, 0.55, 0.4)
			btn.add_theme_color_override("font_color", Color(0.72, 0.82, 0.75, 0.9))
		elif choice_text.begins_with("💼"):
			normal_style.bg_color = Color(0.10, 0.12, 0.18, 0.95)
			normal_style.border_color = Color(0.96, 0.78, 0.28, 0.75)
			btn.add_theme_color_override("font_color", Color(0.98, 0.86, 0.45, 1.0))
		elif choice_text.begins_with("✕"):
			normal_style.bg_color = Color(0.08, 0.08, 0.11, 0.85)
			normal_style.border_color = Color(0.70, 0.35, 0.35, 0.4)
			btn.add_theme_color_override("font_color", Color(0.85, 0.65, 0.65, 0.9))
		else:
			normal_style.bg_color = Color(0.08, 0.10, 0.16, 0.88)
			normal_style.border_color = Color(0.88, 0.72, 0.32, 0.45)
			btn.add_theme_color_override("font_color", Color(0.94, 0.95, 0.98, 1.0))
		
		btn.add_theme_stylebox_override("normal", normal_style)
		
		# Hover / Focus style: radiant warm gold bar with crisp dark text
		var hover_style = StyleBoxFlat.new()
		hover_style.bg_color = Color(0.96, 0.78, 0.22, 1.0)
		hover_style.corner_radius_top_left = 4
		hover_style.corner_radius_top_right = 4
		hover_style.corner_radius_bottom_right = 4
		hover_style.corner_radius_bottom_left = 4
		hover_style.content_margin_left = 14
		hover_style.content_margin_right = 14
		hover_style.content_margin_top = 4
		hover_style.content_margin_bottom = 4
		btn.add_theme_stylebox_override("hover", hover_style)
		btn.add_theme_stylebox_override("focus", hover_style)
		btn.add_theme_color_override("font_hover_color", Color(0.08, 0.08, 0.10, 1.0))
		btn.add_theme_color_override("font_focus_color", Color(0.08, 0.08, 0.10, 1.0))
		
		# Pressed style
		var pressed_style = StyleBoxFlat.new()
		pressed_style.bg_color = Color(0.85, 0.68, 0.18, 1.0)
		pressed_style.corner_radius_top_left = 4
		pressed_style.corner_radius_top_right = 4
		pressed_style.corner_radius_bottom_right = 4
		pressed_style.corner_radius_bottom_left = 4
		pressed_style.content_margin_left = 14
		pressed_style.content_margin_right = 14
		pressed_style.content_margin_top = 4
		pressed_style.content_margin_bottom = 4
		btn.add_theme_stylebox_override("pressed", pressed_style)
		btn.add_theme_color_override("font_pressed_color", Color(0.08, 0.08, 0.10, 1.0))
		
		var idx: int = i
		var c_txt: String = choice_text
		btn.pressed.connect(_on_choice_pressed.bind(idx, c_txt))
		choices_container.add_child(btn)
	
	choices_scroll.visible = true
	if continue_button:
		continue_button.visible = false
	
	# Auto-focus the first choice for keyboard/gamepad navigation
	if choices_container.get_child_count() > 0:
		var first_btn = choices_container.get_child(0) as Button
		if first_btn and first_btn.is_inside_tree():
			first_btn.grab_focus()

func _on_choice_pressed(idx: int, text: String) -> void:
	choice_selected.emit(idx, text)
	
	if _is_questioning:
		if idx >= 0 and idx < _questioning_actions.size():
			var action = _questioning_actions[idx]
			match action.get("type", ""):
				"leave":
					close_dialogue()
				"open_evidence":
					_show_evidence_menu()
				"back_to_menu":
					var lang = _get_current_language()
					_show_question_menu(Localization.get_ui_text("QUESTIONING_PROMPT_MORE", lang))
				"question":
					_ask_question(action.get("id", ""), action.get("data", {}))
				"present_clue":
					_present_clue(action.get("clue_id", ""))
		return
	
	if _choice_callback.is_valid():
		_choice_callback.call(idx, text)
	close_dialogue()

func _on_continue_pressed() -> void:
	advance_dialogue()

func _on_input_event(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		advance_dialogue()
	elif event is InputEventScreenTouch and event.pressed:
		advance_dialogue()

func _get_current_language() -> String:
	if is_inside_tree():
		var game_state = get_node_or_null("/root/GameState")
		if game_state and game_state.has_method("get_language"):
			return game_state.get_language()
	return "my"

func _to_string_array(src: Array) -> Array[String]:
	var result: Array[String] = []
	for item in src:
		result.append(str(item))
	return result

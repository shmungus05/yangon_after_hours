class_name DialoguePanel
extends Control

## Reusable narrative and inspection dialogue panel for Yangon After Hours.
## Displays character avatar portrait, speaker name, dialogue text, and a touch-friendly Continue button.

signal dialogue_started(speaker: String)
signal dialogue_advanced(current_index: int, total_lines: int)
signal dialogue_closed

@onready var speaker_label: Label = %SpeakerLabel
@onready var dialogue_label: Label = %DialogueLabel
@onready var page_label: Label = %PageLabel
@onready var continue_button: Button = %ContinueButton
@onready var backdrop: Control = %Backdrop
@onready var dialogue_frame: PanelContainer = %DialogueBox
@onready var avatar_container: Control = %AvatarContainer
@onready var avatar_rect: TextureRect = %AvatarRect

var _current_lines: Array[String] = []
var _current_index: int = 0
var _current_speaker: String = ""
var _current_avatar: Texture2D = null

func _ready() -> void:
	visible = false
	_ensure_nodes()
	if continue_button and not continue_button.pressed.is_connected(advance_dialogue):
		continue_button.pressed.connect(advance_dialogue)
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

func show_dialogue(speaker: String, lines: Array[String], avatar: Texture2D = null) -> void:
	_ensure_nodes()
	if lines.is_empty():
		return
	
	_current_speaker = speaker
	_current_lines = lines.duplicate() # Duplicate array to prevent clearing caller's reference on close
	_current_avatar = avatar
	_current_index = 0
	visible = true
	
	_update_ui()
	if continue_button and continue_button.is_inside_tree():
		continue_button.grab_focus()
	
	dialogue_started.emit(_current_speaker)

func advance_dialogue() -> void:
	_current_index += 1
	if _current_index >= _current_lines.size():
		close_dialogue()
	else:
		_update_ui()
		dialogue_advanced.emit(_current_index, _current_lines.size())

func close_dialogue() -> void:
	visible = false
	_current_lines = []
	_current_avatar = null
	_current_index = 0
	dialogue_closed.emit()

func _update_ui() -> void:
	if speaker_label:
		speaker_label.text = _current_speaker
	
	if dialogue_label:
		dialogue_label.text = _current_lines[_current_index]
	
	if page_label:
		page_label.text = "%d / %d" % [_current_index + 1, _current_lines.size()]
	
	if avatar_container:
		if _current_avatar != null:
			avatar_container.visible = true
			if avatar_rect:
				avatar_rect.texture = _current_avatar
		else:
			avatar_container.visible = false
	
	if continue_button:
		if _current_index == _current_lines.size() - 1:
			continue_button.text = "Close ✕"
		else:
			continue_button.text = "Continue ▶"

func _on_input_event(event: InputEvent) -> void:
	# Support desktop mouse clicks and mobile touch taps
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		advance_dialogue()
	elif event is InputEventScreenTouch and event.pressed:
		advance_dialogue()

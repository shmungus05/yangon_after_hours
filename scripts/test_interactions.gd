extends SceneTree

const Localization = preload("res://scripts/localization.gd")

func _initialize() -> void:
	_run_tests()

func _run_tests() -> void:
	print("--- BEGIN POINT-AND-CLICK INTERACTION SYSTEM TESTS ---")
	
	var game_state = root.get_node_or_null("GameState")
	if not game_state:
		var gs_script = load("res://scripts/game_state.gd")
		game_state = Node.new()
		game_state.name = "GameState"
		game_state.set_script(gs_script)
		root.add_child(game_state)
	game_state.set_language("en")
	
	# Test 1: Isolated DialoguePanel
	var dp_scene: PackedScene = load("res://scenes/components/dialogue_panel.tscn")
	assert(dp_scene != null, "Failed to load DialoguePanel scene")
	var dp: DialoguePanel = dp_scene.instantiate()
	root.add_child(dp)
	await process_frame
	
	assert(dp.visible == false, "DialoguePanel should start hidden")
	dp.show_dialogue("Test Speaker", ["Line 1", "Line 2"])
	assert(dp.visible == true, "DialoguePanel should be visible")
	assert(dp.speaker_label.text == "Test Speaker", "Speaker text mismatch")
	assert(dp.dialogue_label.text == "Line 1", "Line 1 mismatch")
	assert(dp.continue_button.text == "Continue ▶", "Continue button mismatch")
	
	# Test typewriter skip
	assert(dp._is_typing == true or dp.dialogue_label.visible_characters == -1, "Typewriter should be active or complete")
	dp._skip_typewriter()
	assert(dp._is_typing == false, "Typewriter should finish after skip")
	assert(dp.dialogue_label.visible_characters == -1, "All characters should be revealed after skip")
	
	dp.advance_dialogue()
	assert(dp.dialogue_label.text == "Line 2", "Line 2 mismatch")
	assert(dp.continue_button.text == "Close ✕", "Close button mismatch")
	
	# First click skips typing for Line 2
	dp.advance_dialogue()
	assert(dp._is_typing == false, "Typewriter for Line 2 should be skipped on first advance")
	# Second click closes the dialogue
	dp.advance_dialogue()
	assert(dp.visible == false, "DialoguePanel should be hidden after close")
	
	# Test 1b: Dialogue Choices Support
	var choice_result: Dictionary = {"index": -1, "text": ""}
	dp.choice_selected.connect(func(idx, txt):
		choice_result["index"] = idx
		choice_result["text"] = txt
	)
	dp.show_choices("Detective", "What do you want to inspect?", ["1. The Abandoned Table", "2. Ask Ko Zaw"])
	assert(dp.visible == true, "DialoguePanel should be visible for choices")
	assert(dp.choices_scroll.visible == true, "Choices scroll should be visible")
	assert(dp.choices_container.get_child_count() == 2, "Expected 2 choice buttons")
	
	# Simulate clicking choice 0
	var first_choice = dp.choices_container.get_child(0) as Button
	assert(first_choice != null, "First choice button should exist")
	first_choice.pressed.emit()
	assert(choice_result["index"] == 0, "Choice 0 should be selected")
	assert(choice_result["text"] == "1. The Abandoned Table", "Choice text mismatch")
	assert(dp.visible == false, "DialoguePanel should close after choice selection")
	
	dp.queue_free()
	await process_frame
	print("✔ Test 1: DialoguePanel isolated unit test, typewriter skip, and choices passed.")
	
	# Test 2: Location scenes
	var locations: Array[String] = [
		"res://scenes/locations/downtown.tscn",
		"res://scenes/locations/tea_shop.tscn",
		"res://scenes/locations/market.tscn"
	]
	
	for loc_path in locations:
		var scene: PackedScene = load(loc_path)
		assert(scene != null, "Failed to load location: " + loc_path)
		var loc_node: Control = scene.instantiate()
		root.add_child(loc_node)
		await process_frame
		
		var loc_dp: DialoguePanel = loc_node.get_node("%DialoguePanel")
		assert(loc_dp != null, "DialoguePanel missing in " + loc_path)
		assert(loc_dp.visible == false, "DialoguePanel should start hidden in " + loc_path)
		
		var hotspot_count: int = 0
		for child in loc_node.find_children("*", "InteractableHotspot", true, false):
			if child is InteractableHotspot:
				if child.name in ["TeaOrdersHotspot", "MarketNotebookHotspot", "DeliveryHotspot"] or not child.inspection_target_id.is_empty() or not child.character_id.is_empty():
					continue # Tested specifically in respective puzzle/inspection/questioning test suites
				hotspot_count += 1
				# Simulate clicking or tapping the hotspot
				child.pressed.emit()
				await process_frame
				
				var h_data = Localization.get_hotspot_data(child.name, "en")
				var expected_speaker = h_data.get("speaker", child.speaker_name)
				var expected_first_line = str(h_data.get("dialogue_default", child.dialogue_lines)[0])
				assert(loc_dp.speaker_label.text == expected_speaker, "Speaker label mismatch: " + loc_dp.speaker_label.text)
				assert(loc_dp.dialogue_label.text == expected_first_line, "First line mismatch: " + loc_dp.dialogue_label.text)
				
				# Advance through all lines until closed
				while loc_dp.visible:
					loc_dp.advance_dialogue()
					await process_frame
				
				assert(loc_dp.visible == false, "Dialogue should close after advancing through all lines")
		
		assert(hotspot_count >= 3, "Expected at least 3 hotspots in " + loc_path + ", found: " + str(hotspot_count))
		print("✔ Test 2: Location " + loc_path + " verified with " + str(hotspot_count) + " hotspots.")
		loc_node.queue_free()
		await process_frame
	
	print("--- ALL POINT-AND-CLICK INTERACTION SYSTEM TESTS PASSED ---")
	quit(0)

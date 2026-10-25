extends SceneTree

func _initialize() -> void:
	_run_tests()

func _run_tests() -> void:
	print("--- BEGIN POINT-AND-CLICK INTERACTION SYSTEM TESTS ---")
	
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
	
	dp.advance_dialogue()
	assert(dp.dialogue_label.text == "Line 2", "Line 2 mismatch")
	assert(dp.continue_button.text == "Close ✕", "Close button mismatch")
	
	dp.advance_dialogue()
	assert(dp.visible == false, "DialoguePanel should be hidden after close")
	dp.queue_free()
	await process_frame
	print("✔ Test 1: DialoguePanel isolated unit test passed.")
	
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
				if child.name == "TeaOrdersHotspot":
					continue # Tested specifically in test_tea_puzzle.gd
				hotspot_count += 1
				# Simulate clicking or tapping the hotspot
				child.pressed.emit()
				await process_frame
				
				assert(loc_dp.visible == true, "Dialogue should open when hotspot clicked: " + child.display_name)
				assert(loc_dp.speaker_label.text == child.speaker_name, "Speaker label mismatch: " + loc_dp.speaker_label.text)
				assert(loc_dp.dialogue_label.text == child.dialogue_lines[0], "First line mismatch: " + loc_dp.dialogue_label.text)
				
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

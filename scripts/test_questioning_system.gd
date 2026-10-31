extends SceneTree

const Localization = preload("res://scripts/localization.gd")

## Comprehensive automated test suite for character questioning & interrogation system in Yangon After Hours.
## Validates:
## 1. DialoguePanel questioning mode displays interactive questions instead of simple Continue button.
## 2. Asking specific subjects and tracking asked questions with checkmarks.
## 3. Revisiting previously asked questions.
## 4. Evidence menu behavior with empty notebook and with collected clues.
## 5. Non-contradiction clue responses.
## 6. Contradiction clue presentation (tea receipt timestamp):
##    - Ko Zaw confesses timeline contradiction (11:45 PM instead of midnight).
##    - Unlocks "ko_zaw_true_timeline" info key.
##    - Commotion question dynamically switches to updated honest testimony.
##    - Repeated evidence presentation gives concise reaction without repeating confession.
## 7. Direct scene integration with TeaShop and TeaMasterHotspot.
## 8. Bilingual English and Burmese functionality.

func _initialize() -> void:
	_run_tests()

func _run_tests() -> void:
	print("--- BEGIN CHARACTER QUESTIONING SYSTEM TESTS ---")
	
	var game_state = root.get_node_or_null("GameState")
	if not game_state:
		var gs_script = load("res://scripts/game_state.gd")
		game_state = Node.new()
		game_state.name = "GameState"
		game_state.set_script(gs_script)
		root.add_child(game_state)
	
	game_state.reset_game()
	game_state.set_language("en")
	
	# ==========================================
	# Test 1: Isolated DialoguePanel Questioning
	# ==========================================
	var dp_scene: PackedScene = load("res://scenes/components/dialogue_panel.tscn")
	assert(dp_scene != null, "Failed to load DialoguePanel scene")
	var dp: DialoguePanel = dp_scene.instantiate()
	root.add_child(dp)
	await process_frame
	
	dp.start_questioning("ko_zaw", "✦ Tea Master Ko Zaw")
	await process_frame
	
	assert(dp.visible == true, "DialoguePanel must be visible in questioning mode")
	assert(dp._is_questioning == true, "_is_questioning flag should be true")
	assert(dp.choices_scroll.visible == true, "Choices scroll must be visible for question list")
	assert(dp.continue_button.visible == false, "Continue button should be hidden on question menu")
	
	# Verify available options: 3 questions + Present Evidence + Leave Conversation = 5 choices
	var choice_count: int = dp.choices_container.get_child_count()
	assert(choice_count == 5, "Expected 5 choices in Ko Zaw questioning menu, got: %d" % choice_count)
	
	var q0_btn = dp.choices_container.get_child(0) as Button
	assert(q0_btn.text.begins_with("❓"), "Unasked question should have '❓' prefix")
	assert("commotion" in q0_btn.text.to_lower(), "First question should be about the commotion")
	print("✔ Test 1: Questioning menu initialized with 5 choices and '❓' prefixes.")
	
	# ==========================================
	# Test 2: Asking a subject question (Initial testimony)
	# ==========================================
	# Ask question 0: "What happened during the late-night commotion?"
	q0_btn.pressed.emit()
	await process_frame
	
	assert(game_state.is_question_asked("ko_zaw", "q_commotion") == true, "q_commotion should be marked as asked in GameState")
	assert(dp._questioning_state == "answering", "State should transition to 'answering'")
	assert(dp.continue_button.visible == true, "Continue button should appear for answer lines")
	dp._skip_typewriter()
	assert("midnight" in dp.dialogue_label.text.to_lower(), "Initial testimony should claim stranger bolted around midnight")
	
	# Advance through answer line 2
	dp.advance_dialogue()
	await process_frame
	dp._skip_typewriter()
	assert("12:00 AM" in dp.dialogue_label.text or "midnight" in dp.dialogue_label.text.to_lower(), "Line 2 should reiterate midnight claim")
	assert(dp.continue_button.text == "← Back to Questions", "Last line of answer should offer '← Back to Questions'")
	
	# Advance to return to question menu
	dp.advance_dialogue()
	await process_frame
	
	assert(dp._questioning_state == "menu", "Should return to questioning menu")
	var q0_btn_after = dp.choices_container.get_child(0) as Button
	assert(q0_btn_after.text.begins_with("✔"), "Asked question must now display '✔' prefix")
	print("✔ Test 2: Asked question displays initial midnight claim and updates to '✔' prefix.")
	
	# ==========================================
	# Test 3: Revisiting previously asked question
	# ==========================================
	q0_btn_after.pressed.emit()
	await process_frame
	assert(dp._questioning_state == "answering", "Revisiting question should reopen answer")
	dp._skip_typewriter()
	assert("midnight" in dp.dialogue_label.text.to_lower(), "Revisiting should show the initial testimony again before evidence is presented")
	
	# Advance through line 2 and return to menu
	dp.advance_dialogue()
	await process_frame
	dp._skip_typewriter()
	dp.advance_dialogue()
	await process_frame
	assert(dp._questioning_state == "menu", "Returned to questioning menu after revisiting")
	print("✔ Test 3: Player can successfully revisit previously asked questions.")
	
	# ==========================================
	# Test 4: Evidence menu with empty notebook
	# ==========================================
	var present_btn = dp.choices_container.get_child(3) as Button # Present Evidence...
	assert("evidence" in present_btn.text.to_lower(), "Button 3 should be Present Evidence")
	present_btn.pressed.emit()
	await process_frame
	
	assert(dp._questioning_state == "evidence", "Should transition to evidence menu state")
	dp._skip_typewriter()
	assert("haven't collected any clues" in dp.dialogue_label.text.to_lower(), "Should inform player that notebook is empty")
	assert(dp.choices_container.get_child_count() == 1, "Only 'Back to Questions' should be present when no clues are held")
	
	# Click Back to Questions
	var back_btn = dp.choices_container.get_child(0) as Button
	back_btn.pressed.emit()
	await process_frame
	assert(dp._questioning_state == "menu", "Back button should return to questioning menu")
	print("✔ Test 4: Evidence menu with empty notebook handled gracefully.")
	
	# ==========================================
	# Test 5: Presenting non-contradiction clue
	# ==========================================
	game_state.add_clue("tea_clock_stopped_time", "Stopped Clock at 11:45 PM", "Wall clock stopped at 11:45 PM", "Lucky Tea Shop")
	
	present_btn = dp.choices_container.get_child(3) as Button
	present_btn.pressed.emit()
	await process_frame
	
	assert(dp.choices_container.get_child_count() == 2, "Expected 1 clue button + 1 Back button")
	var clock_btn = dp.choices_container.get_child(0) as Button
	assert("clock" in clock_btn.text.to_lower(), "First clue button should be the stopped clock")
	clock_btn.pressed.emit()
	await process_frame
	
	dp._skip_typewriter()
	assert("antique teak clock" in dp.dialogue_label.text.to_lower(), "Ko Zaw should comment on the clock")
	assert(game_state.is_info_revealed("ko_zaw_true_timeline") == false, "Clock clue alone should not reveal the timeline contradiction")
	
	# Return to question menu
	dp.advance_dialogue()
	await process_frame
	assert(dp._questioning_state == "menu", "Returned to questioning menu")
	print("✔ Test 5: Presenting standard clue triggers character dialogue without contradiction.")
	
	# ==========================================
	# Test 6: Presenting contradiction clue (Receipt timestamp)
	# ==========================================
	game_state.add_clue("tea_receipt_timestamp", "Late-Night Order Timestamp", "Stamped 11:42 PM", "Lucky Tea Shop")
	
	present_btn = dp.choices_container.get_child(3) as Button
	present_btn.pressed.emit()
	await process_frame
	
	# Clues: clock (idx 0), receipt (idx 1), Back (idx 2)
	assert(dp.choices_container.get_child_count() == 3, "Expected 2 clue buttons + Back button")
	var receipt_btn = dp.choices_container.get_child(1) as Button
	assert("receipt" in receipt_btn.text.to_lower() or "timestamp" in receipt_btn.text.to_lower(), "Second clue button should be the receipt")
	receipt_btn.pressed.emit()
	await process_frame
	
	# Check confession dialogue line 1
	dp._skip_typewriter()
	assert("11:42 PM" in dp.dialogue_label.text, "Ko Zaw should notice the 11:42 PM timestamp on the receipt")
	assert(game_state.is_info_revealed("ko_zaw_true_timeline") == true, "ko_zaw_true_timeline info key must be unlocked!")
	
	# Advance through confession lines
	dp.advance_dialogue()
	await process_frame
	dp._skip_typewriter()
	assert("caught me" in dp.dialogue_label.text.to_lower(), "Ko Zaw confesses he lied about midnight earlier")
	
	dp.advance_dialogue()
	await process_frame
	dp._skip_typewriter()
	assert("11:45 PM" in dp.dialogue_label.text, "Reveals true departure time of 11:45 PM")
	
	dp.advance_dialogue()
	await process_frame
	dp._skip_typewriter()
	assert("Ko Aung" in dp.dialogue_label.text, "Reveals stranger asked if Ko Aung's taxi was waiting outside")
	
	# Return to question menu
	dp.advance_dialogue()
	await process_frame
	assert(dp._questioning_state == "menu", "Returned to question menu after confession")
	print("✔ Test 6: Presenting receipt exposes contradiction, unlocks true timeline, and reveals taxi lead.")
	
	# ==========================================
	# Test 7: Asking commotion question AFTER confession gives updated honest testimony
	# ==========================================
	var q0_btn_revealed = dp.choices_container.get_child(0) as Button
	q0_btn_revealed.pressed.emit()
	await process_frame
	
	dp._skip_typewriter()
	assert("didn't leave at midnight" in dp.dialogue_label.text.to_lower(), "Ko Zaw should acknowledge his corrected testimony")
	
	dp.advance_dialogue()
	await process_frame
	dp._skip_typewriter()
	assert("11:45 PM" in dp.dialogue_label.text and "Ko Aung" in dp.dialogue_label.text, "Updated testimony should confirm 11:45 PM departure and Ko Aung's taxi")
	
	dp.advance_dialogue()
	await process_frame
	assert(dp._questioning_state == "menu", "Returned to menu")
	print("✔ Test 7: Commotion question dynamically provides updated honest testimony post-confession.")
	
	# ==========================================
	# Test 8: Repeated presentation of receipt gives concise non-repetitive response
	# ==========================================
	present_btn = dp.choices_container.get_child(3) as Button
	present_btn.pressed.emit()
	await process_frame
	
	receipt_btn = dp.choices_container.get_child(1) as Button
	receipt_btn.pressed.emit()
	await process_frame
	
	dp._skip_typewriter()
	assert("already told you the honest truth" in dp.dialogue_label.text.to_lower(), "Repeated evidence should give concise response without repeating full confession")
	assert(dp._current_lines.size() == 1, "Repeated evidence should only have 1 dialogue line")
	
	dp.advance_dialogue()
	await process_frame
	assert(dp._questioning_state == "menu", "Returned to menu")
	print("✔ Test 8: Repeated evidence presentation is concise and non-repetitive.")
	
	# Test Leave Conversation
	var leave_btn = dp.choices_container.get_child(4) as Button
	assert("leave" in leave_btn.text.to_lower(), "Button 4 should be Leave Conversation")
	leave_btn.pressed.emit()
	await process_frame
	assert(dp.visible == false, "DialoguePanel should close when player chooses Leave Conversation")
	
	dp.queue_free()
	await process_frame
	
	# ==========================================
	# Test 9: TeaShop Scene Integration with TeaMasterHotspot
	# ==========================================
	var tea_scene: PackedScene = load("res://scenes/locations/tea_shop.tscn")
	assert(tea_scene != null, "Failed to load tea_shop.tscn")
	var tea_node = tea_scene.instantiate()
	root.add_child(tea_node)
	await process_frame
	
	var tm_hotspot: InteractableHotspot = tea_node.get_node("%TeaMasterHotspot")
	var loc_dp: DialoguePanel = tea_node.get_node("%DialoguePanel")
	assert(tm_hotspot != null, "TeaMasterHotspot must exist")
	assert(tm_hotspot.character_id == "ko_zaw", "TeaMasterHotspot character_id must be 'ko_zaw'")
	assert(loc_dp != null, "DialoguePanel must exist in tea_shop")
	assert(loc_dp.visible == false, "DialoguePanel should start hidden")
	
	# Click TeaMasterHotspot
	tm_hotspot.pressed.emit()
	await process_frame
	
	assert(loc_dp.visible == true, "DialoguePanel must open when clicking Tea Master")
	assert(loc_dp._is_questioning == true, "Must open in questioning mode")
	assert(loc_dp.choices_container.get_child_count() == 5, "Must display question menu with 5 options")
	
	loc_dp.close_dialogue()
	await process_frame
	assert(loc_dp.visible == false, "DialoguePanel closes cleanly")
	
	tea_node.queue_free()
	await process_frame
	print("✔ Test 9: TeaShop scene integration and TeaMasterHotspot click verified.")
	
	# ==========================================
	# Test 10: Bilingual Burmese (Myanmar) Language Support
	# ==========================================
	game_state.reset_game()
	game_state.set_language("my")
	
	var dp_my: DialoguePanel = dp_scene.instantiate()
	root.add_child(dp_my)
	await process_frame
	
	dp_my.start_questioning("ko_zaw", "✦ လက်ဖက်ရည်ဆရာ ကိုဇော်")
	await process_frame
	
	assert(dp_my.visible == true, "Burmese dialogue panel should be visible")
	var my_q0 = dp_my.choices_container.get_child(0) as Button
	assert(my_q0.text.begins_with("❓"), "Burmese unasked question should have '❓' prefix")
	assert("မေးမြန်းမည်" in my_q0.text, "Burmese question text mismatch")
	
	var my_ev_btn = dp_my.choices_container.get_child(3) as Button
	assert("တင်ပြမည်" in my_ev_btn.text, "Burmese evidence button mismatch")
	
	var my_leave_btn = dp_my.choices_container.get_child(4) as Button
	assert("ပြီးဆုံးမည်" in my_leave_btn.text, "Burmese leave button mismatch")
	
	# Ask question in Burmese
	my_q0.pressed.emit()
	await process_frame
	assert(game_state.is_question_asked("ko_zaw", "q_commotion") == true, "Burmese question tracked in GameState")
	dp_my._skip_typewriter()
	assert("သန်းခေါင်ယံ" in dp_my.dialogue_label.text, "Burmese initial testimony should mention midnight")
	
	dp_my.close_dialogue()
	await process_frame
	dp_my.queue_free()
	await process_frame
	print("✔ Test 10: Complete Burmese language support verified.")
	
	print("--- ALL CHARACTER QUESTIONING SYSTEM TESTS PASSED ---")
	quit(0)

extends SceneTree

const Localization = preload("res://scripts/localization.gd")
const InspectionPanel = preload("res://scripts/inspection_panel.gd")

## Automated test suite for the Reusable Object Inspection System.
## Verifies close-up views, clickable sub-hotspots, clue collection,
## duplicate prevention, notebook synchronization, and tea shop scene integration.

func _init() -> void:
	_run_tests()

func _run_tests() -> void:
	print("--- BEGIN OBJECT INSPECTION SYSTEM TESTS ---")
	
	var game_state = root.get_node_or_null("GameState")
	if not game_state:
		var gs_script = load("res://scripts/game_state.gd")
		game_state = Node.new()
		game_state.name = "GameState"
		game_state.set_script(gs_script)
		root.add_child(game_state)
	
	game_state.reset_game()
	game_state.set_language("en")
	
	# =========================================================================
	# TEST 1: Isolated InspectionPanel Component & Notebook Inspection
	# =========================================================================
	var panel_scene: PackedScene = load("res://scenes/components/inspection_panel.tscn")
	assert(panel_scene != null, "Failed to load InspectionPanel scene")
	var panel: InspectionPanel = panel_scene.instantiate()
	root.add_child(panel)
	await process_frame
	
	assert(panel.visible == false, "InspectionPanel must start hidden")
	
	var signals_state = {
		"opened_obj": "",
		"collected_clue_id": "",
		"closed_emitted": false
	}
	panel.inspection_opened.connect(func(oid): signals_state["opened_obj"] = oid)
	panel.clue_collected.connect(func(cid): signals_state["collected_clue_id"] = cid)
	panel.inspection_closed.connect(func(): signals_state["closed_emitted"] = true)
	
	panel.open_inspection("tea_notebook")
	assert(panel.visible == true, "Panel should be visible after open_inspection")
	assert(signals_state["opened_obj"] == "tea_notebook", "Opened object id mismatch: " + signals_state["opened_obj"])
	assert("Abandoned Leather Notebook" in panel.object_title_label.text, "Title mismatch: " + panel.object_title_label.text)
	assert(panel.object_texture.texture != null, "ObjectTexture must be loaded")
	assert(panel.hotspots_container.get_child_count() == 3, "Expected 3 inspection areas on notebook")
	
	# Test area 0: Brass Clasp (no clue)
	var clasp_btn = panel.hotspots_container.get_child(0) as Button
	assert(clasp_btn != null, "Clasp button should exist")
	clasp_btn.pressed.emit()
	assert("Brass Schooner Clasp" in panel.observation_title_label.text, "Observation title mismatch")
	assert("three-masted schooner" in panel.observation_label.text, "Observation description mismatch")
	assert(panel.clue_notice_badge.visible == false, "Clasp should not yield a clue")
	
	# Test area 1: Cipher Page (yields clue: tea_notebook_cipher)
	assert(not game_state.has_clue("tea_notebook_cipher"), "Should not have notebook clue before inspection")
	var initial_clue_count: int = game_state.get_clue_count()
	
	var cipher_btn = panel.hotspots_container.get_child(1) as Button
	assert(cipher_btn != null, "Cipher button should exist")
	cipher_btn.pressed.emit()
	
	assert(signals_state["collected_clue_id"] == "tea_notebook_cipher", "Clue collected signal mismatch")
	assert(game_state.has_clue("tea_notebook_cipher") == true, "GameState must have recorded tea_notebook_cipher")
	assert(game_state.get_clue_count() == initial_clue_count + 1, "Clue count should have incremented")
	assert(panel.clue_notice_badge.visible == true, "Clue notice badge should be visible")
	assert("NEW CLUE RECORDED" in panel.clue_notice_label.text, "Clue notice text mismatch")
	
	# Test duplicate prevention on revisit
	cipher_btn.pressed.emit()
	assert(game_state.get_clue_count() == initial_clue_count + 1, "Revisiting object must not add duplicate clues")
	assert("Already documented" in panel.clue_notice_label.text, "Clue notice should indicate already documented")
	
	# Test close inspection
	panel.close_inspection()
	assert(panel.visible == false, "Panel should be hidden after close_inspection")
	assert(signals_state["closed_emitted"] == true, "inspection_closed signal must be emitted")
	print("✔ Test 1: Isolated InspectionPanel unit test & notebook clue collection passed.")
	
	# =========================================================================
	# TEST 2: Inspecting Receipt and Wall Clock
	# =========================================================================
	# Receipt inspection
	panel.open_inspection("tea_receipt")
	assert(panel.visible == true, "Receipt inspection should open")
	assert("Receipt" in panel.object_title_label.text, "Receipt title mismatch")
	assert(panel.hotspots_container.get_child_count() == 3, "Expected 3 receipt inspection areas")
	
	# Inspect timestamp area (child 1)
	var timestamp_btn = panel.hotspots_container.get_child(1) as Button
	timestamp_btn.pressed.emit()
	assert(game_state.has_clue("tea_receipt_timestamp") == true, "Must discover tea_receipt_timestamp")
	panel.close_inspection()
	assert(panel.visible == false, "Panel should close after receipt inspection")
	
	# Wall clock inspection
	panel.open_inspection("tea_clock")
	assert(panel.visible == true, "Clock inspection should open")
	assert("Clock" in panel.object_title_label.text, "Clock title mismatch")
	assert(panel.hotspots_container.get_child_count() == 3, "Expected 3 clock inspection areas")
	
	# Inspect frozen hands area (child 0)
	var hands_btn = panel.hotspots_container.get_child(0) as Button
	hands_btn.pressed.emit()
	assert(game_state.has_clue("tea_clock_stopped_time") == true, "Must discover tea_clock_stopped_time")
	panel.close_inspection()
	assert(panel.visible == false, "Panel should close after clock inspection")
	
	panel.queue_free()
	await process_frame
	print("✔ Test 2: Receipt and Wall Clock inspection & clues verified.")
	
	# =========================================================================
	# TEST 3: Tea Shop Location Integration
	# =========================================================================
	var tea_shop_scene = load("res://scenes/locations/tea_shop.tscn").instantiate()
	root.add_child(tea_shop_scene)
	await process_frame
	
	var loc_inspect_panel: InspectionPanel = tea_shop_scene.get_node("%InspectionPanel")
	assert(loc_inspect_panel != null, "InspectionPanel must exist in tea_shop.tscn")
	assert(loc_inspect_panel.visible == false, "InspectionPanel must start hidden in tea_shop")
	
	var nb_hotspot: InteractableHotspot = tea_shop_scene.get_node("%NotebookHotspot")
	var rc_hotspot: InteractableHotspot = tea_shop_scene.get_node("%ReceiptHotspot")
	var ck_hotspot: InteractableHotspot = tea_shop_scene.get_node("%ClockHotspot")
	
	assert(nb_hotspot != null, "NotebookHotspot must exist in tea_shop.tscn")
	assert(rc_hotspot != null, "ReceiptHotspot must exist in tea_shop.tscn")
	assert(ck_hotspot != null, "ClockHotspot must exist in tea_shop.tscn")
	
	assert(nb_hotspot.inspection_target_id == "tea_notebook", "NotebookHotspot target ID mismatch")
	assert(rc_hotspot.inspection_target_id == "tea_receipt", "ReceiptHotspot target ID mismatch")
	assert(ck_hotspot.inspection_target_id == "tea_clock", "ClockHotspot target ID mismatch")
	
	# Simulate player clicking NotebookHotspot in the tea shop
	nb_hotspot.interact()
	await process_frame
	assert(loc_inspect_panel.visible == true, "Clicking NotebookHotspot must open InspectionPanel")
	assert("Abandoned Leather Notebook" in loc_inspect_panel.object_title_label.text, "Title mismatch")
	
	# Simulate player clicking Notebook button inside InspectionPanel
	var ts_notebook_panel: NotebookPanel = tea_shop_scene.get_node("%NotebookPanel")
	assert(ts_notebook_panel != null, "NotebookPanel must exist in tea_shop")
	assert(ts_notebook_panel.z_index > loc_inspect_panel.z_index, "NotebookPanel z_index must be higher than InspectionPanel")
	
	loc_inspect_panel.notebook_button.pressed.emit()
	await process_frame
	assert(ts_notebook_panel.visible == true, "NotebookPanel must pop open over InspectionPanel")
	assert(loc_inspect_panel.visible == true, "InspectionPanel must stay open underneath NotebookPanel")
	
	ts_notebook_panel.close_notebook()
	await process_frame
	assert(ts_notebook_panel.visible == false, "NotebookPanel must close")
	assert(loc_inspect_panel.visible == true, "InspectionPanel must remain visible after closing NotebookPanel")
	
	loc_inspect_panel.close_inspection()
	await process_frame
	assert(loc_inspect_panel.visible == false, "InspectionPanel should close back to tea shop")
	
	# Simulate player clicking ClockHotspot in the tea shop
	ck_hotspot.interact()
	await process_frame
	assert(loc_inspect_panel.visible == true, "Clicking ClockHotspot must open InspectionPanel")
	assert("Clock" in loc_inspect_panel.object_title_label.text, "Clock title mismatch")
	
	loc_inspect_panel.close_inspection()
	await process_frame
	assert(loc_inspect_panel.visible == false, "InspectionPanel should close back to tea shop")
	
	tea_shop_scene.queue_free()
	await process_frame
	print("✔ Test 3: Tea Shop scene hotspot integration & return-to-room verified.")
	
	# =========================================================================
	# TEST 4: Bilingual Support for Object Inspection
	# =========================================================================
	game_state.set_language("my")
	var burmese_data = Localization.get_inspection_data("tea_notebook", "my")
	assert(not burmese_data.is_empty(), "Burmese inspection data must exist for tea_notebook")
	assert("သားရေမှတ်စုစာအုပ်" in burmese_data["title"], "Burmese title mismatch: " + burmese_data["title"])
	assert("စားပွဲအမှတ် (၃)" in burmese_data["subtitle"], "Burmese subtitle mismatch")
	assert(burmese_data["areas"].size() == 3, "Burmese areas count mismatch")
	
	game_state.set_language("en")
	print("✔ Test 4: Bilingual localization for inspection system verified.")
	
	print("--- ALL OBJECT INSPECTION SYSTEM TESTS PASSED SUCCESSFULLY ---")
	quit(0)

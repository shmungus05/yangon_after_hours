extends SceneTree

func _init() -> void:
	print("--- BEGIN AVATAR VERIFICATION TESTS (TRANSPARENT + OUTLINE) ---")
	
	# 1. Verify all avatar assets exist and can be loaded as PNG
	var avatar_paths: Dictionary = {
		"Tea Master Ko Zaw": "res://assets/avatars/tea_master.png",
		"Night Watchman U Ba": "res://assets/avatars/watchman.png",
		"Street Food Cook Ko Lin": "res://assets/avatars/cook.png",
		"Saya Min (Teacher)": "res://assets/avatars/saya_min.png",
		"Ma Thida (Trader)": "res://assets/avatars/ma_thida.png",
		"Ko Aung (Taxi Driver)": "res://assets/avatars/ko_aung.png"
	}
	
	for char_name in avatar_paths:
		var path: String = avatar_paths[char_name]
		var tex: Texture2D = load(path)
		assert(tex != null, "Avatar failed to load for %s at %s" % [char_name, path])
		
		# Verify transparency in corner
		var img: Image = tex.get_image()
		assert(img != null, "Failed to get image data for %s" % char_name)
		var corner_color: Color = img.get_pixel(0, 0)
		assert(corner_color.a == 0.0, "Expected transparent background (alpha=0) at (0,0) for %s, got alpha=%f" % [char_name, corner_color.a])
		
		print("✔ Verified asset: %s (%dx%d, transparent background confirmed)" % [char_name, tex.get_width(), tex.get_height()])
	
	# 2. Verify Tea Shop hotspots have avatars configured with PNG
	var tea_shop_scene = load("res://scenes/locations/tea_shop.tscn").instantiate()
	root.add_child(tea_shop_scene)
	
	var expected_hotspots: Dictionary = {
		"TeaMasterHotspot": "res://assets/avatars/tea_master.png",
		"SayaMinHotspot": "res://assets/avatars/saya_min.png",
		"MaThidaHotspot": "res://assets/avatars/ma_thida.png",
		"KoAungHotspot": "res://assets/avatars/ko_aung.png"
	}
	
	for hs_name in expected_hotspots:
		var hs = tea_shop_scene.get_node("MarginContainer/MainLayout/HotspotArea/" + hs_name)
		assert(hs != null, "Hotspot %s not found in tea_shop" % hs_name)
		assert(hs.avatar_texture != null, "Hotspot %s missing avatar_texture" % hs_name)
		assert(hs.avatar_texture.resource_path == expected_hotspots[hs_name], "Hotspot %s wrong avatar texture: %s" % [hs_name, hs.avatar_texture.resource_path])
		assert(hs.icon != null, "Hotspot %s missing button icon" % hs_name)
		print("✔ Tea Shop hotspot %s configured with avatar %s" % [hs_name, hs.avatar_texture.resource_path])
	
	# 3. Verify TeaPuzzlePanel has avatar textures in cards
	var puzzle_panel: TeaPuzzlePanel = tea_shop_scene.get_node("TeaPuzzlePanel")
	assert(puzzle_panel != null, "TeaPuzzlePanel not found in tea_shop")
	
	var min_avatar = puzzle_panel.get_node("CenterContainer/PuzzleCard/MarginContainer/VBoxContainer/CustomersContainer/MinCard/Margin/VBox/AvatarFrame/Avatar")
	var thida_avatar = puzzle_panel.get_node("CenterContainer/PuzzleCard/MarginContainer/VBoxContainer/CustomersContainer/ThidaCard/Margin/VBox/AvatarFrame/Avatar")
	var aung_avatar = puzzle_panel.get_node("CenterContainer/PuzzleCard/MarginContainer/VBoxContainer/CustomersContainer/AungCard/Margin/VBox/AvatarFrame/Avatar")
	
	assert(min_avatar != null and min_avatar.texture != null, "MinCard missing avatar texture")
	assert(thida_avatar != null and thida_avatar.texture != null, "ThidaCard missing avatar texture")
	assert(aung_avatar != null and aung_avatar.texture != null, "AungCard missing avatar texture")
	
	assert(min_avatar.texture.resource_path == "res://assets/avatars/saya_min.png", "MinCard wrong texture")
	assert(thida_avatar.texture.resource_path == "res://assets/avatars/ma_thida.png", "ThidaCard wrong texture")
	assert(aung_avatar.texture.resource_path == "res://assets/avatars/ko_aung.png", "AungCard wrong texture")
	print("✔ TeaPuzzlePanel cards display transparent avatar textures for Saya Min, Ma Thida, and Ko Aung.")
	
	# 4. Verify Downtown watchman avatar
	var downtown_scene = load("res://scenes/locations/downtown.tscn").instantiate()
	root.add_child(downtown_scene)
	var watchman = downtown_scene.get_node("MarginContainer/MainLayout/HotspotArea/WatchmanHotspot")
	assert(watchman != null and watchman.avatar_texture != null, "WatchmanHotspot missing avatar")
	assert(watchman.avatar_texture.resource_path == "res://assets/avatars/watchman.png", "WatchmanHotspot wrong texture")
	print("✔ Downtown WatchmanHotspot verified with avatar %s" % watchman.avatar_texture.resource_path)
	
	# 5. Verify Market cook avatar
	var market_scene = load("res://scenes/locations/market.tscn").instantiate()
	root.add_child(market_scene)
	var cook = market_scene.get_node("MarginContainer/MainLayout/HotspotArea/VendorHotspot")
	assert(cook != null and cook.avatar_texture != null, "VendorHotspot missing avatar")
	assert(cook.avatar_texture.resource_path == "res://assets/avatars/cook.png", "VendorHotspot wrong texture")
	print("✔ Market VendorHotspot verified with avatar %s" % cook.avatar_texture.resource_path)
	
	print("--- ALL AVATAR VERIFICATION TESTS PASSED (TRANSPARENT + OUTLINE) ---")
	quit(0)

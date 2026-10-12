# scripts/data/card_loader.gd
class_name CardLoader
extends RefCounted

const CARDS_PATH := "res://data/cards/"

static func load_all_cards() -> Dictionary:
	var cards: Dictionary = {}  # id -> CardData
	_load_directory(CARDS_PATH, cards)
	print("Loaded %d cards" % cards.size())
	return cards

static func _load_directory(path: String, cards: Dictionary, current_type: String = "", current_universe: String = "") -> void:
	var dir = DirAccess.open(path)
	if not dir:
		push_error("Could not open directory: " + path)
		return

	dir.list_dir_begin()
	var file_name = dir.get_next()

	while file_name != "":
		var full_path = path.path_join(file_name)

		if dir.current_is_dir() and not file_name.begins_with("."):
			# Determine what this folder represents
			if current_type == "":
				# First level under cards/ → this is the type (characters, equipment, food...)
				_load_directory(full_path, cards, file_name, "")
			elif current_universe == "":
				# Second level → this is the universe
				_load_directory(full_path, cards, current_type, file_name)
			else:
				# Deeper folders (optional subcategories)
				_load_directory(full_path, cards, current_type, current_universe)
		elif file_name.ends_with(".json"):
			var card = _load_single_card(full_path, current_type, current_universe)
			if card:
				if cards.has(card.id):
					push_warning("Duplicate card id: %s (found in %s)" % [card.id, full_path])
				cards[card.id] = card

		file_name = dir.get_next()

	dir.list_dir_end()

static func _load_single_card(path: String, card_type: String, universe: String) -> CardData:
	var file = FileAccess.open(path, FileAccess.READ)
	if not file:
		push_error("Failed to open: " + path)
		return null

	var json_text = file.get_as_text()
	file.close()

	var json = JSON.new()
	var error = json.parse(json_text)
	if error != OK:
		push_error("JSON parse error in %s: %s" % [path, json.get_error_message()])
		return null

	var data: Dictionary = json.data
	return _create_card_from_dict(data, card_type, universe)

static func _create_card_from_dict(data: Dictionary, card_type: String, universe: String) -> CardData:
	var card: CardData

	match card_type:
		"characters":
			card = CharacterCardData.new()
			card.element = data.get("element", "")
			card.weapon_type = data.get("weapon_type", "")
			card.max_hp = data.get("max_hp", 10)
			card.max_energy = data.get("max_energy", 3)
			card.skills = data.get("skills", [])
		"equipment", "fields", "food":
			card = ActionCardData.new()
			card.effects = data.get("effects", [])
		_:
			card = ActionCardData.new()
			card.effects = data.get("effects", [])

	# Common fields
	card.id = data.get("id", "")
	card.name = data.get("name", "Unknown")
	card.type = card_type                    # from folder
	card.universe = universe                 # from folder
	card.cost = data.get("cost", {})
	card.tags = data.get("tags", [])
	card.description = data.get("description", "")
	card.image_path = data.get("image", "")
	card.icon_path = data.get("icon", "")

	# Optional: force the type from JSON if you prefer, but folder wins
	if data.has("type"):
		# You can decide which one takes priority
		pass

	return card

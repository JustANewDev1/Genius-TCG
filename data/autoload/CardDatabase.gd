# CardDatabase.gd  (this should be an Autoload)
extends Node

var cards: Dictionary = {}   # id -> CardData

func _ready() -> void:
	cards = CardLoader.load_all_cards()
	print("CardDatabase ready. Total cards: ", cards.size())

func get_card(id: String) -> CardData:
	return cards.get(id)

func get_all_characters() -> Array[CharacterCardData]:
	var result: Array[CharacterCardData] = []
	for card in cards.values():
		if card is CharacterCardData:
			result.append(card)
	return result

func get_characters_from(universe: String) -> Array[CharacterCardData]:
	var result: Array[CharacterCardData] = []
	for card in cards.values():
		if card is CharacterCardData and card.universe == universe:
			result.append(card)
	return result

func get_cards_by_type(type: String) -> Array:
	var result: Array = []
	for card in cards.values():
		if card.type == type:
			result.append(card)
	return result

func get_cards_by_universe(universe: String) -> Array:
	var result: Array = []
	for card in cards.values():
		if card.universe == universe:
			result.append(card)
	return result

func get_all_universes() -> Array[String]:
	var universes: Array[String] = []
	for card in cards.values():
		if not universes.has(card.universe):
			universes.append(card.universe)
	return universes

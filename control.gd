
extends Control

var card_scene = preload("res://scenes/card/card.tscn")

func _ready() -> void:
	var card = card_scene.instantiate()
	add_child(card)

	card.position = Vector2(0, 0)

	# Temporary test data
	var test_data = CharacterCardData.new()
	test_data.name = "Diluc"
	test_data.type = "characters"
	test_data.max_hp = 10
	test_data.image_path = "res://assets/cards/genshin/diluc.png"

	card.setup(test_data)

# game.gd
extends Node2D  # or Control

@onready var character_slots: HBoxContainer = $CharacterSlots  # or whatever you name it

func _ready() -> void:
	_spawn_player_characters()

func _spawn_player_characters() -> void:
	for child in character_slots.get_children():
		child.queue_free()
	
	for data in GameState.player_characters:
		var card = preload("res://scenes/card/card.tscn").instantiate()
		character_slots.add_child(card)
		card.setup(data)

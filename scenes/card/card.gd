# card.gd
class_name Card
extends Control

@onready var art: TextureRect = $Art
@onready var frame: TextureRect = $Frame
@onready var cost_container: HBoxContainer = $CostContainer

var data: CardData

func setup(card_data: CardData, use_icon: bool = false) -> void:
	data = card_data
	
	var path := ""
	
	if use_icon:
		path = data.icon_path
	else:
		path = data.image_path
	
	if path != "" and ResourceLoader.exists(path):
		art.texture = load(path)
	else:
		art.texture = null
		print("Missing texture: ", path)
	
	# Hide cost on character icons
	cost_container.visible = not use_icon and not (data is CharacterCardData)
	
	for child in cost_container.get_children():
		child.queue_free()

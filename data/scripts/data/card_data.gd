# scripts/data/card_data.gd
class_name CardData
extends Resource

@export var id: String
@export var name: String
@export var type: String          # "characters", "equipment", "fields", "food"
@export var universe: String      # "genshin", "honkai", "fate", etc.
@export var cost: Dictionary = {}
@export var tags: Array[String] = []
@export var description: String = ""
@export var image_path: String = ""
@export var icon_path: String = ""

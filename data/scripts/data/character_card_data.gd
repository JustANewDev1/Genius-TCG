# scripts/data/character_card_data.gd
class_name CharacterCardData
extends CardData

@export var element: String
@export var weapon_type: String
@export var max_hp: int = 10
@export var max_energy: int = 3
@export var skills: Array[Dictionary] = []   # or make a SkillData resource later

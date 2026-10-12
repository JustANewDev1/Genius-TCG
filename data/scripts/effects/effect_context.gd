# scripts/effects/effect_context.gd
class_name EffectContext
extends RefCounted

var source_character: CharacterInstance
var target_character: CharacterInstance
var skill_id: String = ""
var extra: Dictionary = {}         # flexible bag for anything

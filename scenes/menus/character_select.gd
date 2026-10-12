extends Control

@onready var card_grid: GridContainer = $CardGrid
@onready var selected_bar: HBoxContainer = $SelectedBar
@onready var confirm_button: Button = $ConfirmButton
@onready var warning_label: Label = $WarningLabel

var selected: Array[CharacterCardData] = []
const MAX_SELECTED := 3

func _ready() -> void:
	confirm_button.disabled = true
	warning_label.text = "Select 3 characters"
	
	var characters = CardDatabase.get_all_characters()
	
	for char_data in characters:
		var card := preload("res://scenes/card/card.tscn").instantiate() as Card
		card_grid.add_child(card)
		card.setup(char_data, true)  # force icon
		card.gui_input.connect(_on_card_clicked.bind(card, char_data))

func _on_card_clicked(event: InputEvent, card: Card, data: CharacterCardData) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_toggle_selection(card, data)

func _toggle_selection(card: Card, data: CharacterCardData) -> void:
	if data in selected:
		selected.erase(data)
		card.modulate = Color.WHITE
	else:
		if selected.size() >= MAX_SELECTED:
			return
		selected.append(data)
		card.modulate = Color(0.6, 1.0, 0.6)
	
	_update_ui()

func _update_ui() -> void:
	for child in selected_bar.get_children():
		child.queue_free()
	
	for data in selected:
		var mini := preload("res://scenes/card/card.tscn").instantiate() as Card
		selected_bar.add_child(mini)
		mini.setup(data, true)  # still use icon
		mini.custom_minimum_size = Vector2(140, 246)
		mini.scale = Vector2(0.33, 0.33)
	
	confirm_button.disabled = selected.size() != MAX_SELECTED
	warning_label.text = "Selected: %d / 3" % selected.size()

func _on_confirm_button_pressed() -> void:
	GameState.player_characters = selected.duplicate()
	get_tree().change_scene_to_file("res://scenes/game/game.tscn")

extends HBoxContainer

@onready var texture_rect: TextureRect = %TextureRect
@onready var label: RichTextLabel = %Label


func set_icon_text(icon: Texture2D, text: String) -> void:
    texture_rect.texture = icon
    label.text = text

func change_icon(icon: Texture2D) -> void:
    texture_rect.texture = icon

func change_text(text: String) -> void:
    label.text = text

extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	#pass
	for n in get_line_count():
		await get_tree().create_timer(1).timeout
		scroll_to_line(n+1)

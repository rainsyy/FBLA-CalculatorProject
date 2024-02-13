extends VBoxContainer

var classRow = preload("res://Assets/Class.tscn")

func _on_add_course_button_button_up():
	$KeyboardSound.play()
	var newClass = classRow.instantiate()
	get_node("BoxBackground/MarginContainer/ScrollContainer/VBoxContainer").add_child(newClass)


func _on_class_type_item_selected(index):
	$BlipSound.play()


func _on_course_edit_text_changed(new_text):
	$KeyboardSound.play()


func _on_credits_text_changed(new_text):
	$KeyboardSound.play()


func _on_grade_item_selected(index):
	$BlipSound.play()

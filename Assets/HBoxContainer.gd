extends HBoxContainer

func _on_course_edit_text_changed(new_text):
	$KeyboardSound.play()


func _on_grade_item_selected(index):
	$BlipSound.play()


func _on_credits_text_changed(new_text):
	$KeyboardSound.play()


func _on_class_type_item_selected(index):
	$BlipSound.play()

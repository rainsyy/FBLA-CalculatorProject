extends Control

var gradesList = []
var numberedGradesList = []
var weightedGradesList = []
var gpaScaledGradesList = []
var creditsList = []
var classTypeList = []
var filteredGradesList = []

var gradeDictionary = {'A+': 97, 'A': 93, 'A-': 90, 'B+': 87, 'B': 83, 'B-': 80, 'C+': 77, 'C': 73, 'C-': 70, 'F+': 67, 'F': 65, 'F-': 59}

var gradeLetter = preload("res://gradeLetter.tscn")
var gradeNumber = preload("res://grade.tscn")
var semesterTab = preload("res://Assets/Semester_1.tscn")
@onready var currentSemester = $"HBoxContainer/ScrollContainer/TabContainer/Semester 1"

var weighted = true
var letters = true
var semesternumber = 2
var newGrade = 0
var gradeSum = 0
var creditSum = 0
var tabNumber = 1
var gpa = 0
var previousGpa = 0
var previousCredits = 0
var grade = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _resetValues():
	newGrade = 0
	gradeSum = 0
	creditSum = 0
	gpa = 0
	grade = 0
	gradesList = []
	numberedGradesList = []
	weightedGradesList = []
	gpaScaledGradesList = []
	creditsList = []
	classTypeList = []
	filteredGradesList = [] 

func _on_calculate_button_button_up():
	$CalculateSound.play()
	_resetValues()
	getValues()

func getValues():
	var semesterlist = get_node("HBoxContainer/ScrollContainer/TabContainer")
	previousGpa = float($SettingsContainer/VBoxContainer/MarginContainer2/VBoxContainer/VBoxContainer/HBoxContainer4/gpaSpinBox.value)
	previousCredits = float($SettingsContainer/VBoxContainer/MarginContainer2/VBoxContainer/VBoxContainer/HBoxContainer4/creditsSpinBox.value)
	
	for semester in semesterlist.get_children():
		var classes = semester.get_node("BoxBackground/MarginContainer/ScrollContainer/VBoxContainer")
		for child in classes.get_children():
			if child.get_class() == "MarginContainer":
				if letters == true:
					grade = child.get_node("HBoxContainer/Control/Grade").get_text()
				elif letters == false:
					var control = child.get_node("HBoxContainer/Control")
					for controlchild in control.get_children():
						if controlchild.get_class() == "SpinBox":
							grade = controlchild.value
				
				var credit = int(child.get_node("HBoxContainer/Credits").get_text())
				var classType = child.get_node("HBoxContainer/ClassType").get_text()
				
				if letters == true:
					if grade != "Grade":
						gradesList.append(grade)
				elif letters == false:
					if grade >= 1:
						gradesList.append(grade)
				if str(credit) >= "-1":
					creditsList.append(credit)
				if classType:
					classTypeList.append(classType)
					
				for i in range(0, creditsList.size()):
					creditSum = creditSum + creditsList[i]
				
				if gradesList == [] && creditSum == 0:
					currentSemester.get_node("BoxBackground/BottomBar/MarginContainer/HBoxContainer/DebugLabel").text = "Add grades and credits before calculating!"
				elif gradesList == []:
					currentSemester.get_node("BoxBackground/BottomBar/MarginContainer/HBoxContainer/DebugLabel").text = "Add grades before calculating!"
				elif creditSum == 0:
					currentSemester.get_node("BoxBackground/BottomBar/MarginContainer/HBoxContainer/DebugLabel").text = "Add credits before calculating!"
				else:
					currentSemester.get_node("BoxBackground/BottomBar/MarginContainer/HBoxContainer/DebugLabel").text = ""
	creditSum = 0
	_convertToNumbers()

func _convertToNumbers():
	if letters == true:
		for i in range(0, gradesList.size()):
			numberedGradesList.append(gradeDictionary[gradesList[i]])
	elif letters == false:
		for i in range(0, gradesList.size()):
			numberedGradesList.append(gradesList[i])
	if weighted == true:
		_addClassTypeBonuses()
		print("adding type bonuses")
	else:
		print("skipping type bonuses")
		_convertToGpaScale(numberedGradesList)
	

func _addClassTypeBonuses():
	for i in range(0, numberedGradesList.size()):
		if classTypeList[i] == "Regular":
			weightedGradesList.append(numberedGradesList[i])
		if classTypeList[i] == "Honors":
			weightedGradesList.append(float(numberedGradesList[i]) + 3)
		if classTypeList[i] == "AP":
			weightedGradesList.append(float(numberedGradesList[i]) + 5)
		if classTypeList[i] == "College":
			weightedGradesList.append(numberedGradesList[i])
			
	print(weightedGradesList)
	print(numberedGradesList)
	_convertToGpaScale(weightedGradesList)

func _convertToGpaScale(InputGradeList):

	for i in range(0, InputGradeList.size()):
		if InputGradeList[i] >= 97:
			gpaScaledGradesList.append("4.0")
		elif InputGradeList[i]>= 93:
			gpaScaledGradesList.append("4.0")
		elif InputGradeList[i]>= 90:
			gpaScaledGradesList.append("3.7")
		elif InputGradeList[i]>= 87:
			gpaScaledGradesList.append("3.3")
		elif InputGradeList[i]>= 83:
			gpaScaledGradesList.append("3.0")
		elif InputGradeList[i]>= 80:
			gpaScaledGradesList.append("2.7")
		elif InputGradeList[i]>= 77:
			gpaScaledGradesList.append("2.3")
		elif InputGradeList[i]>= 73:
			gpaScaledGradesList.append("2.0")
		elif InputGradeList[i]>= 70:
			gpaScaledGradesList.append("1.7")
		elif InputGradeList[i]>= 67:
			gpaScaledGradesList.append("1.3")
		elif InputGradeList[i]>= 65:
			gpaScaledGradesList.append("1.0")
		elif InputGradeList[i] < 65:
			gpaScaledGradesList.append("0")
	_calcGradePoints()
	print(gpaScaledGradesList)

func _calcGradePoints():

	for i in range(0, gpaScaledGradesList.size()):
		newGrade = float(gpaScaledGradesList[i]) * creditsList[i]
		filteredGradesList.append(newGrade)
	_calcGpa()

func _calcGpa():
	for i in range(0, filteredGradesList.size()):
		gradeSum = gradeSum + filteredGradesList[i]
		
	for i in range(0, creditsList.size()):
		creditSum = creditSum + creditsList[i]
	
	if gradeSum > 0:
		gpa = gradeSum / creditSum
		if previousGpa > 0 && previousCredits > 0:
			gpa = (gradeSum + (previousGpa * previousCredits)) / (previousCredits + creditSum)
		_setGpa(gpa)

func _setGpa(gpa):
	$SettingsContainer/VBoxContainer/GpaContainer/GpaLabel.text = str(snapped(gpa, 0.01))
	$SettingsContainer/VBoxContainer/MarginContainer/VBoxContainer/ProgressBar.value = gpa

func _on_add_semester_button_button_up():
	$AddSemesterSound.play()
	var newSemester = semesterTab.instantiate()
	semesternumber = semesternumber + 1
	newSemester.name = "Semester " + str(semesternumber)
	$HBoxContainer/ScrollContainer/TabContainer.add_child(newSemester)

func _on_tab_container_tab_changed(tab):
	$SwitchTabSounds.play()
	tabNumber = tab
	currentSemester = get_node("HBoxContainer/ScrollContainer/TabContainer/Semester" + str(tabNumber)) 

func _on_back_button_button_up():
	$MenuSound.play()
	get_tree().change_scene_to_file("res://MainMenu.tscn")

func _on_weighted_check_toggled(button_pressed):
	if button_pressed == true:
		$SliderOnSound.play()
	else:
		$SliderOffSound.play()
	weighted = button_pressed
	print(weighted)
	
func _on_letter_check_toggled(button_pressed):
	if button_pressed == true:
		$SliderOnSound.play()
	else:
		$SliderOffSound.play()
	letters = button_pressed
	convertToLettersOrNumbers()

func convertToLettersOrNumbers():
	if letters == true:
		var semesterlist = get_node("HBoxContainer/ScrollContainer/TabContainer")
		
		for semester in semesterlist.get_children():
			var classes = semester.get_node("BoxBackground/MarginContainer/ScrollContainer/VBoxContainer")
			for child in classes.get_children():
				if child.get_class() == "MarginContainer":
					var control = child.get_node("HBoxContainer/Control")
					for controlchild in control.get_children():
						if controlchild.get_class() == "SpinBox":
							controlchild.queue_free()
							var newgrade = gradeLetter.instantiate()
							newgrade.name = "Grade"
							child.get_node("HBoxContainer/Control").add_child(newgrade)
					
	elif letters == false:
		var semesterlist = get_node("HBoxContainer/ScrollContainer/TabContainer")
		
		for semester in semesterlist.get_children():
			var classes = semester.get_node("BoxBackground/MarginContainer/ScrollContainer/VBoxContainer")
			for child in classes.get_children():
				if child.get_class() == "MarginContainer":
					var grade = child.get_node("HBoxContainer/Control/Grade")
					grade.queue_free()
					var newgrade = gradeNumber.instantiate()
					newgrade.name = "Grade"
					child.get_node("HBoxContainer/Control").add_child(newgrade)



func _on_gpa_spin_box_value_changed(value):
	$SwitchTabSounds.play()

func _on_credits_spin_box_value_changed(value):
	$SwitchTabSounds.play()

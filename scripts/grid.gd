extends Node2D

@onready var global_data = get_node("/root/GlobalData")

static var instance

var slots = []

var block = preload("res://prefabs/block.tscn")

func _ready():
	instance = self
	create_grid()
	fill_top_row()
		


func _process(_delta):
	fill_top_row()


func create_grid():
	slots = []
	for i in range(global_data.rows):
		var col = []
		for j in range(global_data.columns):
			col.append(false)
		slots.append(col)


func fill_all():
	for y in range(slots.size()):
		for x in range(slots[y].size()):
			create_block(x, y)


func fill_top_row():
	var firstRow = slots[0]
	for x in range(firstRow.size()):
		if is_slot_empty(x, 0):
			create_block(x, 0)
		
		
func create_block(x, y, num = -1):
	var instance = block.instantiate()
	instance.x = x
	instance.y = y
	add_child(instance)
	instance.name = "block1"
	set_slot_to_filled(x, y)
	if num == -1:
		instance.blockNumber = random_power_of_2(1, 12)
	else:
		instance.blockNumber = num
		
	instance.blockColor = global_data.get_number_color(instance.blockNumber)
#	instance.blockColor = generate_color_from_number(instance.blockNumber)
	

func is_slot_empty(x, y):
	if y > global_data.rows - 1:
		return false
	if x > global_data.columns - 1:
		return false
	return !slots[y][x]


func set_slot_to_empty(x, y):
	slots[y][x] = false
	
	

func set_slot_to_filled(x, y):
	slots[y][x] = true



func random_power_of_2(minimum_exp, maximum_exp):
	var min_exp = int(minimum_exp)
	var max_exp = int(maximum_exp)

	# Ensure the inputs are powers of 2
	min_exp = max(1, min_exp)  # Minimum should be at least 2^1
	max_exp = max(min_exp, max_exp)  # Maximum should be at least the minimum

	# Calculate the random exponent and result
	var exponent = randi_range(min_exp, max_exp)
	var result = 2 ** exponent

	return result


# Function to generate a unique color based on a number
func generate_color_from_number(number):
	var scaled_number = (float(number) - 2.0) / (16384.0 - 2.0)
	var hue = fmod(scaled_number, 1.0)  # Map the number to the hue component (1.0 for a full range)
	var saturation = 0.9  # Adjust as needed
	var value = 0.9       # Adjust as needed
	return Color.from_hsv(hue, saturation, value)

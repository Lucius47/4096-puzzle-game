extends Node

const columns = 5
const rows = 8
var lerp_speed = 7
var grid_x_padding = 40.0
var grid_top_padding = 80.0
var grid_bottom_padding = 50.0
var screen_width = 360
var screen_height = 640
var block_gap = 10.0

var score = 0

# Declare the dictionary to store number-color mapping
var power_of_two_colors = generate_power_of_two_colors()

func get_number_color(number):
	return power_of_two_colors.get(number, Color(0, 0, 0))  # Default to white if not found


# Function to generate a dictionary mapping powers of 2 to vibrant colors
func generate_power_of_two_colors():
	var color_dict = {}

	for i in range(1, 14):  # 2^1 to 2^13 (8192)
		var power_of_two = pow(2, i)
		var hue = fmod(i * 37.0, 360.0) / 360.0  # Adjust as needed for more vibrant colors
		var saturation = 0.8  # Adjust as needed
		var value = 0.8       # Adjust as needed
		var color = Color.from_hsv(hue, saturation, value)
		color_dict[int(power_of_two)] = color

	return color_dict

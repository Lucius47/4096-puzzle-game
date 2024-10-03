extends TextureRect


@onready var line_draw = get_node("/root/LineDraw")
@onready var global_data = get_node("/root/GlobalData")

@onready var label = $Label
@onready var animation_player = $AnimationPlayer
@onready var gpu_particles_2d = $GPUParticles2D



var x
var y
var isSelected = false
var blockNumber = 0
var blockColor = Color(0.1, 0.1, 0.1)


func _ready():
	var rect_size_value = min(
		(global_data.screen_width - (global_data.grid_x_padding * 2) - ((global_data.columns - 1) * 10)) / global_data.columns,
		(global_data.screen_height - global_data.grid_top_padding - ((global_data.rows - 1) * 10)) / global_data.rows
	)

	# Calculate position
	position.x = x * rect_size_value  + (global_data.grid_x_padding/1.0) + (10 * x)
	position.y  = y * rect_size_value + (global_data.grid_top_padding/1.0) + (10 * y) - 50
	
	
func _process(delta):

	# Calculate the size of each square
	var rect_size_value = min(
		(global_data.screen_width - (global_data.grid_x_padding * 2) - ((global_data.columns - 1) * 10)) / global_data.columns,
		(global_data.screen_height - global_data.grid_top_padding - ((global_data.rows - 1) * 10)) / global_data.rows
	)

	# Calculate position
	var pos_x = x * rect_size_value  + (global_data.grid_x_padding/1.0) + (10 * x)
	var pos_y = y * rect_size_value + (global_data.grid_top_padding/1.0) + (10 * y)

	# Set position using lerp (if needed)
	position.x = lerp(position.x, pos_x, delta * global_data.lerp_speed)
	position.y = lerp(position.y, pos_y, delta * global_data.lerp_speed)

	# Set size
	custom_minimum_size.x = rect_size_value
	custom_minimum_size.y = rect_size_value
	size.x = rect_size_value
	size.y = rect_size_value
	
	# Set pivot
	pivot_offset.x = rect_size_value / 2
	pivot_offset.y = rect_size_value / 2

	
	label.text = str(blockNumber)
	
	set_self_modulate(blockColor) # set tint color
	
	if Grid.instance.is_slot_empty(x, y + 1):
		Grid.instance.set_slot_to_empty(x, y)
		y = y + 1
		Grid.instance.set_slot_to_filled(x, y)
	


func _on_panel_mouse_entered():
	line_draw._on_block_mouse_entered_2(self)

func _on_panel_gui_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
			line_draw._on_block_mouse_down(self)
			animation_player.play("block_select")
		elif event.is_released() and event.button_index == MOUSE_BUTTON_LEFT:
			line_draw._on_block_mouse_up(self)


func update_block(nextSum, color):
	animation_player.play("block_select")
	await animation_player.animation_finished
	blockNumber = nextSum
	blockColor = color

func destroy():
	gpu_particles_2d.emitting = true
	gpu_particles_2d.process_material.color = blockColor
	
#	await(gpu_particles_2d, "particle_done")
	
	animation_player.play("block_destroy")
	await animation_player.animation_finished
	Grid.instance.set_slot_to_empty(x, y)
	queue_free()

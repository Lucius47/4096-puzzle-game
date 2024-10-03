extends Control

@onready var block_text = $preview_block/block_text
@onready var preview_block = $preview_block
@onready var score_text = $score_text


@onready var line_draw = get_node("/root/LineDraw")
@onready var global_data = get_node("/root/GlobalData")



var number

func _ready():
	score_text.text = "0"
	preview_block.set_visible(false)
	line_draw.connect("next_sum_changed", self._on_line_2d_next_sum_changed)
	
	# Set size
	var rect_size_value = min(
		(global_data.screen_width - (global_data.grid_x_padding * 2) - ((global_data.columns - 1) * 10)) / global_data.columns,
		(global_data.screen_height - global_data.grid_top_padding - ((global_data.rows - 1) * 10)) / global_data.rows
	)
	preview_block.custom_minimum_size.x = rect_size_value
	preview_block.custom_minimum_size.y = rect_size_value
	preview_block.size.x = rect_size_value
	preview_block.size.y = rect_size_value



func _on_line_2d_next_sum_changed(next_sum, showPreview):
	number = line_draw.nextSum
	block_text.text = str(number)
	preview_block.set_self_modulate(global_data.get_number_color(number))
	score_text.text = str(global_data.score)
	
	preview_block.set_visible(showPreview)
	score_text.set_visible(!showPreview)

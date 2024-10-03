extends Line2D

@onready var global_data = get_node("/root/GlobalData")

signal next_sum_changed(next_sum, showPreview)

var isDrawing = false
var selectedBlocks = []
var sum = 0
var nextSum = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	clear_points()
	



func _input(event):
	if event is InputEventMouseMotion and isDrawing:
		set_point_position(get_point_count() - 1, get_local_mouse_position())



func _on_block_mouse_entered_2(block):
	
	# deselect previously selected block
	if block.isSelected:
		if selectedBlocks.size() > 1 and selectedBlocks[-2] == block:
			remove_point(get_point_count() - 2)
			selectedBlocks[selectedBlocks.size() - 1].isSelected = false
			selectedBlocks[selectedBlocks.size() - 1].animation_player.play("block_select")
			selectedBlocks.remove_at(selectedBlocks.size() - 1)
			sum -= block.blockNumber
			nextSum = next_pow_of_two(sum)
			next_sum_changed.emit(nextSum, selectedBlocks.size() > 1)
			return
	
	if !isDrawing or block.isSelected:
		return
		
		
	# if it is not an adjacent block
	if !(abs(block.x - selectedBlocks[-1].x) <= 1 and abs(block.y - selectedBlocks[-1].y) <= 1):
		return
	
	# block with same number as the previous block
	if block.blockNumber == selectedBlocks[-1].blockNumber:
		remove_point(get_point_count() - 1)
		isDrawing = false
		add_block(block)
		return
	
	# block with next po2 from the previous block
	if block.blockNumber == (selectedBlocks[-1].blockNumber * 2):
		# don't add if it's the 2nd block
		if selectedBlocks.size() != 1:
			remove_point(get_point_count() - 1)
			isDrawing = false
			add_block(block)
			return
		
	


func _on_block_mouse_down(_block):
	if !isDrawing and !_block.isSelected:
		add_block(_block)
		




func _on_block_mouse_up(_block):
	if isDrawing:
		clear_points()
		
		if selectedBlocks.size() > 1:
			for i in selectedBlocks.size():
				selectedBlocks[i].isSelected = false
				if i != selectedBlocks.size() - 1:
					selectedBlocks[i].destroy()
			selectedBlocks[-1].update_block(nextSum, global_data.get_number_color(nextSum))
#			selectedBlocks[-1].blockNumber = nextSum
#			selectedBlocks[-1].blockColor = global_data.get_number_color(selectedBlocks[-1].blockNumber)
			global_data.score += nextSum
		else:
			for blk in selectedBlocks:
				blk.isSelected = false
		
		sum = 0
		nextSum = 0
		next_sum_changed.emit(nextSum, false)
		selectedBlocks.clear()
		isDrawing = false


func add_block(_block):
	var point = Vector2(_block.position.x + (_block.size.x/2), _block.position.y + (_block.size.y/2))
	
	_block.animation_player.play("block_select")
	
	add_point(point)
	add_point(point)
	_block.isSelected = true
	selectedBlocks.append(_block)
	isDrawing = true
	
	sum += _block.blockNumber
	nextSum = next_pow_of_two(sum)
	next_sum_changed.emit(nextSum, selectedBlocks.size() > 1)


func next_pow_of_two(number):
	number -= 1
	number |= number >> 1
	number |= number >> 2
	number |= number >> 4
	number |= number >> 8
	number |= number >> 16
	return number + 1

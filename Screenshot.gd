extends Node

# Screenshots without hiccups using threads.
# Attach the script to a Node, start your game and hit F11
# 
# Tested in Godot 3.2 beta 5, Linux
# By Filip Lundby, https://twitter.com/skooterkurt

var _root_directory = "user://"
var _screenshot_directory = "screenshots"
var _capture_tasks = []
var _random = RandomNumberGenerator.new()
var _os_separator = "/"

func _ready():
	# Create directory
	_os_separator = "\\" if OS.get_name() == "Windows" else "/"
	var screenshot_directory = PoolStringArray([_root_directory, _screenshot_directory]).join(_os_separator)
	Directory.new().make_dir(screenshot_directory)

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_F11:
			_capture()

func _capture():
	# Start thread for capturing images
	var task = Thread.new()
	task.start(self, "_capture_thread", null)
	_capture_tasks.append(task)

func _capture_thread(_arg):
	# Save image
	_random.randomize()
	var image_filename = "capture_%s%s.png" % [OS.get_unix_time(), _random.randi_range(100000, 999999)]
	var godot_path = "%s/%s/%s" % [_root_directory, _screenshot_directory, image_filename]
	var image = get_viewport().get_texture().get_data()
	image.flip_y()
	image.save_png(godot_path)
	# Print path to image
	var os_path = PoolStringArray([OS.get_user_data_dir(), _screenshot_directory, image_filename]).join(_os_separator)
	print ("Screenshot saved to: %s" % os_path)

func _exit_tree():
	for task in _capture_tasks:
		task.wait_to_finish()

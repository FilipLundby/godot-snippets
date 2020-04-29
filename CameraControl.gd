extends Camera

# DESCRIPTION
# Move your camera smoothly between camera positions. Meant for 3D. 
#
# HOWTO
# 1. Attach the script to your camera. The camera should preferably be a 
#    child of the root-node of the scene.
# 2. Create one or more nodes of the type Position3D.
# 3. Add each of the Position3D-nodes to a group called "camera_positions".
# 4. Move each node to its desired location. The easiest way is to start 
#    the game, then adjust location and rotation in the editor - your game
#    will update on the fly.
# 5. Start the game (if you haven't already) and press C to switch camera. 
#
# Tested in Godot 3.2, Linux
# By Filip Lundby, https://twitter.com/skooterkurt

# Adjust the movement speed between camera locations
export var TRANSFORM_SPEED : float = 3

var _camera_transforms : Array = []
var _current_camera : int = 0
var _current_transform
var _target_transform

func _ready():
	_camera_transforms = get_tree().get_nodes_in_group("camera_positions")
	_current_transform = _camera_transforms[_current_camera].global_transform
	_target_transform = _current_transform

func _input(event):
    # Cycle between camera positions
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_C:	
            if _current_camera + 1 < len(_camera_transforms):
                _current_camera += 1
            else:
                _current_camera = 0

func _physics_process(delta):
	# Set camera to new position/rotation
	_target_transform = _camera_transforms[_current_camera].global_transform
	_current_transform = _current_transform.interpolate_with(_target_transform, delta * TRANSFORM_SPEED)
	global_transform = _current_transform

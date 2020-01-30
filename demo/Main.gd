extends Spatial

func _ready():
	# Find the interface and initialise
	var arvr_interface = ARVRServer.find_interface("OpenVR")
	if arvr_interface and arvr_interface.initialize():
		# switch to ARVR mode
		get_viewport().arvr = true
		
		# keep linear color space, not needed with the GLES2 renderer
		get_viewport().keep_3d_linear = true
		
		# make sure vsync is disabled or we'll be limited to 60fps
		OS.vsync_enabled = false
		
		# up our physics to 90fps to get in sync with our rendering
		Engine.target_fps = 90
	
	# just for testing, list what models are available
	# var ovr_model = preload("res://addons/godot-openvr/OpenVRRenderModel.gdns").new()
	# var model_names = ovr_model.model_names()
	# print("models: " + str(model_names))

func _process(delta):
	# Test for escape to close application, space to reset our reference frame
	if (Input.is_key_pressed(KEY_ESCAPE)):
		get_tree().quit()
	elif (Input.is_key_pressed(KEY_SPACE)):
		# Calling center_on_hmd will cause the ARVRServer to adjust all tracking data so the player is centered on the origin point looking forward
		ARVRServer.center_on_hmd(true, true)

func _on_left_hand_picked_up(what):
	# left hand picked up something, disable the teleporter
	$OVRFirstPerson/Left_Hand/Function_Teleport.enabled = false
	
	# and hide our controller mesh
	$OVRFirstPerson/Left_Hand.show_controller_mesh = false

func _on_left_hand_dropped():
	# enable it again
	$OVRFirstPerson/Left_Hand/Function_Teleport.enabled = true
	
	# and show our controller mesh
	$OVRFirstPerson/Left_Hand.show_controller_mesh = true

func _on_Function_Pickup_has_picked_up(what):
	# hide our controller mesh
	$OVRFirstPerson/Right_Hand.show_controller_mesh = false

func _on_Function_Pickup_has_dropped():
	# show our controller mesh
	$OVRFirstPerson/Right_Hand.show_controller_mesh = true

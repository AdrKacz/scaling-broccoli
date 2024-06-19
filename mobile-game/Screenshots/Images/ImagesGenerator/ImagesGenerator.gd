extends Node

@export var configurations: Array[ImageConfiguration] = []

@export var resolutions: Dictionary = {
	"6.7": Vector2(1290, 2796),
	"6.5": Vector2(1284, 2778),
	"5.5": Vector2(1242, 2208),
	"12.9": Vector2(2048, 2732)
}

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in configurations.size():
		print("Load configuretion number:", i + 1)
		var configuration: ImageConfiguration = configurations[i]
		# Set random variable
		configuration.speed_lines_seed = 904.81 * (randf() + 0.913847)
		print('Speed lines seed: ', configuration.speed_lines_seed)
		
		$Image.load_configuration(configuration)
		await get_tree().create_timer(0.5).timeout
		for resolution: String in resolutions.keys():
			print('Update to resolution: ', resolution)
			DisplayServer.window_set_size(resolutions.get(resolution))
			await get_tree().create_timer(0.1).timeout
			
			var screenshot = get_viewport().get_texture().get_image()
			screenshot.save_png('res://../screenshots/' + resolution.replace('.', '') + '-' + str(i) + '.png')
	get_tree().quit()

extends StaticBody2D

func _ready():
	var placeholder = find_node("Placeholder_Sprite")
	
	remove_child(placeholder)
	
	var field = find_node("Field")
	
	var extents = field.get_shape().get_extents()
	var width = extents.width
	var height = extents.height
	
	generate_random_asteroids(width, height, get_scale())
	

func generate_random_asteroids(width, height, scale):
	var texture = preload("res://sprites/asteroids/asteroids.png")
	var texture_size = texture.get_size()
	var step = texture_size.width/64 #64 sprites
	var possible_sprites = texture_size.width / step
	
	var minx = -width
	var maxx = width
	var miny = -height
	var maxy = height
	
	var templates = []
	
	var min_size = 10
	var max_width = 0.16 * width
	var max_height = 0.16 * height
	var max_size = min(max_width, max_height) #take smaller not to exceed bouds
		
	
	var area = width * height
	var asteroid_area = max_size * max_size
	var no_asteroids = int(1 * (area / asteroid_area))
	
	for i in range(no_asteroids):
		randomize()
		var sprite_s = rand_range(min_size, max_size)
		
		var x = rand_range(minx + sprite_s/2, maxx - sprite_s/2)
		var y = rand_range(miny + sprite_s/2, maxy - sprite_s/2)
		
		while overlapping_asteroids(templates, sprite_s, x, y):
			randomize()
			sprite_s = rand_range(min_size, max_size)
			x = rand_range(minx + sprite_s/2, maxx - sprite_s/2)
			y = rand_range(miny + sprite_s/2, maxy - sprite_s/2)
		
		var template = {}
		template.x = x
		template.y = y
		template.s = sprite_s
		templates.push_back(template)
		
	
	for template in templates:
		var sprite = Sprite.new()
		sprite.set_texture(texture)
		sprite.set_pos(Vector2(template.x, template.y))
		
		#calculate size
		#template.w = step * w_percent
		var w_percent = template.s / step
		var h_percent = template.s / texture_size.height
		
		sprite.set_scale(Vector2(w_percent, h_percent))
		sprite.set_rot(rand_range(-PI, PI))
		sprite.set_region(true)
		
		#get radom asteroid
		var rand = randi()%(int(possible_sprites)-1)+0
		sprite.set_region_rect(Rect2(Vector2(rand*step, 0), Vector2(step, texture_size.height)))
		
		add_child(sprite)

func overlapping_asteroids(templates, s, x, y):
	var overlapping = false
	
	for template in templates:
		if x + s/2 >= template.x - template.s/2 \
		and x - s/2 <= template.x + template.s/2 \
		and y + s/2 >= template.y - template.s/2 \
		and y - s/2 <= template.y + template.s/2:
			overlapping = true
			break
	
	return overlapping
	
	
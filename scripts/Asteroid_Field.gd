extends StaticBody2D

onready var texture = preload("res://sprites/asteroids/asteroids.png")
const SPRITES_PER_ROW = 32
const COLUMNS = 2

func _ready():
	var placeholder = find_node("Placeholder_Sprite")
	
	remove_child(placeholder)
	
	var field = find_node("Field")
	
	var extents = field.get_shape().get_extents()
	var width = extents.width
	var height = extents.height
	
	generate_random_asteroids(width, height, get_scale())
	

func generate_random_asteroids(width, height, scale):
	var texture_size = texture.get_size()
	var step = texture_size.width/SPRITES_PER_ROW #32 sprites
	var possible_sprites = texture_size.width / step
	var column_h = texture_size.height / COLUMNS
	
	var minx = -width
	var maxx = width
	var miny = -height
	var maxy = height
	
	var templates = []
	
	var min_size = 10
	var max_width = 0.1 * width
	var max_height = 0.1 * height
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
		sprite.set_pos(Vector2(template.x, template.y))
		
		#calculate size
		#template.w = step * w_percent
		var w_percent = template.s / step
		var h_percent = template.s / (column_h)
		
		sprite.set_scale(Vector2(w_percent, h_percent))
		sprite.set_rot(rand_range(-PI, PI))
		sprite.set_region(true)
		
		#get radom asteroid
		sprite.set_texture(texture)
		var row = randi()%(int(possible_sprites*COLUMNS)-1)+0
		var column = 0
		while row > SPRITES_PER_ROW: 
			column += 1
			row -= SPRITES_PER_ROW
			
		sprite.set_region_rect(Rect2(Vector2(row*step, 0*step), Vector2(step, column_h)))
		
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
	
	